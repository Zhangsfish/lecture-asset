"""Validate Chinese localization against frozen English geometry and Git bytes."""
from pathlib import Path
import ast
import hashlib
import json
import subprocess
import numpy as np
from PIL import Image, ImageDraw
from phone_overlays_zh_hans import apply_overlay, NAMES, DELETE_TITLE, DELETE_BODY

ROOT = Path(__file__).resolve().parents[1]
BASE = '0e6c1670ffe1464532c11356d3d5824e459aff39'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
english = json.loads((ROOT/'RENDER_MANIFEST.json').read_text(encoding='utf-8'))
records = json.loads((ROOT/'RENDER_MANIFEST_ZH_HANS.json').read_text(encoding='utf-8'))
old_ast=ast.parse((ROOT/'scripts/render_store.py').read_text(encoding='utf-8'))
new_ast=ast.parse((ROOT/'scripts/render_store_zh_hans.py').read_text(encoding='utf-8'))
for function in ['background','panel','check','arrow','slide_card','file_card']:
    old=next(n for n in old_ast.body if isinstance(n,ast.FunctionDef) and n.name==function)
    new=next(n for n in new_ast.body if isinstance(n,ast.FunctionDef) and n.name==function)
    assert ast.dump(old)==ast.dump(new), function
assert len(records) == len(english) == 6
expected_headlines = [
 ['一场讲座。','几十张 PPT 照片。'], ['批量选好。','按拍摄时间排好。'],
 ['一次生成','AI ZIP 和 PDF。'], ['PDF 留着。','以后随时回看。'],
 ['把 AI ZIP 交给 AI。','继续理解这场讲座。'], ['先保存。','再决定清理什么。']]
assert [r['headline_lines'] for r in records] == expected_headlines
assert records[0]['subtitle'] == '很少再翻，又舍不得删。'
assert records[1]['subtitle'] == '长按并滑动，连续选择。'
for index, required in [(4, ['导出后 · AI 工具示例','AI 工作区','示例','总结','提问','学习笔记','讲座资料','使用能读取图片的 AI 工具。']),
                        (5, ['确认 ZIP 已保存','删除源照片','保留相册照片，','清除 App 文件','删除源照片仍需单独确认。'])]:
    actual={v['text'] for v in records[index]['external_text_bounds']}
    assert set(required)<=actual

captures = {r['file']: r for r in json.loads((ROOT/'captures/zh-Hans/CAPTURES.json').read_text(encoding='utf-8'))}
assert NAMES == ['AI', '我的电脑', '对话', '朋友']
assert not list((ROOT/'illustrative-assets').glob('*'))
protected = list((ROOT/'store/en').glob('*.png')) + [ROOT/n for n in ['CONTACT_SHEET.png', 'RENDER_MANIFEST.json', 'IMAGE_VALIDATION.json']]
unchanged = []
for path in protected:
    old = subprocess.check_output(['git', 'show', BASE+':'+path.relative_to(Path.cwd()).as_posix()])
    local = path.read_bytes()
    identical = local == old
    if path.suffix == '.json':
        assert local.replace(b'\r\n',b'\n') == old.replace(b'\r\n',b'\n'), path
    else:
        assert identical, path
    entry={'file':path.relative_to(ROOT).as_posix(), 'sha256':sha(path), 'git_content_unchanged':True}
    if path.suffix=='.png': entry['byte_identical']=identical
    else: entry['line_endings']='Existing Windows CRLF checkout normalized only for Git comparison'
    unchanged.append(entry)
