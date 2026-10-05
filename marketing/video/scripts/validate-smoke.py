"""Inspect official HyperFrames outputs; this script never captures a browser frame."""
import hashlib
import json
import math
from pathlib import Path
import shutil
import wave

import numpy as np
from PIL import Image, ImageDraw, ImageFont, ImageOps
from fontTools.ttLib import TTCollection, TTFont

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'out/M00'
REVIEW = ROOT / 'review/M00'
REVIEW.mkdir(parents=True, exist_ok=True)
def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

probe = json.loads((OUT / 'ffprobe.json').read_text(encoding='utf-8-sig'))
video = next(s for s in probe['streams'] if s['codec_type'] == 'video')
audio = next(s for s in probe['streams'] if s['codec_type'] == 'audio')
assert (video['width'],video['height'],int(video['nb_read_frames'])) == (540,960,120)
assert video['r_frame_rate'] == '60/1' and video['avg_frame_rate'] == '60/1'
assert abs(float(video['duration'])-2.0) < 1e-6
assert abs(float(probe['format']['duration'])-2.0) < 1e-6
assert int(audio['sample_rate']) == 48000
assert video['color_space'] == 'bt709' and video['color_primaries'] == 'bt709'
assert 'black_start:' not in (OUT / 'blackdetect.log').read_text()

frames = sorted((OUT / 'seek').glob('frame-*.png'))
assert len(frames) == 12
comparisons=[]
for a,b in [(0,8),(1,6),(2,9),(3,5),(4,7),(10,11)]:
    left=np.array(Image.open(frames[a]).convert('RGBA'))
    right=np.array(Image.open(frames[b]).convert('RGBA'))
    assert left.shape == (1920,1080,4)
    changed=int(np.count_nonzero(np.any(left!=right,axis=2)))
    assert changed == 0, (a,b,changed)
    comparisons.append({'capture_indices':[a,b],'changed_pixels':changed,'sha256':digest(frames[a])})
for index in range(5):
    shutil.copyfile(frames[index], REVIEW / f'frame-{[0,30,60,90,119][index]:03d}.png')
sheet=Image.new('RGB',(1350,535),'#FAFBFC')
draw=ImageDraw.Draw(sheet)
font=ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf',22)
for i in range(5):
    image=Image.open(frames[i]).convert('RGB').resize((270,480),Image.Resampling.LANCZOS)
    sheet.paste(image,(i*270,0))
    draw.text((i*270+20,490),f'Frame {[0,30,60,90,119][i]}',font=font,fill='#203247')
sheet.save(REVIEW / 'CONTACT_SHEET.png')

def pcm_peak(path):
    with wave.open(str(path),'rb') as stream:
        assert stream.getsampwidth()==2 and stream.getframerate()==48000
        pcm=np.frombuffer(stream.readframes(stream.getnframes()),dtype='<i2').astype(np.int32)
        peak=int(np.abs(pcm).max())
        assert 0 < peak < 32767 and not np.any(np.abs(pcm)>=32767)
        return {'sample_rate':48000,'channels':stream.getnchannels(),'peak_pcm':peak,'peak_dbfs':round(20*math.log10(peak/32768),3),'clipped_samples':0}
font_rows=[]
text='讲座照片与 AI ZIP'
for name in ['msyh.ttc','msyhbd.ttc','segoeui.ttf']:
    path=Path('C:/Windows/Fonts')/name
    face=TTCollection(str(path)).fonts[0] if path.suffix=='.ttc' else TTFont(str(path))
    required=text if name.startswith('msyh') else 'Lecture Asset README.md AI ZIP slides/ lecture.md manifest.json'
    missing=[c for c in set(required) if not c.isspace() and ord(c) not in face.getBestCmap()]
    assert not missing
    font_rows.append({'file':name,'sha256':digest(path),'missing_glyphs':missing,'family':face['name'].getDebugName(1)})

# Check original image chroma on flat interior patches (avoid resized edges/text).
# Expected surface geometry comes from the fixed CSS, no overlay over the images.
last=Image.open(frames[4]).convert('RGB')
reference=Image.open(OUT/'personal-color-reference.png').convert('RGB')
xy_points={'mountain_sky':(30,30),'mountain_dark':(35,332),'sun':(340,90)}
color_samples={k:{'xy':[546+xy[0],362+xy[1]],'actual':last.getpixel((546+xy[0],362+xy[1])),
                  'reference':reference.getpixel(xy)} for k,xy in xy_points.items()}
for sample in color_samples.values():
    assert max(abs(a-b) for a,b in zip(sample['actual'],sample['reference']))<=2, sample
lecture_reference=ImageOps.fit(Image.open(ROOT/'assets/lecture-13.jpg').convert('RGB'),
                               (450,450),method=Image.Resampling.LANCZOS)
for i,xy in enumerate([(30,30),(300,400),(420,400)]):
    actual=last.getpixel((72+xy[0],362+xy[1]))
    expected=lecture_reference.getpixel(xy)
    assert max(abs(a-b) for a,b in zip(actual,expected))<=2, (xy,actual,expected)
    color_samples[f'lecture_patch_{i+1}']={'xy':[72+xy[0],362+xy[1]],'actual':actual,'reference':expected}
assert last.getpixel((20,20))==(250,251,252)
shutil.copyfile(OUT/'smoke-review.mp4',REVIEW/'smoke-review.mp4')
result={
 'status':'PASS','frames':120,'fps':'60/1','duration_seconds':2,'review_dimensions':[540,960],
 'source_dimensions':[1080,1920],'rec709':True,'no_black_frame':True,
 'seek_comparisons':comparisons,'hold_seconds':0.2,'fonts':font_rows,
 'font_evidence_boundary':'Installed face cmap covers all characters; local @font-face, document.fonts readiness, official browser check with zero resource/runtime errors, and human inspection of actual CJK pixels. Not a cross-host font guarantee.',
 'audio_source':pcm_peak(ROOT/'assets/ping-48k.wav'),'audio_rendered':pcm_peak(OUT/'rendered-audio.wav'),
 'image_color_samples':color_samples,'review_sha256':digest(REVIEW/'smoke-review.mp4'),
 'still_sha256':{p.name:digest(p) for p in REVIEW.glob('frame-*.png')}
}
(REVIEW/'VALIDATION.json').write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print(json.dumps({k:result[k] for k in ['status','frames','fps','duration_seconds','review_sha256']},indent=2))
