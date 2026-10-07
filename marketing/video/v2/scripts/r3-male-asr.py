"""Measured relative word timings of actual new male WAVs; English source/recognition reused."""
from pathlib import Path
import json,re,unicodedata
from difflib import SequenceMatcher
from faster_whisper import WhisperModel
ROOT=Path(__file__).resolve().parents[1];V=ROOT/'review/director-r3-caption-male'
src=json.loads((V/'VOICE_SOURCE.json').read_text(encoding='utf8'))
old=json.loads((ROOT/'review/director-r3-opening/VOICE_ASR.json').read_text(encoding='utf8'))
model=WhisperModel('large-v3',device='cuda',compute_type='int8_float16',download_root='E:/video_to_md/models/faster-whisper',local_files_only=True)
def normal(s):return re.sub(r'[^a-z0-9\u4e00-\u9fff]','',unicodedata.normalize('NFKC',s).lower())
records=[]
for c in src['cues']:
    if c['locale']=='en':
        a=next(a for a in old['cues'] if a['locale']=='en' and a['id']==c['id'])
        rec={**a,'words':[{'word':w['word'],'start':w['start_seconds']-c['placement_start_seconds'],'end':w['end_seconds']-c['placement_start_seconds']} for w in a['word_timestamps']],'reuse':'Accepted English audio SHA unchanged; existing recognition reused'}
        records.append(rec);continue
    seg,_=model.transcribe(str(ROOT/c['file']),language='zh',beam_size=5,word_timestamps=True,vad_filter=False,condition_on_previous_text=False)
    seg=list(seg);text=' '.join(s.text.strip() for s in seg)
    score=SequenceMatcher(None,normal(text),normal(c['spoken_text'])).ratio()
    rec={'locale':'zh-Hans','id':c['id'],'expected':c['spoken_text'],'recognized':text,'normalized_agreement':score,'words':[{'word':w.word,'start':w.start,'end':w.end} for s in seg for w in s.words or []],'alignment_source':'Independent offline Whisper large-v3 of actual stock male WAV','subjective_listening':'NOT_RUN'}
    records.append(rec);print(json.dumps(rec,ensure_ascii=False),flush=True)
(V/'VOICE_ASR_RELATIVE.json').write_text(json.dumps({'cues':records,'subjective_listening':'NOT_RUN'},ensure_ascii=False,indent=2)+'\n',encoding='utf8')
assert all(a['normalized_agreement']>=.95 for a in records),'Speech recognition mismatch; inspect/regenerate actual cue, never fake a PASS'
print('New male phrases verified; accepted English timings retained',flush=True)
