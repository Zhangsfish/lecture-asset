"""New 132 BPM drum/bass score, measured voice ducking and independent stems."""
from pathlib import Path
import numpy as np
import wave,json,subprocess,hashlib,re

ROOT=Path(__file__).resolve().parents[1];SR=48000;N=SR*26
FF='E:/video_to_md/readable-transcript/resource/bin/ffmpeg.exe'
REVIEW=ROOT/'review/director-r3-opening';OUT=ROOT/'out/director-r3-opening';OUT.mkdir(parents=True,exist_ok=True)
DEST=ROOT/'assets/sound';DEST.mkdir(exist_ok=True)
SPEC=json.loads((ROOT/'R3_COPY_AUDIO.json').read_text(encoding='utf8'));rng=np.random.default_rng(1808);beat=60/132
music=np.zeros((N,2));sfx=np.zeros((N,2));events=[]
def put(target,sound,start,gain=1,pan=0):
    offset=round(start*SR)
    if offset>=N:return
    count=min(len(sound),N-offset);angle=(pan+1)*np.pi/4
    target[offset:offset+count,0]+=sound[:count]*gain*np.cos(angle)
    target[offset:offset+count,1]+=sound[:count]*gain*np.sin(angle)
def kick():
    t=np.arange(round(.22*SR))/SR
    phase=2*np.pi*(48*t+80*.022*(1-np.exp(-t/.022)))
    return (np.sin(phase)*np.exp(-t*19)+.09*rng.normal(size=len(t))*np.exp(-t*170))*np.minimum(t/.002,1)
def clap():
    t=np.arange(round(.12*SR))/SR;n=rng.normal(size=len(t));n=n-np.convolve(n,np.ones(20)/20,'same')
    env=np.exp(-t*34)*(1+.5*np.cos(2*np.pi*140*t))*np.minimum(t/.001,1)
    return .33*n*env
def hat(opened=False):
    duration=.07 if not opened else .15;t=np.arange(round(duration*SR))/SR
    n=rng.normal(size=len(t));n=np.r_[0,np.diff(n)]*.06
    return n*np.exp(-t*(90 if not opened else 35))*np.minimum(t/.001,1)
def bass(freq,duration):
    t=np.arange(round(duration*SR))/SR
    envelope=np.minimum(t/.008,1)*np.exp(-t/ .14)*np.minimum((duration-t)/.035,1)
    # Mid harmonics remain audible on phone speakers; no long pad or bass rumble.
    return (np.sin(2*np.pi*freq*t)+.40*np.sin(2*np.pi*freq*2*t)+.22*np.sin(2*np.pi*freq*3*t)+.13*np.sin(2*np.pi*freq*5*t))*envelope
def stage(t):
    if 11.2<=t<13.4:return .64
    if 15.48<=t<17.5:return .74
    if t>=20.5:return .80
    return 1
