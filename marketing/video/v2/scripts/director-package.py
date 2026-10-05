"""Package only new director R1 evidence. Historical Phase A is read-only."""
import base64, hashlib, json, re, shutil, subprocess
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import numpy as np

ROOT=Path(__file__).resolve().parents[1]
REPO=ROOT.parents[2]
OUT=ROOT/'out/director'
REVIEW=ROOT/'review/director-r1'
FFMPEG=Path('E:/video_to_md/readable-transcript/resource/bin/ffmpeg.exe')
FFPROBE=FFMPEG.with_name('ffprobe.exe')
ICC=Path('C:/Windows/System32/spool/drivers/color/sRGB Color Space Profile.icm').read_bytes()
def digest(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def command(args):
    result=subprocess.run([str(x) for x in args],capture_output=True,text=True,encoding='utf-8',errors='replace')
    if result.returncode: raise RuntimeError(result.stderr[-1500:])
    return result
def write(p,value): p.write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def git(*args): return command(['git','-C',REPO,*args]).stdout.strip()
plan=json.loads((ROOT/'plan.json').read_text(encoding='utf-8'))
hero=[45,264,420,594,822,1014,1137,1254]
snapshot_frames=[0,21,45,160,180,264,294,330,420,453,480,510,552,594,642,690,726,822,840,900,966,1014,1062,1077,1087,1137,1170,1182,1254,1319]
dom=json.loads((OUT/'dom-qa.json').read_text(encoding='utf-8'))
tested_sha=git('rev-parse','HEAD')
font=ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf',22)
artifacts=[]; proxies=[]; media=[]; first_frames=[]; transition_sheets=[]; encoded_comparisons=[]; render_warnings=[]
REVIEW.mkdir(parents=True,exist_ok=True)
for locale,stem in [('en','en-chatgpt'),('zh-Hans','zh-workbuddy')]:
    for muted in [False,True]:
        path=REVIEW/('director-cut-'+stem+('-muted' if muted else '')+'.mp4')
        probe=json.loads(command([FFPROBE,'-v','error','-show_streams','-show_format','-of','json',path]).stdout)
        video=next(s for s in probe['streams'] if s['codec_type']=='video')
        audio=[s for s in probe['streams'] if s['codec_type']=='audio']
        assert (video['width'],video['height'])==(720,1280)
        assert video['r_frame_rate']=='60/1' and int(video['nb_frames'])==1320
        assert float(video['duration'])==22
        assert len(audio)==(0 if muted else 1)
        decoded=command([FFMPEG,'-v','error','-i',path,'-f','null','-'])
        m={'path':str(path.relative_to(ROOT)).replace('\\','/'),'sha256':digest(path),'bytes':path.stat().st_size,
           'width':720,'height':1280,'frames':1320,'fps':'60/1','video_duration_seconds':float(video['duration']),
           'container_duration_seconds':float(probe['format']['duration']),'full_decode_exit':decoded.returncode,
           'audio_streams':len(audio),'muted':muted}
        if not muted:
            pcm=OUT/(stem+'-decoded-audio.f32')
            command([FFMPEG,'-v','error','-y','-i',path,'-vn','-ac','2','-ar','48000','-f','f32le',pcm])
            samples=np.fromfile(pcm,dtype='<f4')
            peak=float(np.abs(samples).max());rms=float(np.sqrt(np.mean(samples*samples)))
            assert peak<1 and rms>0
            m['decoded_audio']={'sample_peak_dbfs':float(20*np.log10(peak)),'rms_dbfs':float(20*np.log10(rms)),
                                'interleaved_samples':len(samples),'clipped_samples':int((np.abs(samples)>=1).sum()),
                                'human_listening':'NOT_RUN'}
        media.append(m)
    directory=OUT/'snapshots'/locale
    files=sorted(directory.glob('*.png'))
    assert len(files)==30
    # Concrete check of HF preflight warning: every actual encoded temporal sample
    # must reproduce the native timeline, within explicit lossy-codec/GPU tolerance.
    encoded=OUT/('encoded-'+locale);encoded.mkdir(exist_ok=True)
    select='+'.join('eq(n,'+str(f)+')' for f in snapshot_frames)
    command([FFMPEG,'-v','error','-y','-i',REVIEW/('director-cut-'+stem+'.mp4'),
             '-vf','select='+select,'-fps_mode','vfr',encoded/'frame-%02d.png'])
    frames=sorted(encoded.glob('frame-*.png'));assert len(frames)==30
    for f,ref,actual in zip(snapshot_frames,files,frames):
        expected=np.asarray(Image.open(ref).convert('RGB').resize((720,1280),Image.Resampling.LANCZOS),dtype=np.float32)
        got=np.asarray(Image.open(actual).convert('RGB'),dtype=np.float32)
        error=float(np.abs(expected-got).mean())
        assert error<8, (locale,f,error)
        encoded_comparisons.append({'locale':locale,'frame':f,'mean_absolute_rgb_difference':error,
                                    'tolerance':8,'PASS':True,'decoded_frame_sha256':digest(actual)})
    log=(OUT/('render-'+locale+'.log')).read_text(encoding='utf-8',errors='replace')
    render_warnings.append({'locale':locale,'sub_timeline_readiness_timeout':'sub_timeline_readiness_timeout' in log,
      'handling':'Recorded, not suppressed. Actual frame 0 and all 29 boundary/hero samples match the ready native timeline; all 1320 encoded frames decode.',
      'capture_mode':'HyperFrames native screenshot / hardware GPU','actual_capture_frames':1320})
    keydir=REVIEW/'keyframes'/locale;keydir.mkdir(parents=True,exist_ok=True)
    proxydir=REVIEW/'proxy'/locale;proxydir.mkdir(parents=True,exist_ok=True)
    sheet=Image.new('RGB',(1080,1080),'#10141a');draw=ImageDraw.Draw(sheet)
    for scene,frame in enumerate(hero,1):
        source=files[snapshot_frames.index(frame)]
        im=Image.open(source).convert('RGB');assert im.size==(1080,1920)
        dest=keydir/('S'+str(scene).zfill(2)+'.jpg')
        im.save(dest,quality=93,subsampling=0,icc_profile=ICC)
        artifacts.append({'locale':locale,'scene':scene,'frame':frame,'seconds':frame/60,
                          'path':str(dest.relative_to(ROOT)).replace('\\','/'),'sha256':digest(dest),
                          'source_snapshot_sha256':digest(source),'pixels':[1080,1920]})
        thumb=im.resize((270,480),Image.Resampling.LANCZOS)
        x=(scene-1)%4*270;y=(scene-1)//4*540
        sheet.paste(thumb,(x,y+40));draw.text((x+12,y+10),'S'+str(scene)+' / '+str(frame)+'f',font=font,fill='#d0d8e1')
        proxy=im.resize((180,320),Image.Resampling.LANCZOS)
        jpg=proxydir/('S'+str(scene).zfill(2)+'.jpg')
        for quality in range(76,24,-2):
            proxy.save(jpg,quality=quality,optimize=True,icc_profile=None)
            if jpg.stat().st_size<=8192:break
        assert jpg.stat().st_size<=8192
        encoded=base64.b64encode(jpg.read_bytes()).decode('ascii')
        txt=jpg.with_suffix('.jpg.b64.txt')
        txt.write_text('\n'.join(encoded[i:i+120] for i in range(0,len(encoded),120))+'\n',encoding='ascii')
        assert base64.b64decode(txt.read_text(encoding='ascii'))==jpg.read_bytes()
        proxies.append({'locale':locale,'scene':scene,'frame':frame,'source':str(dest.relative_to(ROOT)).replace('\\','/'),
                        'source_sha256':digest(dest),'proxy_sha256':digest(jpg),'path':str(jpg.relative_to(ROOT)).replace('\\','/'),
                        'bytes':jpg.stat().st_size,'quality':quality,'pixels':[180,320],'base64_sha256':digest(txt)})
    contact=REVIEW/('CONTACT_SHEET.jpg' if locale=='en' else 'CONTACT_SHEET_ZH.jpg')
    sheet.save(contact,quality=91,icc_profile=ICC)
    # Actual timeline boundaries: before / at / after on both continuous halves.
    for half,indices in [('S01-S04',range(0,16)),('S05-S08',range(16,30))]:
        idx=list(indices);cols=4;rows=(len(idx)+cols-1)//cols
        check=Image.new('RGB',(720,rows*350),'#10141a');d=ImageDraw.Draw(check)
        for k,index in enumerate(idx):
            im=Image.open(files[index]).convert('RGB').resize((180,320),Image.Resampling.LANCZOS)
            x=k%cols*180;y=k//cols*350;check.paste(im,(x,y+30))
            d.text((x+6,y+3),str(snapshot_frames[index])+'f',font=font,fill='white')
        p=REVIEW/('TRANSITIONS-'+locale+'-'+half+'.jpg');check.save(p,quality=91,icc_profile=ICC)
        transition_sheets.append(str(p.relative_to(ROOT)).replace('\\','/'))
    # Check encoded MP4 first frame; it is not a title card or black frame.
    first=OUT/('first-'+stem+'.png')
    command([FFMPEG,'-v','error','-y','-i',REVIEW/('director-cut-'+stem+'.mp4'),'-frames:v','1',first])
    a=np.asarray(Image.open(first).convert('RGB'))
    first_frames.append({'locale':locale,'mean_rgb':float(a.mean()),'non_dark_pixels':int((a.max(axis=2)>50).sum()),
                         'non_black':bool((a.max(axis=2)>50).sum()>10000)})
assert all(x['non_black'] for x in first_frames)
assets=json.loads((ROOT/'ASSET_LEDGER.json').read_text(encoding='utf-8'))['assets']
asset_hashes=[{'path':a['path'],'unchanged':digest(ROOT/a['path'])==a['sha256']} for a in assets]
assert all(x['unchanged'] for x in asset_hashes)
input_sha=plan['branch_input_sha']
scope=git('diff','--name-only',input_sha,'HEAD').splitlines()
pending=git('diff','--name-only').splitlines()
assert all(s.startswith('marketing/video/v2/') for s in scope+pending)
historical=git('diff','--name-only',input_sha,'HEAD','--','marketing/video/v2/review/phase-a').splitlines()
assert not historical
checks={
 'status':'READY_FOR_DIRECTOR_CUT_REVIEW','tested_implementation_sha':tested_sha,
 'main_at_start':plan['latest_main_at_start'],'branch_input_sha':input_sha,
 'tools':{'node':'24.15.0','HyperFrames':'0.8.132','GSAP':'3.15.0','TypeScript':'7.0.2','esbuild':'0.28.2',
          'Chrome':'154.0.8037.93','FFmpeg':'9.0.1','Python':'3.11.7','Pillow':'10.2.0','NumPy':'1.26.4'},
 'media':media,'first_frames':first_frames,'asset_hashes':asset_hashes,
 'encoded_timeline_comparisons':encoded_comparisons,'render_warnings':render_warnings,
 'dom_checks':[{k:v for k,v in x.items() if k!='samples'} for x in dom],
 'scope_paths':scope,'historical_phase_a_changed':historical,
 'commands':json.loads((OUT/'render-commands.json').read_text(encoding='utf-8')),
 'snapshot_commands':json.loads((OUT/'snapshot-commands.json').read_text(encoding='utf-8')),
 'source_summary':'Editorial paraphrases of the unchanged synthetic lecture: meaning, concrete example, fresh question.',
 'provider_output':'ILLUSTRATIVE; no provider session, fabricated transcript, or integration claim.',
 'sound':'Original deterministic local score + six SFX voices / seven timed cues; no external audio.',
 'human_listening':'NOT_RUN','public_upload':'NOT_RUN','App_ASC_TestFlight_changes':False,
 'director_visual_approval':'NOT_RUN','unresolved_blockers':[],
 'transition_sheets':transition_sheets,
 'review_proxies':proxies
}
assert all(not x['errors'] and not x['seek_mismatches'] and not x['clipping'] and x['duration']==22
           and x['saved_first'] and x['saved_before_departure'] and x['slogan_stable'] for x in dom)
write(REVIEW/'QA.json',checks)
write(REVIEW/'TIMELINE.json',{'plan':plan,'tested_implementation_sha':tested_sha,'keyframes':artifacts,'review_proxies':proxies,
 'actual_object_ids':{'life':['P'+str(i).zfill(2) for i in range(1,9)],'source_pages':['L'+str(i).zfill(2) for i in range(1,13)],
                      'persistent_products':['zip-hero','pdf-hero','readme-layer','mapping','summary','report']}})
print(json.dumps({'status':checks['status'],'media':[(x['path'],x['bytes'],x['frames']) for x in media],
                  'keyframes':len(artifacts),'proxies':len(proxies),'assets_unchanged':all(x['unchanged'] for x in asset_hashes)},indent=2))
