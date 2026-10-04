"""Focused image/provenance checks; no claim of App Store approval."""
from pathlib import Path
from PIL import Image, ImageDraw
import hashlib
import json
import numpy as np
import subprocess
import io
from phone_overlays import apply_overlay, NAMES, DELETE_TITLE, DELETE_BODY

ROOT = Path(__file__).resolve().parents[1]
BASE = '4afd804ff2bdedec0a181181d768932a01b52b1b'
PREVIOUS = 'adc6c2716b7e53451c6c2f390a672f7d7ab7e622'
assert NAMES==['AI','My Computer','Chat','Friends']
assert not list((ROOT/'illustrative-assets').glob('*')), 'unused downloaded artwork remains'
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
        base_expected = expected
        overlay = record.get('illustrative_overlay')
        coverage = np.zeros((h,w),dtype=bool)
        if overlay:
            assert record['raw']=='store-en-ready.png'
            expected,alpha=apply_overlay(expected,overlay['kind'],ROOT)
            coverage=np.asarray(alpha)>0
            assert overlay['actual_system_capture'] is False
            if overlay['kind']=='share':
                assert overlay['first_row']==NAMES
                assert overlay['filename']=='Lecture_2026-10-04_AI_ZIP.zip'
            else:
                assert overlay['preview']=='fixtures/lecture-13.jpg'
                assert overlay['delete_title']==DELETE_TITLE=='Allow “Lecture Asset” to delete 12 photos?'
                assert overlay['delete_body']==DELETE_BODY=='These photos will be deleted from iCloud Photos on all your devices. They’ll remain in Recently Deleted for 30 days.'
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
        base_delta=np.any(np.asarray(im)[top:bottom,left:right]!=np.asarray(base_expected),axis=2)
        actual_changes=int(np.count_nonzero(base_delta & visible_mask))
        assert np.count_nonzero(base_delta & visible_mask & ~coverage)==0
        old_bytes=subprocess.check_output(['git','show',PREVIOUS+':'+path.relative_to(Path.cwd()).as_posix()])
        if records.index(record) in (0,1,2,3):
            assert path.read_bytes()==old_bytes, 'protected frame changed'
        if records.index(record) in (2,4,5):
            old=np.asarray(Image.open(io.BytesIO(old_bytes)).convert('RGB'))
            outside=np.any(np.asarray(im)!=old,axis=2); outside[y:y+h,x:x+w]=False
            assert not np.any(outside), 'phone exterior changed'
            if records.index(record) in (4,5):
                # Bound the allowed changes to destination rows or dialog text.
                local_delta=np.any(np.asarray(im)[y:y+h,x:x+w]!=old[y:y+h,x:x+w],axis=2)
                allowed=np.zeros((h,w),dtype=bool)
                if records.index(record)==4:
                    allowed[990:1340,:]=True
                else:
                    allowed[480:690,70:650]=True
                    allowed[995:1045,100:620]=True
                    # The lecture preview and destructive/cancel actions stay exact.
                    assert np.array_equal(np.asarray(im)[y+719:y+979,x+129:x+591],old[y+719:y+979,x+129:x+591])
                assert not np.any(local_delta & ~allowed), 'change outside focused overlay areas'
        result.append({'file':record['file'],'size_mode_profile_hash':'PASS',
                       'central_phone_pixels_changed':changed,
                       'composite_expected_pixels_changed':full_changed,
                       'all_opaque_phone_pixels_changed':actual_changes,
                       'uncovered_base_pixels_changed':0,
                       'illustrative_overlay':overlay,
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
assert [records[i]['raw'] for i in (2,4,5)]==['store-en-ready.png']*3
assert subprocess.check_output(['git','diff','--name-only',PREVIOUS,'--','App','AppResources','Packages','schemas','project.yml','.github','UITests','Tests'],text=True).strip()==''
assert len({tuple(r['phone_rect']) for r in records})==1
assert all(r['phone_rect'][2]==748 and r['phone_rect'][1]==1240 for r in records)
assert all(r['phone_rect'][1]+r['phone_rect'][3]<=2868 for r in records)
assert all(not r['phone_bottom_cropped'] for r in records)
assert all(r['headline_style']=={'size':84,'line_height':126,'origin':[108,222]} for r in records)
assert all(r['subtitle_style']=={'size':42,'color':'#5D6B7A','origin':[113,518]} for r in records)
assert records[4]['headline_lines']==['Share the AI ZIP.','Keep exploring the lecture.']
summary={'base_sha':BASE,'production_app_tree':app_tree,'production_changes':production_diff,
         'previous_composition_head':PREVIOUS,'exact_capture_sha':CAPTURE_SHA,
         'new_capture_this_round':False, 'common_ready_base':'PASS',
         'protected_frames_1_2_3_4_byte_identical':'PASS',
         'phone_exteriors_3_5_6_pixel_identical':'PASS',
         'overlay_change_bounds':'PASS','lecture_preview_unchanged':'PASS',
         'generic_destinations':NAMES,'downloaded_artwork_removed':'PASS',
         'plural_delete_contract':'PASS','runtime_workflow_tests_unchanged_this_round':'PASS',
         'uniform_headline_style':'PASS','uniform_subtitle_style':'PASS',
         'uniform_full_phone_geometry':'PASS',
         'six_image_checks':result,'phone_repaint_check':'PASS',
         'china_final_images':'NOT_RUN','app_store_upload':'NOT_RUN',
         'real_device_visual_review':'NOT_RUN'}
(ROOT/'IMAGE_VALIDATION.json').write_text(json.dumps(summary,indent=2)+'\n')
print('PASS: common ready base; illustrative overlays; protected frames byte-identical; phone exteriors and runtime/workflow unchanged.')
