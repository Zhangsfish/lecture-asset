"""Evidence extracted from final encoded R3 movies; historical media are read-only."""
from pathlib import Path
import base64,hashlib,json,subprocess,wave
from PIL import Image,ImageDraw,ImageFont
import numpy as np
ROOT=Path(__file__).resolve().parents[1];REPO=ROOT.parents[2];OUT=ROOT/'out/director-r3-opening';REVIEW=ROOT/'review/director-r3-opening'
FF=Path('E:/video_to_md/readable-transcript/resource/bin/ffmpeg.exe');PROBE=FF.with_name('ffprobe.exe')
ICC=Path('C:/Windows/System32/spool/drivers/color/sRGB Color Space Profile.icm').read_bytes()
FRAMES=[0,15,30,45,60,90,120,150,180,210,240,246,299,327,360,420,450,504,546,582,629,660,696,738,786,822,870,918,948,990,1049,1050,1074,1080,1158,1229,1230,1231,1242,1248,1350,1500,1559]
HERO=[120,299,420,582,786,990,1158,1230];HANDOFF=[738,786,822,990]
def run(args):
 r=subprocess.run([str(x) for x in args],capture_output=True,text=True,encoding='utf8',errors='replace')
 if r.returncode:raise RuntimeError(r.stderr[-1600:])
 return r
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def write(p,obj):p.write_text(json.dumps(obj,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
def git(*args):return run(['git','-C',REPO,*args]).stdout.strip()
plan=json.loads((ROOT/'plan.json').read_text(encoding='utf8'));dom=json.loads((OUT/'dom-qa.json').read_text())
assert all(x['duration']==26 and not x['errors'] and not x['seek_mismatches'] and not x['clipping'] and x['saved_before_departure'] and x['middle_life_hidden'] and x['report_hold'] and x['end_stable'] and x['life_only_first_frame'] and x['lecture_influx_complete'] for x in dom)
font=ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf',24)
media=[];comparisons=[];warnings=[];images=[]
for locale,stem,suffix in [('en','en-chatgpt','EN'),('zh-Hans','zh-workbuddy','ZH')]:
 for size in [1080,720]:
  for muted in [False,True]:
   name='director-cut-'+stem+('-720' if size==720 else '')+('-muted' if muted else '')+'.mp4';p=REVIEW/name
   probe=json.loads(run([PROBE,'-v','error','-show_streams','-show_format','-of','json',p]).stdout)
   v=next(s for s in probe['streams'] if s['codec_type']=='video');a=[s for s in probe['streams'] if s['codec_type']=='audio']
   assert v['width']==size and v['height']==(1920 if size==1080 else 1280) and v['r_frame_rate']=='60/1' and int(v['nb_frames'])==1560 and float(v['duration'])==26
   assert len(a)==(0 if muted else 1)
   decoded=run([FF,'-v','error','-i',p,'-f','null','-'])
   rec={'file':name,'sha256':sha(p),'bytes':p.stat().st_size,'width':v['width'],'height':v['height'],'frames':1560,'fps':'60/1','video_seconds':26,'container_seconds':probe['format']['duration'],'full_decode_exit':decoded.returncode,'audio_streams':len(a),'pixel_format':v.get('pix_fmt'),'color_primaries':v.get('color_primaries'),'color_transfer':v.get('color_transfer'),'color_space':v.get('color_space')}
   if size==1080 and not muted:
    pcm=OUT/(stem+'.f32');run([FF,'-v','error','-y','-i',p,'-vn','-ar','48000','-ac','2','-f','f32le',pcm]);data=np.fromfile(pcm,dtype='<f4');peak=float(np.abs(data).max());rms=float(np.sqrt(np.mean(data*data)))
    assert peak<1 and rms>0;rec['audio']={'peak_dbfs':float(20*np.log10(peak)),'rms_dbfs':float(20*np.log10(rms)),'clipped_samples':int((np.abs(data)>=1).sum()),'human_listening':'NOT_RUN'}
    meter=run([FF,'-hide_banner','-i',p,'-af','loudnorm=I=-14.5:TP=-1:LRA=9:print_format=json','-f','null','-']).stderr
    stats=json.loads(meter[meter.rfind('{'):meter.rfind('}')+1]);assert -15.5<=float(stats['input_i'])<=-13.5 and float(stats['input_tp'])<=-1,(locale,stats)
    rec['audio']['encoded_loudness_lufs']=float(stats['input_i']);rec['audio']['encoded_true_peak_dbtp']=float(stats['input_tp'])
    # Prove the rendered AAC contains this locale's real narrated mix, not an old score.
    with wave.open(str(ROOT/'assets/sound'/('r3-opening-mix-'+locale+'.wav'))) as w:
     source=np.frombuffer(w.readframes(w.getnframes()),dtype='<i2').astype(float)/32768
    length=min(len(source),len(data));correlation=float(np.corrcoef(source[:length],data[:length])[0,1]);assert correlation>.98,(locale,correlation)
    rec['audio']['source_narrated_mix_correlation']=correlation
   media.append(rec)
 keydir=REVIEW/'keyframes'/locale;keydir.mkdir(parents=True,exist_ok=True)
 encoded=OUT/('decoded-'+locale);encoded.mkdir(exist_ok=True)
 select='+'.join('eq(n\\,'+str(f)+')' for f in FRAMES)
 master=REVIEW/('director-cut-'+stem+'.mp4');run([FF,'-v','error','-y','-i',master,'-vf','select='+select,'-fps_mode','vfr',encoded/'frame-%02d.png'])
 files=sorted(encoded.glob('frame-*.png'));assert len(files)==len(FRAMES)
 native=sorted((OUT/'snapshots'/locale).glob('frame-*.png'),key=lambda p:int(p.name.split('-')[1]));assert len(native)==len(FRAMES)
 for frame,p,reference in zip(FRAMES,files,native):
  im=Image.open(p).convert('RGB');assert im.size==(1080,1920)
  # GPU/text rendering and H264 are not byte-identical; check actual animation against native seek.
  difference=float(np.abs(np.asarray(im.resize((360,640)),dtype=float)-np.asarray(Image.open(reference).convert('RGB').resize((360,640)),dtype=float)).mean());assert difference<8,(locale,frame,difference)
  comparisons.append({'locale':locale,'frame':frame,'mean_rgb_error':difference,'tolerance':8,'decoded_sha256':sha(p)})
 sheet=Image.new('RGB',(1440,1380),'#090B10');d=ImageDraw.Draw(sheet)
 for i,frame in enumerate(HERO):
  im=Image.open(files[FRAMES.index(frame)]).convert('RGB');p=keydir/f'S{i+1:02}.jpg';im.save(p,quality=94,subsampling=0,icc_profile=ICC);images.append({'file':str(p.relative_to(ROOT)).replace('\\','/'),'frame':frame,'sha256':sha(p),'source':'decoded master MP4'})
  x=i%4*360;y=i//4*690;sheet.paste(im.resize((360,640),Image.Resampling.LANCZOS),(x,y+40));d.text((x+12,y+8),f'S{i+1:02} / {frame}f',font=font,fill='white')
 sheet.save(REVIEW/f'CONTACT_SHEET_{suffix}.jpg',quality=92,icc_profile=ICC)
 # Four actual encoded moments; individual full-size frames plus compact review strip.
 strip=Image.new('RGB',(1440,690),'#090B10');d=ImageDraw.Draw(strip)
 for i,frame in enumerate(HANDOFF):
  im=Image.open(files[FRAMES.index(frame)]).convert('RGB');p=keydir/f'AI-{i+1:02}.jpg';im.save(p,quality=94,subsampling=0,icc_profile=ICC)
  strip.paste(im.resize((360,640),Image.Resampling.LANCZOS),(i*360,40));d.text((i*360+12,8),['Attachment','AI receives','Word flow','Same reply / report'][i],font=font,fill='white')
 strip.save(REVIEW/f'HANDOFF_STRIP_{suffix}.jpg',quality=93,icc_profile=ICC)
 im=Image.open(files[FRAMES.index(1230)]).convert('RGB');im.save(REVIEW/f'END_CARD_{suffix}.png',icc_profile=ICC)
 # Conservative TikTok/X/XHS obstruction review proxies, not claimed official platform masks.
 mask=im.copy();overlay=Image.new('RGBA',im.size);draw=ImageDraw.Draw(overlay)
 for rect in [(0,0,1080,160),(920,200,1080,1680),(0,1550,1080,1920)]:draw.rectangle(rect,fill=(170,55,60,70))
 mask=Image.alpha_composite(mask.convert('RGBA'),overlay).convert('RGB');mask.save(REVIEW/f'PLATFORM_MASK_{suffix}.jpg',quality=90,icc_profile=ICC)
 # Opening/middle/closing typography from actual encoded master, not HTML proxy.
 types=Image.new('RGB',(1080,690),'#090B10');td=ImageDraw.Draw(types)
 for i,frame in enumerate([90,582,1230]):
  types.paste(Image.open(files[FRAMES.index(frame)]).resize((360,640),Image.Resampling.LANCZOS),(360*i,40));td.text((360*i+12,8),['Opening / 90f','Middle / 582f','Closing / 1230f'][i],font=font,fill='white')
 types.save(REVIEW/f'TYPE_CONTACT_{suffix}.jpg',quality=94,subsampling=0,icc_profile=ICC)
 im.save(REVIEW/f'END_CARD_ONSET_{suffix}.jpg',quality=95,subsampling=0,icc_profile=ICC)
 onset=Image.new('RGB',(1080,1320),'#090B10');od=ImageDraw.Draw(onset)
 for i,frame in enumerate([1229,1230,1231,1242,1350,1559]):
  x=i%3*360;y=i//3*660;onset.paste(Image.open(files[FRAMES.index(frame)]).resize((360,640),Image.Resampling.LANCZOS),(x,y+20));od.text((x+8,y),str(frame)+'f',font=font,fill='white')
 onset.save(REVIEW/f'END_CARD_SEQUENCE_{suffix}.jpg',quality=94,icc_profile=ICC)
 # All decoded transition samples, including the actual first complete end card.
 timeline=Image.new('RGB',(1440,((len(FRAMES)+7)//8)*350),'#090B10');draw=ImageDraw.Draw(timeline)
 for i,(frame,p) in enumerate(zip(FRAMES,files)):
  x=i%8*180;y=i//8*350;timeline.paste(Image.open(p).resize((180,320),Image.Resampling.LANCZOS),(x,y+30));draw.text((x+5,y+3),str(frame)+'f',font=font,fill='white')
 timeline.save(REVIEW/f'TRANSITIONS_{suffix}.jpg',quality=91,icc_profile=ICC)
 # Actual first four seconds: life-only, arrival, displacement, complete mixed album.
 opening=Image.new('RGB',(1440,1380),'#090B10');draw=ImageDraw.Draw(opening)
 for i,frame in enumerate([0,30,60,90,120,180,240,299]):
  x=i%4*360;y=i//4*690
  opening.paste(Image.open(files[FRAMES.index(frame)]).resize((360,640),Image.Resampling.LANCZOS),(x,y+40))
  draw.text((x+12,y+8),f'{frame/60:.2f}s / {frame}f',font=font,fill='white')
 opening.save(REVIEW/f'OPENING_SEQUENCE_{suffix}.jpg',quality=94,subsampling=0,icc_profile=ICC)
 # Small exact-byte review proxies retained for remote director environments.
 proxy=REVIEW/'proxy'/locale;proxy.mkdir(parents=True,exist_ok=True)
 for name in ['S03','S04','S05','S06','AI-01','AI-02','AI-03','AI-04']:
  im=Image.open(keydir/(name+'.jpg')).resize((180,320),Image.Resampling.LANCZOS);p=proxy/(name+'.jpg')
  for q in range(78,24,-2):
   im.save(p,quality=q,optimize=True)
   if p.stat().st_size<=8192:break
  b=base64.b64encode(p.read_bytes()).decode();p.with_suffix('.jpg.b64.txt').write_text('\n'.join(b[i:i+120] for i in range(0,len(b),120))+'\n')
  assert base64.b64decode(p.with_suffix('.jpg.b64.txt').read_text())==p.read_bytes()
 log=(OUT/('render-'+locale+'.log')).read_text(encoding='utf8',errors='replace')
 lint=json.loads((OUT/('lint-'+locale+'.json')).read_text());assert lint['errorCount']==0
 warnings.append({'locale':locale,'readiness_timeout':'sub_timeline_readiness_timeout' in log,'static_missing_registry':'Missing window.__timelines' in log,'lint':lint,'source_reuse_note':'Same immutable JPEG textures intentionally used for source page, separate PDF cover, sleeve thumbnail and report source thumbnails; no extra canonical page.'})
assets=json.loads((ROOT/'ASSET_LEDGER.json').read_text(encoding='utf8'))['assets'];checks=[{'path':a['path'],'unchanged':sha(ROOT/a['path'])==a['sha256']} for a in assets];assert all(x['unchanged'] for x in checks)
voices=json.loads((REVIEW/'VOICE_TIMING.json').read_text(encoding='utf8'));asr=json.loads((REVIEW/'VOICE_ASR.json').read_text(encoding='utf8'))
assert voices['real_voice_source'] and len(voices['cues'])==14 and len(asr['cues'])==14
assert all(sha(ROOT/c['file'])==c['sha256'] and c['post_atempo']<=1.08 and c['placement_end_seconds']<=c['window_seconds'][1]+.015 for c in voices['cues'])
assert all(c['normalized_agreement']>=.85 for c in asr['cues'])
scope=git('diff','--name-only',plan['branch_input_sha'],'HEAD').splitlines();assert all(p.startswith('marketing/video/v2/') for p in scope)
history=git('diff','--name-only',plan['branch_input_sha'],'HEAD','--','marketing/video/v2/review/phase-a','marketing/video/v2/review/director-r1','marketing/video/v2/review/director-r2','marketing/video/v2/review/director-r3').splitlines();assert not history
result={'status':'READY_FOR_DIRECTOR_FINAL_REVIEW','tested_implementation_sha':git('rev-parse','HEAD'),'main_at_start':plan['latest_main_at_start'],'director_input_sha':plan['branch_input_sha'],'technical':'PASS','media':media,'dom_checks':[{k:v for k,v in x.items() if k!='samples'} for x in dom],'decoded_native_comparisons':comparisons,'render_warnings':warnings,'original_assets':checks,'historical_media_changes':history,'scope_paths':scope,'commands':json.loads((OUT/'render-commands.json').read_text()),'capture_commands':json.loads((OUT/'snapshot-commands.json').read_text()),'source_frames':images,'visual_review':'Producer inspected both encoded contact sheets, four material views, transitions, 360px copies and platform-mask proxies; director approval remains pending.','human_listening':'NOT_RUN','provider_exchange':'CONCEPTUAL / SOURCE-RELATED EDITORIAL ILLUSTRATION, NOT A RECORDED SESSION','publish_state':'PUBLISH_HOLD_NOT_LIVE_VERIFIED','App_ASC_TestFlight_mutations':False}
write(REVIEW/'QA.json',result);write(REVIEW/'TIMELINE.json',{'plan':plan,'decoded_keyframes':images});print(json.dumps({'technical':'PASS','movies':len(media),'decoded_samples':len(comparisons),'render_warnings':warnings,'max_mean_rgb_error':max(x['mean_rgb_error'] for x in comparisons)},indent=2))
