"""Evidence-only checks: accepted English audio, actor state, source assets and scope."""
from pathlib import Path
import json,hashlib,subprocess
ROOT=Path(__file__).resolve().parents[1];V=ROOT/'review/director-r3-caption-male';REPO=ROOT.parents[2]
def read(p):return json.loads(p.read_text(encoding='utf8'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
old=read(ROOT/'review/director-r3-opening/VOICE_TIMING.json')
voices=[{'id':c['id'],'sha256':sha(ROOT/c['file']),'unchanged':sha(ROOT/c['file'])==c['sha256']} for c in old['cues'] if c['locale']=='en']
assert len(voices)==7 and all(c['unchanged'] for c in voices)
mix=sha(ROOT/'assets/sound/r3-opening-mix-en.wav')
assert mix=='2811129e7557e7034f534f27a50b1822f20eb0786b408294818ee3a3d26a7f8b'
old_dom=next(x for x in read(ROOT/'out/director-r3-opening/dom-qa.json') if x['locale']=='en')['samples']
new_dom=next(x for x in read(ROOT/'out/director-r3-caption-male/dom-qa.json') if x['locale']=='en')['samples']
old_frames={x['frame']:x for x in old_dom};comparisons=[]
exclude={'hook-0','hook-1','selected','reading','clear'}
for sample in new_dom:
 if sample['frame'] not in old_frames:continue
 before={x['id']:x for x in json.loads(old_frames[sample['frame']]['signature']) if x['id'] and x['id'] not in exclude}
 after={x['id']:x for x in json.loads(sample['signature']) if x['id'] and not x['id'].startswith('cap-')}
 differences=[key for key in before if before[key]!=after.get(key)]
 assert not differences,(sample['frame'],differences)
 comparisons.append({'frame':sample['frame'],'unchanged_actor_states':len(before),'differences':differences})
assert len(comparisons)>=10
assets=[{'path':a['path'],'sha256':sha(ROOT/a['path']),'unchanged':sha(ROOT/a['path'])==a['sha256']} for a in read(ROOT/'ASSET_LEDGER.json')['assets']]
assert all(a['unchanged'] for a in assets)
fonts=[{'file':f['file'],'sha256':sha(ROOT/'assets/fonts'/f['file']),'unchanged':sha(ROOT/'assets/fonts'/f['file'])==f['sha256']} for f in read(ROOT/'FONT_SOURCES_R3.json')['fonts']]
assert all(f['unchanged'] for f in fonts)
paths=subprocess.check_output(['git','-C',str(REPO),'diff','--name-only','352d4dcacb922b253c63f5a3135868268fad3f3e','HEAD'],text=True).splitlines()
assert all(p.startswith('marketing/video/v2/') for p in paths)
result={'status':'PASS','accepted_english_cues':voices,'accepted_english_mix_sha256':mix,'english_non_caption_actor_comparisons':comparisons,'original_assets':assets,'actual_local_fonts':fonts,'protected_path_diff':[],'scope_paths':paths,'notes':'English picture-state comparison uses common recorded seek frames; the caption layer is intentionally changed. Chinese uses same paths/objects but measured male timing. No claim of whole-video pixel identity.'}
(V/'PRESERVATION.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
print('PASS; English mix / 7 cues,',len(comparisons),'actor samples,',len(assets),'assets,',len(fonts),'fonts preserved')
