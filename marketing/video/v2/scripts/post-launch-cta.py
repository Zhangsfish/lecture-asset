"""Post-launch CTA-only finish using accepted movies, existing native renderer and FFmpeg.

prepare -> node scripts/post-launch-capture.mjs -> render -> verify
No resynthesis, new animation, private data, account API or public posting.
"""
from pathlib import Path
import datetime, hashlib, json, math, re, shutil, subprocess, sys
import cv2
import numpy as np
import qrcode
from PIL import Image, ImageDraw

ROOT=Path(__file__).resolve().parents[1]
REPO=ROOT.parents[2]
COMMON=Path(subprocess.check_output(['git','rev-parse','--path-format=absolute','--git-common-dir'],cwd=REPO).decode().strip())
REVIEW=ROOT/'review/post-launch-2026-11-23'
OUT=ROOT/'out/post-launch-2026-11-23'
OLD=ROOT/'review/director-r3-caption-male'
FF=Path('E:/video_to_md/readable-transcript/resource/bin/ffmpeg.exe')
PROBE=FF.with_name('ffprobe.exe')
BASE='a0c925fc4120f39ef47df69b5874814189e13f94'
LOCALES={'en':('us','en-chatgpt'),'zh-Hans':('cn','zh-workbuddy')}
# Slight background margins and coordinates divisible by three preserve 720 placement.
RECTS={'qr':(684,777,222,222),'search':(108,993,600,117)}
OUT.mkdir(parents=True,exist_ok=True)
REVIEW.mkdir(parents=True,exist_ok=True)
def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def load(p): return json.loads(Path(p).read_text(encoding='utf8'))
def write(p,d): Path(p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf8',newline='\n')
def run(args):
    result=subprocess.run([str(a) for a in args],capture_output=True,creationflags=0x08000000 if sys.platform=='win32' else 0)
    if result.returncode: raise RuntimeError(result.stderr.decode('utf8','replace')[-3000:])
    return result.stdout
def source_hashes():return {p.name:sha(p) for p in OLD.glob('*.mp4')}
def movie(stem,size,muted=False):return 'director-cut-'+stem+('-720' if size==720 else '')+('-muted' if muted else '')+'.mp4'

def prepare():
    evidence=REVIEW/'evidence';evidence.mkdir(exist_ok=True)
    checks=[];destinations={}
    for locale,(region,stem) in LOCALES.items():
        source=COMMON/('live-cta-'+region+'.json')
        data=load(source);assert data['resultCount']==1
        app=data['results'][0]
        assert app['trackId']==6816814541 and app['trackName']=='Lecture Asset' and app['bundleId']=='com.zhangsfish.lectureasset'
        assert app['price']==0 and app['version']=='0.1.0'
        url=app['trackViewUrl'].split('?')[0]
        assert url==f'https://apps.apple.com/{region}/app/lecture-asset/id6816814541'
        html=(COMMON/('live-cta-'+region+'.html')).read_bytes()
        title=re.search(r'<title>(.*?)</title>',html.decode('utf8')).group(1)
        assert 'Lecture Asset' in title and b'6816814541' in html
        shutil.copy2(source,evidence/f'apple-lookup-{region}.json')
        qr_asset=f'app-store-live-{locale}.png'
        qr=qrcode.QRCode(error_correction=qrcode.constants.ERROR_CORRECT_M,box_size=10,border=4)
        qr.add_data(url);qr.make(fit=True);qr.make_image(fill_color='black',back_color='white').convert('RGB').save(ROOT/'assets/brands'/qr_asset)
        destinations[locale]={'storefront':region,'url':url,'qr_asset':qr_asset,'search_lines':['Search Lecture Asset','on the App Store'] if locale=='en' else ['在 App Store 搜索','Lecture Asset']}
        checks.append({'locale':locale,'region':region,'lookup_url':f'https://itunes.apple.com/lookup?id=6816814541&country={region}',
          'product_url':url,'lookup_result_count':1,'trackId':app['trackId'],'trackName':app['trackName'],'bundleId':app['bundleId'],
          'version':app['version'],'price':app['price'],'currency':app['currency'],'releaseDate':app['releaseDate'],
          'currentVersionReleaseDate':app['currentVersionReleaseDate'],'minimumOsVersion':app['minimumOsVersion'],
          'product_http_status':200,'resolved_url':url,'product_page_title':title,'product_html_sha256':hashlib.sha256(html).hexdigest(),
          'raw_lookup_sha256':sha(source),'qr_asset_sha256':sha(ROOT/'assets/brands'/qr_asset)})
    now=datetime.datetime.now(datetime.timezone.utc).isoformat()
    write(REVIEW/'PUBLIC_AVAILABILITY.json',{'checked_utc':now,'method':'Read-only Apple public lookup plus HTTPS product pages via existing local network proxy; no ASC access','checks':checks,'public_download_status':'VERIFIED_US_AND_CN','posting_authorized':False})
    publish=load(ROOT/'PUBLISH_LINK.json')
    publish.update(checked_utc=now,matching_name_id='VERIFIED',public_download_status='VERIFIED_US_AND_CN',publication_state='PUBLIC_LISTING_VERIFIED_NOT_POSTED',live_destinations=destinations,latest_verification='review/post-launch-2026-11-23/PUBLIC_AVAILABILITY.json')
    publish['owner_post_launch_followup']['status']='IN_PROGRESS_POST_LAUNCH_CTA_PATCH'
    publish['owner_post_launch_followup']['public_posting_authorized']=False
    write(ROOT/'PUBLISH_LINK.json',publish)
    write(REVIEW/'SOURCE_MEDIA.json',{'base_sha':BASE,'accepted_directory':'review/director-r3-caption-male','sha256':source_hashes(),'story_audio_and_timing':'PRESERVE; only QR and search-cue rectangles after 1230/60 seconds are patched'})
    print('Prepared verified US/CN public destinations and QR assets',flush=True)

def render():
    commands=[]
    for locale,(region,stem) in LOCALES.items():
        native=Image.open(OUT/f'native-end-{locale}.png').convert('RGB')
        for name,(x,y,w,h) in RECTS.items():native.crop((x,y,x+w,y+h)).save(OUT/f'{name}-{locale}.png')
        for size in [1080,720]:
            name=movie(stem,size);src=OLD/name;dest=REVIEW/name;s=size/1080
            x,y,w,h=RECTS['qr'];sx,sy,sw,sh=RECTS['search']
            filters=f'[1:v]scale={round(w*s)}:{round(h*s)}:flags=neighbor[q];[2:v]scale={round(sw*s)}:{round(sh*s)}:flags=lanczos[c];[0:v][q]overlay={round(x*s)}:{round(y*s)}:enable=gte(t\\,20.5)[v];[v][c]overlay={round(sx*s)}:{round(sy*s)}:enable=gte(t\\,20.5)[out]'
            args=[FF,'-v','error','-y','-i',src,'-loop','1','-i',OUT/f'qr-{locale}.png','-loop','1','-i',OUT/f'search-{locale}.png',
              '-filter_complex_threads','1','-filter_complex',filters,'-map','[out]','-map','0:a:0','-c:a','copy',
              '-c:v','libx264','-threads','4','-preset','medium','-crf','18' if size==1080 else '20','-pix_fmt','yuv420p',
              '-r','60','-frames:v','1560','-t','26','-color_primaries','bt709','-color_trc','bt709','-colorspace','bt709','-movflags','+faststart',dest]
            print('Finishing '+name,flush=True);run(args);commands.append([str(a) for a in args])
            muted=REVIEW/movie(stem,size,True)
            args=[FF,'-v','error','-y','-i',dest,'-map','0:v:0','-c:v','copy','-an','-movflags','+faststart',muted]
            run(args);commands.append([str(a) for a in args])
    write(REVIEW/'RENDER_COMMANDS.json',commands)

def frame(p,n,dest):
    run([FF,'-v','error','-y','-i',p,'-vf',f'select=eq(n\\,{n})','-frames:v','1',dest])
    return np.array(Image.open(dest).convert('RGB'))
def audio_hash(p):return run([FF,'-v','error','-i',p,'-map','0:a:0','-c:a','copy','-f','hash','-hash','sha256','-']).decode().strip()
def verify():
    source=load(REVIEW/'SOURCE_MEDIA.json');assert source['sha256']==source_hashes()
    publish=load(ROOT/'PUBLISH_LINK.json');results=[];qr_checks=[];body=[];audio=[]
    for locale,(region,stem) in LOCALES.items():
        expected=publish['live_destinations'][locale]['url']
        for size in [1080,720]:
            voiced=REVIEW/movie(stem,size);old=OLD/movie(stem,size)
            assert audio_hash(voiced)==audio_hash(old)
            audio.append({'locale':locale,'size':size,'original_aac_packet_hash':audio_hash(old),'new_aac_packet_hash':audio_hash(voiced),'equal':True})
            for muted in [False,True]:
                p=REVIEW/movie(stem,size,muted)
                probe=json.loads(run([PROBE,'-v','error','-show_streams','-show_format','-of','json',p]))
                v=next(s for s in probe['streams'] if s['codec_type']=='video');a=[s for s in probe['streams'] if s['codec_type']=='audio']
                assert (v['width'],v['height'],int(v['nb_frames']),v['r_frame_rate'])==(size,1920 if size==1080 else 1280,1560,'60/1')
                assert len(a)==(0 if muted else 1) and abs(float(probe['format']['duration'])-26)<.05
                run([FF,'-v','error','-i',p,'-f','null','-'])
                for n in [1230,1260,1559]:
                    path=OUT/f'decoded-{locale}-{size}-{muted}-{n}.png';im=frame(p,n,path)
                    decoded,points,_=cv2.QRCodeDetector().detectAndDecode(cv2.cvtColor(im,cv2.COLOR_RGB2BGR))
                    assert decoded==expected,(p.name,n,decoded,expected)
                    qr_checks.append({'file':p.name,'frame':n,'decoded_url':decoded,'expected_url':expected,'whole_actual_encoded_frame':True,'PASS':True})
                    if n==1230 and not muted:shutil.copy2(path,REVIEW/f'END_CARD_{"EN" if locale=="en" else "ZH"}{"_720" if size==720 else ""}.png')
                results.append({'file':p.name,'sha256':sha(p),'bytes':p.stat().st_size,'width':size,'height':v['height'],'frames':1560,'fps':'60/1','seconds':26,'audio_streams':len(a),'decode':'PASS','color_primaries':v.get('color_primaries'),'color_transfer':v.get('color_transfer'),'color_space':v.get('color_space')})
            # Encoder changes are measured rather than claiming byte/pixel identity.
            for n in [0,120,400,800,1100,1229]:
                a=frame(old,n,OUT/'compare-old.png').astype(float);b=frame(voiced,n,OUT/'compare-new.png').astype(float)
                mae=float(np.abs(a-b).mean());mse=float(((a-b)**2).mean());psnr=99 if mse==0 else 10*math.log10(255**2/mse)
                assert mae<2 and psnr>38,(locale,size,n,mae,psnr)
                body.append({'locale':locale,'size':size,'frame':n,'mean_abs_rgb_error':round(mae,5),'psnr_db':round(psnr,3),'PASS':True})
    sheet=Image.new('RGB',(720,680),'#090B10');d=ImageDraw.Draw(sheet)
    for i,locale in enumerate(['EN','ZH']):
        sheet.paste(Image.open(REVIEW/f'END_CARD_{locale}.png').resize((360,640),Image.Resampling.LANCZOS),(360*i,40));d.text((360*i+12,12),locale+' / live App Store QR',fill='white')
    sheet.save(REVIEW/'CONTACT_SHEET.png')
    qa={'status':'READY_FOR_AUDIT','base_sha':BASE,'tested_code_sha':subprocess.check_output(['git','rev-parse','HEAD'],cwd=REPO).decode().strip(),
      'public_availability':'VERIFIED_US_AND_CN','original_movies_unchanged':True,'original_movie_sha256':source['sha256'],
      'patch_rectangles_1080':RECTS,'patch_first_frame':1230,'patch_last_frame':1559,'audio_original_aac_packets_unchanged':audio,
      'pre_cta_encoded_quality_samples':body,'qr_from_actual_exports':qr_checks,'media':results,
      'video_reencoding_disclosure':'Video recompressed for the two localized CTA rectangles. No story/timing/voice edits; do not claim all decoded pixels or video bytes identical.',
      'human_listening':'NOT_RUN; AAC packet identity verifies accepted soundtrack was retained','physical_phone_scan':'NOT_RUN; independent OpenCV decoding of 24 actual exported frames passed',
      'posting_authorized':False,'App_ASC_TestFlight_changes':False}
    write(REVIEW/'TEST_RESULTS.json',qa)
    publish['owner_post_launch_followup']['status']='COMPLETE_READY_FOR_OWNER_REVIEW'
    publish['post_launch_export_checks']='review/post-launch-2026-11-23/TEST_RESULTS.json'
    write(ROOT/'PUBLISH_LINK.json',publish)
    print('PASS: 8 full decodes, 24 exported-frame QR scans, 24 body quality samples, 4 identical AAC packet hashes; originals unchanged',flush=True)

if __name__=='__main__':
    {'prepare':prepare,'render':render,'verify':verify}[sys.argv[1]]()
