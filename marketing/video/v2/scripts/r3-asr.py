"""Independent existing offline Whisper ASR of actual generated narration."""
from pathlib import Path
import json,re,unicodedata,time
from difflib import SequenceMatcher
from faster_whisper import WhisperModel

ROOT=Path(__file__).resolve().parents[1];REVIEW=ROOT/'review/director-r3'
timing=json.loads((REVIEW/'VOICE_TIMING.json').read_text(encoding='utf8'))
# Existing previously authorized offline ASR cache; no credentials or private media.
cache=Path('E:/video_to_md/models/faster-whisper')
model=WhisperModel('large-v3',device='cuda',compute_type='int8_float16',download_root=str(cache),local_files_only=True)
records=[]
def normal(s):
    s=unicodedata.normalize('NFKC',s).lower()
    return re.sub(r'[^a-z0-9\u4e00-\u9fff]','',s)
for cue in timing['cues']:
    locale=cue['locale'];began=time.monotonic()
    segments,info=model.transcribe(str(ROOT/cue['file']),language='en' if locale=='en' else 'zh',beam_size=5,word_timestamps=True,vad_filter=False,condition_on_previous_text=False)
    segments=list(segments);text=' '.join(s.text.strip() for s in segments)
    expected=normal(cue['spoken_text']);got=normal(text)
    score=SequenceMatcher(None,expected,got).ratio()
    words=[{'word':w.word,'start_seconds':w.start+cue['placement_start_seconds'],'end_seconds':w.end+cue['placement_start_seconds'],'probability':w.probability} for s in segments for w in s.words or []]
    record={'locale':locale,'id':cue['id'],'expected':cue['spoken_text'],'recognized':text,'normalized_agreement':score,'word_timestamps':words,'alignment_source':'Actual independent offline Whisper large-v3 word alignment, not character interpolation','seconds_to_transcribe':time.monotonic()-began,'human_pronunciation_listening':'NOT_RUN'}
    records.append(record);print(json.dumps({k:record[k] for k in ['locale','id','recognized','normalized_agreement']},ensure_ascii=False),flush=True)
result={'engine':'Existing faster-whisper large-v3 CUDA int8_float16, offline cached weights','no_new_ASR_model_download':True,'cues':records,'asr_match_limit':.85,'subjective_listening':'NOT_RUN'}
(REVIEW/'VOICE_ASR.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
timing['independent_word_alignment']='VOICE_ASR.json';(REVIEW/'VOICE_TIMING.json').write_text(json.dumps(timing,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
def stamp(t):
    msec=round(t*1000);h=msec//3600000;m=(msec//60000)%60;s=(msec//1000)%60
    return f'{h:02}:{m:02}:{s:02},{msec%1000:03}'
for locale in ['en','zh-Hans']:
    cues=[c for c in timing['cues'] if c['locale']==locale]
    lines=[]
    for i,c in enumerate(cues):lines.extend([str(i+1),stamp(c['placement_start_seconds'])+' --> '+stamp(c['placement_end_seconds']),c['spoken_text'],''])
    (REVIEW/('narration-'+locale+'.srt')).write_text('\n'.join(lines),encoding='utf8')
print('Actual ASR/word timing and separate phrase-level accessibility SRT complete',flush=True)
