"""Owner revision: regenerate every Chinese phrase in one stock male voice, no slot compression."""
from pathlib import Path
import json,time,hashlib
import numpy as np
import soundfile as sf
import torch
from qwen_tts import Qwen3TTSModel

ROOT=Path(__file__).resolve().parents[1]
REVIEW=ROOT/'review/director-r3-caption-male';REVIEW.mkdir(parents=True,exist_ok=True)
OUT=ROOT/'out/director-r3-caption-male/voice';OUT.mkdir(parents=True,exist_ok=True)
DEST=ROOT/'assets/voice/r3-caption-male/zh-Hans';DEST.mkdir(parents=True,exist_ok=True)
spec=json.loads((ROOT/'R3_COPY_AUDIO.json').read_text(encoding='utf8'))
instruction='用标准普通话，自然、有精神、清晰的男声，像向朋友介绍一个好用的产品。语气轻松自信，有重点但不过度兴奋，不喊、不用播音腔、不气声。句间自然停顿，语速舒适，不为了固定秒数赶话，不刻意拖长尾音。每个字都读完整，英文产品名和 PDF、AI 清楚自然。'
torch.set_num_threads(4)
model_source=json.loads((ROOT/'MODEL_SOURCE_R3.json').read_text(encoding='utf8'))
expected=next(r['sha256'] for r in model_source['files'] if r['file']=='model.safetensors')
with (ROOT/'models/qwen3-tts-1.7b/model.safetensors').open('rb') as f:
    assert hashlib.file_digest(f,'sha256').hexdigest()==expected,'Pinned model weight mismatch'
# Avoid Windows' whole-file memory-map commit during weight loading. Load the
# pinned, unchanged safetensors tensor-by-tensor to CUDA in this process only.
import transformers.modeling_utils as mu, struct
original_loader=mu.load_state_dict
def stream_weights(checkpoint_file,is_quantized=False,map_location='cpu',weights_only=True):
    if not str(checkpoint_file).endswith('.safetensors'):
        return original_loader(checkpoint_file,is_quantized,map_location,weights_only)
    types={'BF16':torch.bfloat16,'F16':torch.float16,'F32':torch.float32,'F64':torch.float64,'I64':torch.int64,'I32':torch.int32,'I16':torch.int16,'I8':torch.int8,'U8':torch.uint8,'BOOL':torch.bool}
    result={}
    with open(checkpoint_file,'rb') as f:
        header_size=struct.unpack('<Q',f.read(8))[0];header=json.loads(f.read(header_size));base=8+header_size
        for key,entry in header.items():
            if key=='__metadata__':continue
            dtype=types[entry['dtype']]
            if map_location=='meta':
                result[key]=torch.empty(entry['shape'],dtype=dtype,device='meta');continue
            lo,hi=entry['data_offsets'];f.seek(base+lo);buffer=bytearray(f.read(hi-lo));assert len(buffer)==hi-lo
            result[key]=torch.frombuffer(buffer,dtype=dtype).reshape(entry['shape']).to('cuda:0')
    return result
mu.load_state_dict=stream_weights
class StreamFile:
    def __init__(self,path,framework='pt',device='cpu'):
        self.file=open(path,'rb');n=struct.unpack('<Q',self.file.read(8))[0]
        self.header=json.loads(self.file.read(n));self.base=8+n;self.device=device
    def get_slice(self,key):
        entry=self.header[key];lo,hi=entry['data_offsets'];self.file.seek(self.base+lo)
        buffer=bytearray(self.file.read(hi-lo));assert len(buffer)==hi-lo
        types={'BF16':torch.bfloat16,'F16':torch.float16,'F32':torch.float32,'F64':torch.float64,'I64':torch.int64,'I32':torch.int32,'I16':torch.int16,'I8':torch.int8,'U8':torch.uint8,'BOOL':torch.bool}
        return torch.frombuffer(buffer,dtype=types[entry['dtype']]).reshape(entry['shape']).to(self.device)
    get_tensor=get_slice
    def metadata(self):return self.header.get('__metadata__')
    def keys(self):return [k for k in self.header if k!='__metadata__']
    def __enter__(self):return self
    def __exit__(self,*args):self.file.close()
    def __del__(self):self.file.close()
