"""Focused image/provenance checks; no claim of App Store approval."""
from pathlib import Path
from PIL import Image, ImageDraw
import hashlib
import json
import numpy as np
import subprocess

ROOT = Path(__file__).resolve().parents[1]
BASE = '4afd804ff2bdedec0a181181d768932a01b52b1b'
PREVIOUS = '3a8a5a0b67d7a1c316b775302ebc06b19adc3880'
provenance = json.loads((ROOT/'captures/PROVENANCE.json').read_text(encoding='utf-8'))
CAPTURE_SHA = provenance['source_sha']
records = json.loads((ROOT/'RENDER_MANIFEST.json').read_text(encoding='utf-8'))
assert len(records)==6
result=[]
captures={r['file']:r for r in json.loads((ROOT/'captures'/'CAPTURES.json').read_text())}
for record in records:
    path=ROOT/record['file']
    with Image.open(path) as im:
        assert im.format=='PNG' and im.size==(1320,2868) and im.mode=='RGB'
        assert 'icc_profile' in im.info
        assert hashlib.sha256(im.info['icc_profile']).hexdigest()==record['icc_sha256']
        assert hashlib.sha256(path.read_bytes()).hexdigest()==record['sha256']
        rawpath=ROOT/'captures'/record['raw']
        assert hashlib.sha256(rawpath.read_bytes()).hexdigest()==captures[record['raw']]['sha256']
        raw=Image.open(rawpath).convert('RGB')
        x,y,w,h=record['screen_rect']
        expected=raw.resize((w,h),Image.Resampling.LANCZOS)
        # Intersect the original screen geometry with the canvas, including
        # any screen edge at the canvas boundary; current phones are fully visible.
        left,top,right,bottom=max(0,x),max(0,y),min(im.width,x+w),min(im.height,y+h)
        assert right>left and bottom>top
        sx,sy=left-x,top-y
        vw,vh=right-left,bottom-top
        observed=np.asarray(im)[max(top,y+96):min(bottom,y+h-96),max(left,x+96):min(right,x+w-96)]
        target=np.asarray(expected)[max(top,y+96)-y:min(bottom,y+h-96)-y,max(left,x+96)-x:min(right,x+w-96)-x]
        changed=int(np.count_nonzero(np.any(observed!=target,axis=2)))
        assert changed==0, (record['file'],changed)
        # Check every opaque pixel, including the status bar and edge controls.
        mask=Image.new('L',(w,h))
        ImageDraw.Draw(mask).rounded_rectangle((0,0,w,h),radius=record['screen_corner_radius'],fill=255)
        delta=np.any(np.asarray(im)[top:bottom,left:right]!=np.asarray(expected)[sy:sy+vh,sx:sx+vw],axis=2)
        visible_mask=np.asarray(mask)[sy:sy+vh,sx:sx+vw]==255
        full_changed=int(np.count_nonzero(delta & visible_mask))
        assert full_changed==0, (record['file'],full_changed)
        result.append({'file':record['file'],'size_mode_profile_hash':'PASS',
                       'central_phone_pixels_changed':changed,
                       'all_opaque_phone_pixels_changed':full_changed,
                       'visible_opaque_phone_pixel_count':int(np.count_nonzero(visible_mask)),
                       'phone_bottom_cropped':record['phone_bottom_cropped'],
                       'raw_hash_matches_capture_inventory':True})
# Owner authorized only one bilingual production label change. No Swift/runtime change.
production_diff=subprocess.check_output(['git','diff','--name-only',BASE,'--','App','AppResources','Packages','schemas','project.yml'],text=True).splitlines()
assert production_diff==['App/Localizable.xcstrings'], production_diff
previous=json.loads(subprocess.check_output(['git','show',BASE+':App/Localizable.xcstrings']))
current=json.loads(Path('App/Localizable.xcstrings').read_text(encoding='utf-8'))
assert {k for k in previous['strings'] if previous['strings'][k]!=current['strings'][k]}=={'export.shareZIP'}
assert set(previous['strings'])==set(current['strings'])
for locale,value in [('en','Share AI ZIP'),('zh-Hans','分享 AI 资料包（ZIP）')]:
    assert current['strings']['export.shareZIP']['localizations'][locale]['stringUnit']['value']==value
previous['strings']['export.shareZIP']=current['strings']['export.shareZIP']
assert previous==current
app_tree=subprocess.check_output(['git','rev-parse','HEAD:App'],text=True).strip()
capture_tree=subprocess.check_output(['git','rev-parse',CAPTURE_SHA+':App'],text=True).strip()
assert app_tree==capture_tree
assert subprocess.check_output(['git','diff','--name-only',CAPTURE_SHA,'--','App'],text=True).strip()==''
assert len({tuple(r['phone_rect']) for r in records})==1
assert all(r['phone_rect'][2]==748 and r['phone_rect'][1]==1240 for r in records)
assert all(r['phone_rect'][1]+r['phone_rect'][3]<=2868 for r in records)
assert all(not r['phone_bottom_cropped'] for r in records)
assert all(r['headline_style']=={'size':84,'line_height':126,'origin':[108,222]} for r in records)
assert all(r['subtitle_style']=={'size':42,'color':'#5D6B7A','origin':[113,518]} for r in records)
assert records[4]['headline_lines']==['Share the AI ZIP.','Keep exploring the lecture.']
summary={'base_sha':BASE,'production_app_tree':app_tree,'production_changes':production_diff,
         'previous_composition_head':PREVIOUS,'exact_capture_sha':CAPTURE_SHA,
         'recaptured_authorized_interaction_states':True,
         'uniform_headline_style':'PASS','uniform_subtitle_style':'PASS',
         'uniform_full_phone_geometry':'PASS',
         'six_image_checks':result,'phone_repaint_check':'PASS',
         'china_final_images':'NOT_RUN','app_store_upload':'NOT_RUN',
         'real_device_visual_review':'NOT_RUN'}
(ROOT/'IMAGE_VALIDATION.json').write_text(json.dumps(summary,indent=2)+'\n')
print('PASS: six PNGs, ICC/hashes, all opaque phone pixels unchanged, only authorized bilingual ZIP label changed; capture App tree matches.')
