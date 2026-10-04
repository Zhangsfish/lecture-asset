"""Focused image/provenance checks; no claim of App Store approval."""
from pathlib import Path
from PIL import Image, ImageDraw
import hashlib
import json
import numpy as np
import subprocess

ROOT = Path(__file__).resolve().parents[1]
BASE = '4afd804ff2bdedec0a181181d768932a01b52b1b'
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
        # Avoid corner masks. All text, controls, lecture pixels in the central
        # screen must be untouched by illustrative overlays, color or repainting.
        observed=np.asarray(im)[y+96:y+h-96,x+96:x+w-96]
        target=np.asarray(expected)[96:h-96,96:w-96]
        changed=int(np.count_nonzero(np.any(observed!=target,axis=2)))
        assert changed==0, (record['file'],changed)
        # Check every opaque pixel, including the status bar and edge controls.
        mask=Image.new('L',(w,h))
        ImageDraw.Draw(mask).rounded_rectangle((0,0,w,h),radius=83,fill=255)
        delta=np.any(np.asarray(im)[y:y+h,x:x+w]!=np.asarray(expected),axis=2)
        full_changed=int(np.count_nonzero(delta & (np.asarray(mask)==255)))
        assert full_changed==0, (record['file'],full_changed)
        result.append({'file':record['file'],'size_mode_profile_hash':'PASS',
                       'central_phone_pixels_changed':changed,
                       'all_opaque_phone_pixels_changed':full_changed})
protected=['App','AppResources','Packages','schemas','project.yml','Tests']
diff=subprocess.check_output(['git','diff','--name-only',BASE,'--',*protected],text=True).strip()
assert not diff, diff
app_tree=subprocess.check_output(['git','rev-parse','HEAD:App'],text=True).strip()
baseline_tree=subprocess.check_output(['git','rev-parse',BASE+':App'],text=True).strip()
assert app_tree==baseline_tree
summary={'base_sha':BASE,'production_app_tree':app_tree,'production_changes':[],
         'six_image_checks':result,'phone_repaint_check':'PASS',
         'china_final_images':'NOT_RUN','app_store_upload':'NOT_RUN',
         'real_device_visual_review':'NOT_RUN'}
(ROOT/'IMAGE_VALIDATION.json').write_text(json.dumps(summary,indent=2)+'\n')
print('PASS: six PNGs, ICC/hashes, all opaque phone pixels unchanged, production trees unchanged.')