mu.safe_open=StreamFile
print('Loading existing pinned weights, streamed per tensor to CUDA',flush=True)
model=Qwen3TTSModel.from_pretrained(str(ROOT/'models/qwen3-tts-1.7b'),device_map='cuda:0',dtype=torch.bfloat16,attn_implementation='sdpa')
assert 'dylan' in [s.lower() for s in model.get_supported_speakers()]
print('Existing pinned Qwen model; stock male Dylan. All seven Chinese cues, no duration target / atempo.',flush=True)
records=[]
for i,cue in enumerate(spec['narration']['cues']):
    key=cue['id'];text=cue['spoken_text']['zh-Hans'];final=DEST/(key+'.wav');meta=DEST/(key+'.json')
    if final.exists() and meta.exists():
        m=json.loads(meta.read_text(encoding='utf8'))
        assert m['spoken_text']==text and m['speaker']=='Dylan' and m['instruction']==instruction
        assert hashlib.sha256(final.read_bytes()).hexdigest()==m['sha256']
        records.append(m);print('Cached',key,flush=True);continue
    torch.manual_seed(2607+i*19);began=time.monotonic()
    wavs,sr=model.generate_custom_voice(text=text,language='Chinese',speaker='Dylan',instruct=instruction,non_streaming_mode=True,max_new_tokens=512,do_sample=True,temperature=.7,top_p=.9)
    audio=np.asarray(wavs[0],dtype=np.float32);sf.write(OUT/(key+'-raw.wav'),audio,sr,subtype='PCM_16')
    hop=max(1,sr//100);energy=np.array([np.sqrt(np.mean(audio[j:j+hop]**2)) for j in range(0,len(audio),hop)])
    active=np.flatnonzero(energy>max(.0015,float(energy.max())*.018));assert len(active)
    left=max(0,int(active[0]*hop-.065*sr));right=min(len(audio),int((active[-1]+1)*hop+.065*sr))
    sf.write(final,audio[left:right],sr,subtype='PCM_16');duration=(right-left)/sr
    assert .4<duration<16,'Unexpected synthesis duration; inspect actual source, never truncate speech'
    m={'locale':'zh-Hans','id':key,'speaker':'Dylan','provider':'Local Qwen3-TTS CustomVoice','model':'Qwen/Qwen3-TTS-12Hz-1.7B-CustomVoice','revision':'0c0e3051f131929182e2c023b9537f8b1c68adfe','spoken_text':text,'instruction':instruction,'source_sample_rate':sr,'actual_duration_seconds':duration,'post_atempo':1,'no_fixed_duration_target':True,'trim_outer_silence_samples':[left,right],'generation_seconds':time.monotonic()-began,'sha256':hashlib.sha256(final.read_bytes()).hexdigest(),'file':final.relative_to(ROOT).as_posix(),'subjective_listening':'NOT_RUN'}
    meta.write_text(json.dumps(m,ensure_ascii=False,indent=2)+'\n',encoding='utf8');records.append(m)
    print(key,round(duration,3),'seconds; complete actual male waveform',flush=True)
old=json.loads((ROOT/'review/director-r3-opening/VOICE_TIMING.json').read_text(encoding='utf8'))
records=[c for c in old['cues'] if c['locale']=='en']+records
(REVIEW/'VOICE_SOURCE.json').write_text(json.dumps({'real_voice_source':True,'english_voice_waveforms_and_placements':'UNCHANGED','all_chinese_cues_regenerated':True,'male_stock_speaker':'Dylan','no_time_compression':True,'cues':records,'subjective_listening':'NOT_RUN'},ensure_ascii=False,indent=2)+'\n',encoding='utf8')
print('Complete English reuse + seven new actual Chinese male voices',flush=True)
