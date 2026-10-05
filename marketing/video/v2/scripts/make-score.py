"""Original deterministic ambience and action foley; no external audio."""
from pathlib import Path
import numpy as np
import wave, json, hashlib
V2=Path(__file__).resolve().parents[1]
rate=48000
n=22*rate
t=np.arange(n)/rate
mix=np.zeros((n,2),np.float64)
rng=np.random.default_rng(1806)
events=[]
def put(signal,start,gain=1,pan=0):
    offset=round(start*rate)
    count=min(len(signal),n-offset)
    angle=(pan+1)*np.pi/4
    mix[offset:offset+count,0]+=signal[:count]*gain*np.cos(angle)
    mix[offset:offset+count,1]+=signal[:count]*gain*np.sin(angle)
def note(freq,start,duration,volume):
    z=np.arange(round(duration*rate))/rate
    attack=np.minimum(z/.035,1)
    envelope=attack*np.exp(-z/1.2)*np.minimum((duration-z)/.12,1)
    sound=(np.sin(2*np.pi*freq*z)+.22*np.sin(2*np.pi*freq*2*z)+.055*np.sin(2*np.pi*freq*3.01*z))*envelope
    put(sound,start,volume,pan=(-.3 if int(start*10)%2 else .3))
# Sparse, warm plucked notes. Breathing room at archive/report holds; no corporate drum loop.
for start,freq in [(0,146.83),(.6,220),(1.2,174.61),(1.8,293.66),(3,146.83),(3.6,220),(4.2,349.23),
                   (5.5,174.61),(6.1,261.63),(6.7,349.23),(7.3,440),
                   (8.2,146.83),(9.4,220),(10.6,293.66),
                   (11.8,174.61),(12.4,261.63),(13,349.23),(14.2,146.83),(14.8,220),(15.4,293.66),
                   (16.1,146.83),(17.7,174.61),(18.3,220),(19.5,293.66),(20.1,440),(20.7,587.33)]:
    note(freq,start,min(2.6,22-start),.058 if start<16.1 else .045)
for freq in [73.416,146.83,220]:
    pad=.009*np.sin(2*np.pi*freq*t)*(1+np.sin(t*.9))*.5
    pad*=np.minimum(t/.6,1)*np.minimum((22-t)/1,1)
    mix[:,0]+=pad;mix[:,1]+=pad*.9
def foley(start,duration,kind,gain=.13,pan=0):
    z=np.arange(round(duration*rate))/rate
    noise=rng.normal(0,1,len(z))
    # High-frequency paper texture via first difference, not bought foley.
    noise=np.r_[0,np.diff(noise)]*.12
    envelope=np.sin(np.pi*z/duration)**2
    if kind=="sweep":
        body=noise*np.sin(2*np.pi*(600*z+550*z*z))
    else:
        body=noise+.45*np.sin(2*np.pi*(85*z+45*z*z))*np.exp(-z*20)
    put(body*envelope,start,gain,pan)
    events.append({"name":kind,"start_seconds":start,"frame":round(start*60),"duration":duration})
foley(.05,.32,"sweep",.25,-.35)
foley(184/60,.24,"select",.15)
foley(296/60,.19,"paper-settle",.20,.1)
foley(492/60,.48,"sleeve-open",.24,.1)
foley(714/60,.42,"sweep",.19,.3)
# Report resolution: one warm lower transient/chord, no ping on every rectangle.
foley(966/60,.30,"report-resolve",.27,0)
for freq in [146.83,220,293.66,349.23]:
    note(freq,966/60,2.6,.042)
foley(1090/60,.55,"sweep",.16,-.15)
mix*=np.minimum(t/.035,1)[:,None]*np.minimum((22-t)/.6,1)[:,None]
peak=float(np.max(np.abs(mix)))
if peak>.78:mix*=.78/peak
samples=np.round(np.clip(mix,-.98,.98)*32767).astype("<i2")
dest=V2/"assets/sound";dest.mkdir(parents=True,exist_ok=True)
path=dest/"director-score.wav"
with wave.open(str(path),"wb") as w:
    w.setnchannels(2);w.setsampwidth(2);w.setframerate(rate);w.writeframes(samples.tobytes())
record={"method":"Original NumPy synthesis, deterministic RNG seed 1806; no sampled/downloaded track",
        "sample_rate":rate,"channels":2,"seconds":22,"sample_count":n,
        "sample_peak_dbfs":float(20*np.log10(np.max(np.abs(samples))/32767)),
        "cues":events,"sha256":hashlib.sha256(path.read_bytes()).hexdigest(),"human_listening":"NOT_RUN"}
(dest/"SOUND.json").write_text(json.dumps(record,indent=2),encoding="utf-8")
print(json.dumps({"wav":str(path),"peak_dbfs":record["sample_peak_dbfs"],"cues":len(events)}))
