"""Verify existing selected bytes and geometry; no color mapping or icon generation."""
import hashlib, io, json, pathlib, shutil, subprocess
import numpy as np
from PIL import Image, ImageDraw, ImageFont

folder=pathlib.Path(__file__).resolve().parent
study=folder.parent/'icon-color-study-01'
base='b2cd86d7654cdb603c1e0cb6b1829dee498438f1'
asset='App/Assets.xcassets/AppIcon.appiconset/AppIcon.png'
old_bytes=subprocess.check_output(['git','show',f'{base}:{asset}'])
old=np.array(Image.open(io.BytesIO(old_bytes)))
candidate=study/'variant-01-calm-cobalt.png'
if not candidate.exists():
    # Standalone PR audit uses the byte-identical candidate included in this report.
    candidate=folder/'icon-final-1024.png'
expected='b8f5ebfc89d8c8c3124026714737621bbd06c575d0e844f611282ddfc5bd8913'
data=candidate.read_bytes()
assert hashlib.sha256(data).hexdigest()==expected
assert hashlib.sha256(old_bytes).hexdigest()=='a4b796e66c086b08c826bc8cfbd12c4065fa9e92d57069f8dc55e6cb89af625d'
with Image.open(candidate) as im:
    assert im.format=='PNG' and im.size==(1024,1024) and im.mode=='RGB'
    icc=im.info['icc_profile']
    assert hashlib.sha256(icc).hexdigest()=='2b3aa1645779a9e634744faf9b01e9102b0c9b88fd6deced7934df86b949af7e'
    new=np.array(im)
# Reuse the study's HLS eligibility mask for verification, never map colors.
rgb=old/255
mx,mn=rgb.max(-1),rgb.min(-1)
delta=mx-mn
light=(mx+mn)/2
sat=np.divide(delta,1-np.abs(2*light-1),out=np.zeros_like(light),where=delta>0)
den=np.where(delta>0,delta,1)
r,g,b=np.moveaxis(rgb,-1,0)
h=np.zeros_like(light)
h=np.where((delta>0)&(mx==r),((g-b)/den)%6,h)
h=np.where((delta>0)&(mx==g),(b-r)/den+2,h)
h=np.where((delta>0)&(mx==b),(r-g)/den+4,h)*60
eligible=(h>185)&(h<250)&(sat>.20)&(light<.84)
changed=np.any(old!=new,axis=-1)
assert not changed[~eligible].any()
assert np.array_equal(new[light>=.84],old[light>=.84])
old_blue=(old[...,2]>old[...,0])&(old[...,2]>old[...,1])
new_blue=(new[...,2]>new[...,0])&(new[...,2]>new[...,1])
assert np.array_equal(old_blue,new_blue)
pure_white=np.all(old==255,axis=-1)
yellow=(old[...,0]>200)&(old[...,1]>150)&(old[...,2]<160)
assert np.array_equal(old[pure_white|yellow],new[pure_white|yellow])

def bbox(mask):
    y,x=np.nonzero(mask)
    return [int(x.min()),int(y.min()),int(x.max()+1),int(y.max()+1)]

audit={'base_sha':base,'selected_variant':'V1 Calm cobalt','representative_hex':'#4772A8',
       'original_sha256':hashlib.sha256(old_bytes).hexdigest(),'final_sha256':expected,
       'original':{'size':[1024,1024],'mode':'RGB','alpha':False,'icc':'none (sRGB assumed)'},
       'final':{'size':[1024,1024],'mode':'RGB','alpha':False,'icc_sha256':hashlib.sha256(icc).hexdigest()},
       'changed_pixels':int(changed.sum()),'non_blue_changed_pixels':int(changed[~eligible].sum()),
       'pale_white_region_changed_pixels':int(changed[light>=.84].sum()),
       'pure_white_pixels':int(pure_white.sum()),'yellow_region_pixels':int(yellow.sum()),
       'white_yellow_changed_pixels':int(changed[pure_white|yellow].sum()),
       'blue_footprint_changed_pixels':int((old_blue!=new_blue).sum()),
       'bounds_exclusive':{'original_canvas':[0,0,1024,1024],'final_canvas':[0,0,1024,1024],
                           'original_blue':bbox(old_blue),'final_blue':bbox(new_blue),
                           'original_white':bbox(pure_white),'final_white':bbox(np.all(new==255,axis=-1)),
                           'original_yellow':bbox(yellow),'final_yellow':bbox((new[...,0]>200)&(new[...,1]>150)&(new[...,2]<160)),
                           'changed_pixels':bbox(changed)},
       'geometry_basis':'Exact preselected candidate hash; equal canvas; identical blue channel-dominance footprint; exact white/pale/yellow pixels; study pointwise-only provenance. Not an assertion of identical RGB values across the whole icon.',
       'not_run':['Physical iPhone SpringBoard appearance','TestFlight upload','Broad/destructive QA']}
# Production replacement was already made after validation; reruns only verify it.
assert pathlib.Path(asset).read_bytes()==data
if candidate.resolve() != (folder/'icon-final-1024.png').resolve():
    shutil.copyfile(candidate,folder/'icon-final-1024.png')
sheet=Image.new('RGB',(950,440),'#F3F4F6')
d=ImageDraw.Draw(sheet)
d.rectangle((475,0,950,440),fill='#171B22')
font=ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf',20)
for column,fg in [(0,'#20242B'),(1,'#EEF0F4')]:
    start=column*475
    d.text((start+20,20),'V1 Calm cobalt — '+('Light' if column==0 else 'Dark'),font=font,fill=fg)
    for x,size in [(20,120),(210,60),(340,40)]:
        # Use production file for downsampling; never upscale or sharpen.
        thumb=Image.open(asset).resize((size,size),Image.Resampling.LANCZOS)
        sheet.paste(thumb,(start+x,110+(120-size)//2))
        d.text((start+x,255),f'{size} × {size}',font=font,fill=fg)
    d.text((start+20,345),'#4772A8   •   RGB / sRGB / no alpha',font=font,fill=fg)
sheet.save(folder/'icon-small-size-check.png',icc_profile=icc)
(folder/'icon-audit.json').write_text(json.dumps(audit,indent=2)+'\n',encoding='utf-8')
print(json.dumps(audit,indent=2))
