"""Real stock-voice Qwen3 TTS, measured phrase placement; no cloning/cloud fallback."""
from pathlib import Path
import json, time, hashlib, subprocess, wave
import numpy as np
import torch
import soundfile as sf
from qwen_tts import Qwen3TTSModel

ROOT=Path(__file__).resolve().parents[1]
SPEC=json.loads((ROOT/'R3_COPY_AUDIO.json').read_text(encoding='utf8'))
OUT=ROOT/'out/director-r3/voice';OUT.mkdir(parents=True,exist_ok=True)
REVIEW=ROOT/'review/director-r3';REVIEW.mkdir(parents=True,exist_ok=True)
FF='E:/video_to_md/readable-transcript/resource/bin/ffmpeg.exe'
torch.set_num_threads(4);torch.manual_seed(1807)
print('Load pinned 1.7B CustomVoice BF16 with SDPA on RTX 4060',flush=True)
model=Qwen3TTSModel.from_pretrained(str(ROOT/'models/qwen3-tts-1.7b'),device_map='cuda:0',dtype=torch.bfloat16,attn_implementation='sdpa')
print('Loaded; supported speakers',model.get_supported_speakers(),flush=True)
records=[]
for locale,speaker,language in [('en','Ryan','English'),('zh-Hans','Vivian','Chinese')]:
    dest=ROOT/'assets/voice/r3'/locale;dest.mkdir(parents=True,exist_ok=True)
    for cue in SPEC['narration']['cues']:
        key=cue['id'];original_text=cue['spoken_text'][locale]
        text=({'en':'Lecture photos. Too scattered for AI.','zh-Hans':'交给 AI，又太散。'}[locale] if key=='N01' else original_text)
        start,end=cue['window_seconds'];window=end-start
        final=dest/(key+'.wav');meta=dest/(key+'.json')
        if final.exists() and meta.exists():
            records.append(json.loads(meta.read_text(encoding='utf8')));print('Cached',locale,key,flush=True);continue
        instruction=SPEC['narration']['voice_style_en' if locale=='en' else 'voice_style_zh']
        prefix=('Speak quickly at about 210 words per minute with very short pauses. Crisp fluent product narration. ' if locale=='en' else '用明亮利落的快节奏产品旁白，快速流利地说，停顿极短，不拖尾。')
        if locale=='en' and key=='N05':prefix='Speak at a clear conversational 160 words per minute. Give summary and report distinct stresses, without rushing. '
        if locale=='zh-Hans' and key=='N03':prefix='完整清楚地朗读，开头的“连”字也要清楚，明亮自信，短停顿。'
        attempts=[]
        for attempt in range(4):
            speed=(f' Deliver this short line in about {window-.2:.1f} seconds, briskly and fluently, with every word intact.' if locale=='en' else f' 请紧凑流利地朗读这句，在约{window-.2:.1f}秒内说完，短停顿，不拖尾，字句完整。')
            if attempt:speed+=(' Faster conversational pace, concise pauses.' if locale=='en' else ' 比上次更利落更快，句间停顿短。')
            torch.manual_seed(1807+len(records)*17+attempt+(100 if (locale,key) in [('en','N05'),('zh-Hans','N03')] else 0))
            began=time.monotonic()
            wavs,sr=model.generate_custom_voice(text=text,language=language,speaker=speaker,instruct=prefix+instruction+speed,non_streaming_mode=True,max_new_tokens=240,do_sample=True,temperature=.75,top_p=.9)
            audio=np.asarray(wavs[0],dtype=np.float32)
            raw=OUT/f'{locale}-{key}-attempt-{attempt+1}.wav';sf.write(raw,audio,sr,subtype='PCM_16')
            # Remove only leading/trailing silence, keep 65ms margin around detected energy.
            hop=max(1,sr//100);energy=np.array([np.sqrt(np.mean(audio[i:i+hop]**2)) for i in range(0,len(audio),hop)])
            active=np.flatnonzero(energy>max(.0015,float(energy.max())*.018))
            if not len(active):raise RuntimeError('No speech energy '+key)
            left=max(0,int(active[0]*hop-.065*sr));right=min(len(audio),int((active[-1]+1)*hop+.065*sr))
            clipped=audio[left:right];seconds=len(clipped)/sr
            attempts.append({'attempt':attempt+1,'raw_seconds':len(audio)/sr,'speech_seconds':seconds,'generation_seconds':time.monotonic()-began,'trim_samples':[left,right]})
            print(locale,key,'attempt',attempt+1,'seconds',round(seconds,3),'slot',window,flush=True)
            if seconds<=window*1.08:break
        if seconds>window*1.08:raise RuntimeError(f'VOICE_SLOT_OVERFLOW {locale} {key}: {seconds:.3f} vs {window:.3f}; speech is preserved in out/')
        processed=OUT/f'{locale}-{key}-trimmed.wav';sf.write(processed,clipped,sr,subtype='PCM_16')
        factor=max(1,seconds/window)
        # Pitch-preserving correction is never more than 1.08x; no stretching.
        args=[FF,'-v','error','-y','-i',str(processed),'-af',f'atempo={factor:.8f}','-ar',str(sr),'-ac','1',str(final)]
        subprocess.run(args,check=True)
        data,actual_sr=sf.read(final);duration=len(data)/actual_sr
        if start+duration>end+.015:raise RuntimeError('Processed voice escaped slot')
        record={'locale':locale,'id':key,'speaker':speaker,'provider':'Local Qwen3-TTS CustomVoice','model':'Qwen/Qwen3-TTS-12Hz-1.7B-CustomVoice','revision':'0c0e3051f131929182e2c023b9537f8b1c68adfe','spoken_text':text,'original_planned_text':original_text,'timing_copy_adjustment':'N01 condensed after actual original generation exceeded 2.75s slot: EN original minimum3.245s; ZH original4.86s/3.905s. Album congestion remains visible; AI scattering clause preserved. No speech truncation.' if text!=original_text else None,'instruction':prefix+instruction+speed,'source_sample_rate':actual_sr,'placement_start_seconds':start,'actual_duration_seconds':duration,'placement_end_seconds':start+duration,'window_seconds':[start,end],'post_atempo':factor,'attempts':attempts,'sha256':hashlib.sha256(final.read_bytes()).hexdigest(),'file':final.relative_to(ROOT).as_posix(),'timestamps':'Measured sample-level phrase start/end, not invented word timestamps','subjective_listening':'NOT_RUN'}
        meta.write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n',encoding='utf8');records.append(record)
    print(locale,'all seven real phrases complete',flush=True)
(REVIEW/'VOICE_TIMING.json').write_text(json.dumps({'real_voice_source':True,'cloud_credentials':'NO_EXISTING_PROJECT_TTS_CREDENTIALS_FOUND','local_model':'1.7B instruction capable, BF16 SDPA, preset voices only','cues':records,'peak_cuda_allocated_mib':torch.cuda.max_memory_allocated()/2**20,'peak_cuda_reserved_mib':torch.cuda.max_memory_reserved()/2**20,'subjective_listening':'NOT_RUN'},ensure_ascii=False,indent=2)+'\n',encoding='utf8')
print('14 actual voice files complete',flush=True)
