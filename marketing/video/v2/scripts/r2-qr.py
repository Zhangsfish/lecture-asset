"""Independent decode of the product URL from actual final MP4s, both resolutions."""
from pathlib import Path
import subprocess,json,datetime,cv2
ROOT=Path(__file__).resolve().parents[1];REVIEW=ROOT/'review/director-r2';OUT=ROOT/'out/director-r2';URL='https://apps.apple.com/us/app/id6816814541';FF='E:/video_to_md/readable-transcript/resource/bin/ffmpeg.exe'
checks=[]
for locale,stem in [('en','en-chatgpt'),('zh-Hans','zh-workbuddy')]:
 for size in [1080,720]:
  p=REVIEW/('director-cut-'+stem+('-720' if size==720 else '')+'.mp4');frame=OUT/(f'qr-{locale}-{size}.png')
  subprocess.run([FF,'-v','error','-y','-i',str(p),'-vf','select=eq(n\\,1500)','-frames:v','1',str(frame)],check=True)
  # Decode entire actual video frame; no replacing/overlaying QR crop with source.
  im=cv2.imread(str(frame));decoded,points,_=cv2.QRCodeDetector().detectAndDecode(im)
  assert decoded==URL,(locale,size,decoded)
  checks.append({'locale':locale,'movie':p.name,'frame':1500,'resolution':size,'decoded_url':decoded,'PASS':True,'detected_corners':points.tolist()})
publish=json.loads((ROOT/'PUBLISH_LINK.json').read_text(encoding='utf8'));publish['qr_exported_frame_checks']=checks;publish['qr_checked_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();(ROOT/'PUBLISH_LINK.json').write_text(json.dumps(publish,indent=2)+'\n',encoding='utf8')
qa=json.loads((REVIEW/'QA.json').read_text(encoding='utf8'));qa['qr_exported_frame_checks']=checks;qa['technical']='PASS';(REVIEW/'QA.json').write_text(json.dumps(qa,ensure_ascii=False,indent=2)+'\n',encoding='utf8');print(json.dumps({'QR':'PASS','actual_movie_frames':4,'url':URL}))