for b in range(58):
    t=b*beat;gain=stage(t)
    if not (11.2<=t<13.4 and b%4 in [1,3]):put(music,kick(),t,.42*gain)
    if b%4 in [1,3]:put(music,clap(),t,.26*gain,pan=.06)
    for j in [0,.5]:put(music,hat(),t+j*beat,.15*gain,pan=(-.35 if j==0 else .35))
    if 4.2<t<11.2 or 17.5<t<20.5:put(music,hat(),t+.75*beat,.085,pan=.45)
    frequency=[73.416,73.416,97.999,87.307][(b//4)%4]
    if b%4 in [0,2,3]:put(music,bass(frequency,.32),t,.22*gain)
    if b%4 in [1,3]:put(music,bass(frequency*2,.17),t+.5*beat,.115*gain)
    # Very short controlled upper accent, never the former soothing pluck sequence.
    if b%8==6 and 3<t<17.5:put(music,bass(frequency*8,.14),t+.25*beat,.036,pan=.35)
def whoosh(duration):
    t=np.arange(round(duration*SR))/SR;n=rng.normal(size=len(t));n=np.convolve(n,np.ones(12)/12,'same')
    return n*np.sin(np.pi*t/duration)**2*.3
for frame in SPEC['sound']['accent_frames']:
    t=frame/60
    put(sfx,kick(),t,.18)
    if frame in [252,504,672,1050]:put(sfx,whoosh(.22),max(0,t-.1),.3,pan=.2)
    if frame in [336,945,1230]:
        for freq in [293.665,391.995,440]:put(sfx,bass(freq,.25),t,.072)
    events.append({'frame':frame,'seconds':t,'event':'arranged accent/resolve, original synthesized audio'})
fade=np.minimum((26-np.arange(N)/SR)/.35,1).clip(0,1)
music*=fade[:,None];sfx*=fade[:,None]
def wav(path,a):
    path.parent.mkdir(parents=True,exist_ok=True)
    if a.ndim==1:a=np.column_stack([a,a])
    with wave.open(str(path),'wb') as f:
        f.setnchannels(2);f.setsampwidth(2);f.setframerate(SR);f.writeframes((a.clip(-.999,.999)*32767).astype('<i2').tobytes())
wav(REVIEW/'music-r3-un-ducked.wav',music);wav(REVIEW/'sfx-r3.wav',sfx)
timing=json.loads((REVIEW/'VOICE_TIMING.json').read_text(encoding='utf8'))
results=[]
for locale in ['en','zh-Hans']:
    voice=np.zeros((N,2));duck=np.ones(N)
    cues=[c for c in timing['cues'] if c['locale']==locale]
    for cue in cues:
        raw=OUT/(locale+'-'+cue['id']+'-48k.f32')
        subprocess.run([FF,'-v','error','-y','-i',str(ROOT/cue['file']),'-ar',str(SR),'-ac','1','-f','f32le',str(raw)],check=True)
        a=np.fromfile(raw,dtype='<f4').astype(float);rms=np.sqrt(np.mean(a*a));a*=.125/max(rms,.001)
        if np.abs(a).max()>.69:a*=.69/np.abs(a).max()
        start=round(cue['placement_start_seconds']*SR);length=min(len(a),N-start)
        voice[start:start+length]+=np.column_stack([a[:length],a[:length]])
        # Smooth 7.5 dB gain reduction around actual voiced phrase, not a constant quiet mix.
        lo=max(0,start-int(.10*SR));hi=min(N,start+length+int(.15*SR));level=10**(-7.5/20)
        env=np.full(hi-lo,level);attack=start-lo;release=hi-start-length
        if attack:env[:attack]=np.linspace(1,level,attack)
        if release:env[-release:]=np.linspace(level,1,release)
        duck[lo:hi]=np.minimum(duck[lo:hi],env)
    mixed_music=music*duck[:,None]
    wav(REVIEW/('narration-'+locale+'.wav'),voice);wav(REVIEW/('music-r3-ducked-'+locale+'.wav'),mixed_music)
    # Control narration crest factor before summing; no final hard limiter.
    voice_input=OUT/('voice-input-'+locale+'.wav');wav(voice_input,voice)
    voice_pcm=OUT/('voice-compressed-'+locale+'.f32')
    subprocess.run([FF,'-v','error','-y','-i',str(voice_input),'-af','acompressor=threshold=0.08:ratio=3:attack=8:release=100:makeup=1.7','-f','f32le',str(voice_pcm)],check=True)
    voice=np.fromfile(voice_pcm,dtype='<f4').reshape(-1,2)
    wav(REVIEW/('narration-'+locale+'.wav'),voice)
    premix=voice+mixed_music+sfx
    assert np.abs(premix).max()<.999, 'Pre-master clipping: rebalance stems'
    raw_pre=OUT/('mix-raw-'+locale+'.wav');wav(raw_pre,premix)
    pre=OUT/('mix-pre-'+locale+'.wav')
    subprocess.run([FF,'-v','error','-y','-i',str(raw_pre),'-af','acompressor=threshold=0.10:ratio=2:attack=2:release=80:makeup=1','-ar',str(SR),str(pre)],check=True)
    analysis=subprocess.run([FF,'-hide_banner','-i',str(pre),'-af','loudnorm=I=-14.5:TP=-1:LRA=9:print_format=json','-f','null','-'],capture_output=True,text=True,encoding='utf8').stderr
    loud=json.loads(analysis[analysis.rfind('{'):analysis.rfind('}')+1]);gain=-14.5-float(loud['input_i'])
    if float(loud['input_tp'])+gain>-1.4:gain=-1.4-float(loud['input_tp'])
    final=DEST/('r3-opening-mix-'+locale+'.wav')
    subprocess.run([FF,'-v','error','-y','-i',str(pre),'-af',f'volume={gain:.6f}dB','-ar',str(SR),str(final)],check=True)
    check=subprocess.run([FF,'-hide_banner','-i',str(final),'-af','loudnorm=I=-14.5:TP=-1:LRA=9:print_format=json','-f','null','-'],capture_output=True,text=True,encoding='utf8').stderr
    stats=json.loads(check[check.rfind('{'):check.rfind('}')+1]);I=float(stats['input_i']);TP=float(stats['input_tp'])
    assert -15.5<=I<=-13.5 and TP<=-1,(locale,stats)
    results.append({'locale':locale,'mix':final.relative_to(ROOT).as_posix(),'sha256':hashlib.sha256(final.read_bytes()).hexdigest(),'loudness_lufs':I,'true_peak_dbtp':TP,'applied_linear_gain_db':gain,'music_duck_db':7.5,'voice_files':7,'source_voice_sample_rate':cues[0]['source_sample_rate'],'mix_sample_rate':SR,'loudness_metrics':stats,'subjective_listening':'NOT_RUN'})
qa={'arrangement':'New original 132 BPM drums, midrange bass, short controlled accent; deterministic seed 1808; R2 score not loaded','bpm':132,'time_signature':'4/4','first_attack_seconds':0,'accent_events':events,'voice_real':True,'languages':results,'subjective_listening':'NOT_RUN','no_purchase_or_external_music':True}
(REVIEW/'AUDIO_QA.json').write_text(json.dumps(qa,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
print(json.dumps(results,ensure_ascii=False,indent=2))
