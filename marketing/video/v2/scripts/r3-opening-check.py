"""Decode and independently transcribe the opening actually present in each final MP4."""
from pathlib import Path
import hashlib,json,re,subprocess,unicodedata
from difflib import SequenceMatcher
from faster_whisper import WhisperModel

ROOT=Path(__file__).resolve().parents[1]
REVIEW=ROOT/'review/director-r3-opening'
OUT=ROOT/'out/director-r3-opening'
FF='E:/video_to_md/readable-transcript/resource/bin/ffmpeg.exe'
model=WhisperModel('large-v3',device='cuda',compute_type='int8_float16',download_root='E:/video_to_md/models/faster-whisper',local_files_only=True)
spec=json.loads((ROOT/'R3_COPY_AUDIO.json').read_text(encoding='utf8'))
voice=json.loads((REVIEW/'VOICE_TIMING.json').read_text(encoding='utf8'))
def normal(s):
    return re.sub(r'[^a-z0-9\u4e00-\u9fff]','',unicodedata.normalize('NFKC',s).lower())
checks=[]
for locale,stem,language in [('en','en-chatgpt','en'),('zh-Hans','zh-workbuddy','zh')]:
    movie=REVIEW/('director-cut-'+stem+'.mp4')
    decoded=OUT/('opening-'+locale+'.wav')
    subprocess.run([FF,'-v','error','-y','-i',str(movie),'-t','4.2','-vn','-ar','48000','-ac','1',str(decoded)],check=True)
    segments,_=model.transcribe(str(decoded),language=language,beam_size=5,word_timestamps=True,vad_filter=False,condition_on_previous_text=False)
    segments=list(segments)
    recognized=' '.join(s.text.strip() for s in segments)
    expected=spec['narration']['cues'][0]['spoken_text'][locale]
    agreement=SequenceMatcher(None,normal(expected),normal(recognized)).ratio()
    assert agreement>=.95,(locale,recognized,agreement)
    n01=next(c for c in voice['cues'] if c['locale']==locale and c['id']=='N01')
    n02=next(c for c in voice['cues'] if c['locale']==locale and c['id']=='N02')
    assert n01['timing_copy_adjustment'] is None
    assert n01['placement_end_seconds']<n02['placement_start_seconds']
    checks.append({'locale':locale,'movie_sha256':hashlib.sha256(movie.read_bytes()).hexdigest(),'decoded_seconds':4.2,'expected':expected,'recognized':recognized,'normalized_agreement':agreement,'narration_start':n01['placement_start_seconds'],'narration_end':n01['placement_end_seconds'],'next_narration_start':n02['placement_start_seconds'],'complete_first_and_second_clauses':normal(expected)==normal(recognized),'words':[{'word':w.word,'start':w.start,'end':w.end} for s in segments for w in s.words or []]})
    print(json.dumps(checks[-1],ensure_ascii=False),flush=True)
(REVIEW/'OPENING_AUDIO_CHECK.json').write_text(json.dumps({'status':'PASS','method':'Offline Whisper large-v3 of AAC decoded directly from final MP4 opening, not expected script metadata','subjective_listening':'NOT_RUN','checks':checks},ensure_ascii=False,indent=2)+'\n',encoding='utf8')