assert not subprocess.check_output(['git','diff',BASE,'--','App','AppResources','Packages','schemas','project.yml'])
provenance = json.loads((ROOT/'captures/zh-Hans/PROVENANCE.json').read_text(encoding='utf-8'))
assert subprocess.check_output(['git','rev-parse',BASE+':App'],text=True).strip() == (ROOT/'captures/zh-Hans/app-tree.txt').read_text().strip()
assert [records[i]['raw'] for i in [2,4,5]] == ['store-zh-hans-ready.png']*3
checks = []
for index, (r, en) in enumerate(zip(records,english),1):
    for key in ['screen_rect','phone_rect','screen_corner_radius','phone_bottom_cropped','headline_style','subtitle_style']:
        assert r[key] == en[key], (index,key)
    path=ROOT/r['file']; im=Image.open(path)
    assert im.size==(1320,2868) and im.mode=='RGB' and im.format=='PNG'
    assert sha(path)==r['sha256']
    assert hashlib.sha256(im.info['icc_profile']).hexdigest()==r['icc_sha256']==en['icc_sha256']
    rawpath=ROOT/'captures/zh-Hans'/r['raw']
    assert sha(rawpath)==captures[r['raw']]['sha256']
    x,y,w,h=r['screen_rect']
    base=Image.open(rawpath).convert('RGB').resize((w,h),Image.Resampling.LANCZOS)
    expected=base; coverage=np.zeros((h,w),dtype=bool)
    if index in [5,6]:
        expected,alpha=apply_overlay(base,'share' if index==5 else 'delete',ROOT)
        coverage=np.asarray(alpha)>0
        assert r['illustrative_overlay']['actual_system_capture'] is False
    mask=Image.new('L',(w,h));ImageDraw.Draw(mask).rounded_rectangle((0,0,w,h),radius=r['screen_corner_radius'],fill=255)
    opaque=np.asarray(mask)==255
    observed=np.asarray(im)[y:y+h,x:x+w]
    changed=int(np.count_nonzero(np.any(observed!=np.asarray(expected),axis=2)&opaque))
    assert changed==0, (index,changed)
    uncovered=int(np.count_nonzero(np.any(observed!=np.asarray(base),axis=2)&opaque&~coverage))
    assert uncovered==0
    # Identical background samples, outside translated text and native screens.
    old=np.asarray(Image.open(ROOT/en['file']))
    assert np.array_equal(np.asarray(im)[:75],old[:75])
    assert np.array_equal(np.asarray(im)[:,:75],old[:,:75])
    if index==5:
        # Generic pictograms/tile geometry are byte-identical to English.
        for col in range(4):
            left=50+col*175
            assert np.array_equal(observed[998:1098,left:left+100],old[y+998:y+1098,x+left:x+left+100])
    if index==6:
        # Exact same synthetic PPT image, scale and location.
        assert np.array_equal(observed[719:979,129:591],old[y+719:y+979,x+129:x+591])
    checks.append({'file':r['file'],'sha256':sha(path),'pixels':[1320,2868],
                   'mode':'RGB','expected_composite_pixels_changed':changed,
                   'uncovered_real_base_pixels_changed':uncovered,
                   'phone_geometry_matches_english':True})
fonts=[{'family':'Microsoft YaHei','role':role,'filename':name,'sha256':sha(Path('C:/Windows/Fonts')/name)}
       for role,name in [('regular','msyh.ttc'),('bold','msyhbd.ttc')]]
result={'status':'PASS','base_sha':BASE,'capture_sha':provenance['source_sha'],
        'capture_run':provenance['run_url'],'real_ui_locale':'zh-Hans / zh_CN',
        'background_card_shadow_geometry_functions_ast_identical':True,
        'headlines_uniform':{'size':84,'line_height':126,'origin':[108,222]},
        'fonts':fonts,'frozen_english_assets':unchanged,'six_images':checks,
        'frame_5_destinations':NAMES,'frame_6_title':DELETE_TITLE,'frame_6_body':DELETE_BODY,
        'overlay_disclosure':'Frames 5/6 are illustrative, not system Share Sheet / PhotoKit captures.',
        'third_party_brand_assets':False,'production_diff':[],
        'asc_testflight_app_review':'NOT_RUN / not authorized',
        'visual_carousel_review':'Record separately in DELIVERY_ZH_HANS.md after inspection'}
(ROOT/'IMAGE_VALIDATION_ZH_HANS.json').write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print('PASS: Chinese composites, frozen English bytes, matching geometry, unchanged real UI and production sources.')
