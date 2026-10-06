"""Anonymous pinned official Qwen weights; ignored local model directory only."""
from pathlib import Path
import urllib.request, json, concurrent.futures, time, hashlib
ROOT=Path(__file__).resolve().parents[1]
MODEL='Qwen/Qwen3-TTS-12Hz-1.7B-CustomVoice'
REV='0c0e3051f131929182e2c023b9537f8b1c68adfe'
DEST=ROOT/'models/qwen3-tts-1.7b';DEST.mkdir(parents=True,exist_ok=True)
op=urllib.request.build_opener(urllib.request.ProxyHandler({}))
def get(url):
    with op.open(urllib.request.Request(url,headers={'User-Agent':'LectureAsset-R3'}),timeout=90) as r:return json.load(r)
metadata=get('https://huggingface.co/api/models/'+MODEL+'/revision/'+REV)
files=[x['rfilename'] for x in metadata['siblings'] if x['rfilename']!='.gitattributes']
def download(name):
    p=DEST/name;p.parent.mkdir(parents=True,exist_ok=True)
    if p.exists():return {'file':name,'bytes':p.stat().st_size,'cached':True}
    temp=p.with_suffix(p.suffix+'.part')
    for attempt in range(5):
        offset=temp.stat().st_size if temp.exists() else 0
        headers={'User-Agent':'LectureAsset-R3'}
        if offset:headers['Range']='bytes='+str(offset)+'-'
        url='https://huggingface.co/'+MODEL+'/resolve/'+REV+'/'+name+'?download=true&attempt='+str(attempt)
        try:
            with op.open(urllib.request.Request(url,headers=headers),timeout=90) as r:
                append=offset>0 and r.status==206
                with temp.open('ab' if append else 'wb') as w:
                    last=time.monotonic();total=offset if append else 0
                    while block:=r.read(4*1024*1024):
                        w.write(block);total+=len(block)
                        if time.monotonic()-last>30:
                            print(name,round(total/2**20),'MiB downloaded',flush=True);last=time.monotonic()
            temp.replace(p)
            print('Complete',name,p.stat().st_size,flush=True)
            return {'file':name,'bytes':p.stat().st_size,'sha256':hashlib.file_digest(p.open('rb'),'sha256').hexdigest()}
        except Exception as e:
            print('Retry',name,type(e).__name__,flush=True)
            if attempt==4:raise
    raise RuntimeError(name)
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:records=list(pool.map(download,files))
(ROOT/'MODEL_SOURCE_R3.json').write_text(json.dumps({'model':MODEL,'revision':REV,'official_source':'https://huggingface.co/'+MODEL,'license':metadata.get('cardData',{}).get('license'),'files':records,'weights':'LOCAL_ONLY_IGNORED'},indent=2)+'\n',encoding='utf8')
print('Pinned model complete',flush=True)
