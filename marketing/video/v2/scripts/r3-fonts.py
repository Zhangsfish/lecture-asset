"""Acquire pinned official fonts into the ignored local asset directory."""
from pathlib import Path
import urllib.request, zipfile, io, json, hashlib, datetime

ROOT=Path(__file__).resolve().parents[1]
DEST=ROOT/'assets/fonts'; DEST.mkdir(exist_ok=True)
op=urllib.request.build_opener(urllib.request.ProxyHandler({}))
records=[]
def get(url):
    with op.open(urllib.request.Request(url,headers={'User-Agent':'LectureAsset-R3'}),timeout=90) as r:return r.read()
def save(name,data,url,version):
    (DEST/name).write_bytes(data)
    records.append({'file':name,'source':url,'version':version,'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest()})
    print(name,len(data),flush=True)
base='https://raw.githubusercontent.com/adobe-fonts/source-han-sans/2.005R/'
for style in ['Bold','Regular']:
    url=base+'OTF/SimplifiedChinese/SourceHanSansSC-'+style+'.otf'
    save('SourceHanSansSC-'+style+'.otf',get(url),url,'2.005R')
licenses=ROOT/'assets/licenses';licenses.mkdir(exist_ok=True)
(licenses/'SourceHanSans-LICENSE.txt').write_bytes(get(base+'LICENSE.txt'))
url='https://github.com/rsms/inter/releases/download/v4.1/Inter-4.1.zip'
archive=zipfile.ZipFile(io.BytesIO(get(url)))
names=archive.namelist()
name=next(n for n in names if n.endswith('/InterVariable.ttf') or n=='InterVariable.ttf')
save('InterVariable.ttf',archive.read(name),url+'#'+name,'4.1')
lic=next(n for n in names if n.endswith('LICENSE.txt') or n.endswith('LICENSE'))
(licenses/'Inter-LICENSE.txt').write_bytes(archive.read(lic))
record={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'fonts':records,'binary_distribution':'LOCAL_ONLY_IGNORED'}
(ROOT/'FONT_SOURCES_R3.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf8')
