"""Independent recognition of speech actually encoded in delivered movies."""
from pathlib import Path
import json,re,hashlib,subprocess,unicodedata
from difflib import SequenceMatcher
from faster_whisper import WhisperModel
R=Path(__file__).resolve().parents[1];V=R/'review/director-r3-caption-male';O=R/'out/director-r3-caption-male'
FF='E:/video_to_md/readable-transcript/resource/bin/ffmpeg.exe'
voice=json.loads((V/'VOICE_TIMING.json').read_text(encoding='utf8'))
model=WhisperModel('large-v3',device='cuda',compute_type='int8_float16',download_root='E:/video_to_md/models/faster-whisper',local_files_only=True)
def norm(s):return re.sub(r'[^a-z0-9\u4e00-\u9fff]','',unicodedata.normalize('NFKC',s).lower())
checks=[]
for c in voice['cues']:
 if c['locale']=='en' and c['id']!='N01':continue
 locale=c['locale'];stem='en-chatgpt' if locale=='en' else 'zh-workbuddy';movie=V/('director-cut-'+stem+'.mp4');decoded=O/('encoded-'+locale+'-'+c['id']+'.wav')
 start=max(0,c['placement_start_seconds']-.05);end=c['placement_end_seconds']+.15
 subprocess.run([FF,'-v','error','-y','-ss',str(start),'-i',str(movie),'-t',str(end-start),'-vn','-ar','48000','-ac','1',str(decoded)],check=True)
 segments,_=model.transcribe(str(decoded),language='en' if locale=='en' else 'zh',beam_size=5,word_timestamps=True,vad_filter=False,condition_on_previous_text=False)
 segments=list(segments);text=' '.join(s.text.strip() for s in segments);score=SequenceMatcher(None,norm(text),norm(c['spoken_text'])).ratio()
 r={'locale':locale,'cue':c['id'],'expected':c['spoken_text'],'recognized':text,'normalized_agreement':score,'actual_mp4_clip_seconds':[start,end],'movie_sha256':hashlib.sha256(movie.read_bytes()).hexdigest(),'words':[{'word':w.word,'start':w.start+start,'end':w.end+start} for s in segments for w in s.words or []]}
 checks.append(r);print(json.dumps(r,ensure_ascii=False),flush=True)
(V/'ENCODED_VOICE_CHECK.json').write_text(json.dumps({'status':'PASS' if all(c['normalized_agreement']>=.95 for c in checks) else 'FAIL','method':'Actual AAC decoded from MP4, offline Whisper large-v3, no script prompt','checks':checks,'subjective_listening':'NOT_RUN'},ensure_ascii=False,indent=2)+'\n',encoding='utf8')
assert all(c['normalized_agreement']>=.95 for c in checks),'Encoded speech mismatch; do not mark complete'
