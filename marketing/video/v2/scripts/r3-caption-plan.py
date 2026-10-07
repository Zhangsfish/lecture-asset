"""Use actual phrase/word measurements; key display copy is not the full transcript."""
from pathlib import Path
import json,re,math,hashlib
ROOT=Path(__file__).resolve().parents[1];V=ROOT/'review/director-r3-caption-male'
def read(p):return json.loads(p.read_text(encoding='utf8'))
def write(p,x):p.write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
source=read(V/'VOICE_SOURCE.json');recognition=read(V/'VOICE_ASR_RELATIVE.json')
def normal(s):return re.sub(r'[^a-z0-9\u4e00-\u9fff]','',s.lower())
def span(locale,key,text):
    r=next(r for r in recognition['cues'] if r['locale']==locale and r['id']==key)
    words=r['words'];joined=''.join(normal(w['word']) for w in words);frag=normal(text)
    lo=joined.find(frag);assert lo>=0,(locale,key,text,joined)
    hi=lo+len(frag);offset=0;hit=[]
    for w in words:
        n=len(normal(w['word']))
        if offset<hi and offset+n>lo:hit.append(w)
        offset+=n
    assert hit
    return hit[0]['start'],hit[-1]['end']
def ceil(t):return math.ceil(t*60)/60
locales={};all_cues=[];all_asr=[]
for locale in ['en','zh-Hans']:
    cues={c['id']:dict(c) for c in source['cues'] if c['locale']==locale}
    def start(key,t):
        c=cues[key];c['placement_start_seconds']=t;c['placement_end_seconds']=t+c['actual_duration_seconds']
    if locale=='zh-Hans':
        start('N01',.15);start('N02',max(4.3,cues['N01']['placement_end_seconds']+.35))
        for key,previous,minimum,gap in [('N03','N02',8.55,.5),('N04','N03',11.45,.5),('N05','N04',13.55,.5),('N06','N05',17.7,2.2)]:
            start(key,max(minimum,cues[previous]['placement_end_seconds']+gap))
        saved_end=cues['N06']['placement_start_seconds']+span(locale,'N06','资料留好')[1]
        departure=saved_end+.15
        end_card=ceil(max(20.5,cues['N06']['placement_end_seconds']+.7,departure+1.6))
        start('N07',end_card+.15);duration=ceil(max(end_card+5.5,cues['N07']['placement_end_seconds']+.8))
    else:end_card=20.5;duration=26
    def word(key,fragment):
        a,b=span(locale,key,fragment);s=cues[key]['placement_start_seconds'];return s+a,s+b
    # Semantically timed emphasis. Two file labels arrive at their spoken nouns.
    caps=[]
    def cap(id,key,lines,fragment=None,kind='top',until=None,line_fragments=None):
        s,e=word(key,fragment) if fragment else (cues[key]['placement_start_seconds'],cues[key]['placement_end_seconds'])
        e=until if until is not None else e+.12
        lt=[s] if not line_fragments else [word(key,f)[0] for f in line_fragments]
        if len(lt)==1:lt*=len(lines)
        caps.append({'id':'cap-'+id,'source':key,'lines':lines,'kind':kind,'start':s,'end':e,'line_times':lt,'alignment':'Actual independently recognized word/phrase interval; emphasis copy only'})
    if locale=='en':
        cap('hook-life','N01',['Lecture photos','everywhere'],'Lecture photos everywhere',kind='hook')
        cap('hook-ai','N01',['Too scattered','for AI'],'Too scattered for AI',kind='hook')
        cap('brand-name','N02',['Lecture Asset'],'Lecture Asset')
        cap('files','N02',['A PDF for you','A ZIP for AI'],'PDF',until=cues['N02']['placement_end_seconds']+.12,line_fragments=['PDF','ZIP'])
        cap('read','N03',['Reading rules','included'])
        cap('handoff','N04',['Hand it to AI'])
        cap('summary','N05',['Lecture summary'],'lecture summary')
        cap('report','N05',['Lecture report'],'report',until=cues['N05']['placement_end_seconds']+.4)
        cap('saved-copy','N06',['Save the files'],'Save the files')
        cap('clear-copy','N06',['Clear the photos'],'Clear the photos')
    else:
        cap('hook-life','N01',['照片塞满相册'],'照片塞满相册',kind='hook')
        cap('hook-ai','N01',['交给 AI','又太麻烦'],'交给AI又太麻烦',kind='hook')
        cap('brand-name','N02',['Lecture Asset'],'Lecture Asset')
        cap('files','N02',['一份 PDF','一份 AI ZIP'],'PDF',until=cues['N02']['placement_end_seconds']+.12,line_fragments=['PDF','AI资料包'])
        cap('read','N03',['连怎么读','都准备好了'])
        cap('handoff','N04',['交给 AI'])
        cap('summary','N05',['讲座总结'],'讲座总结')
        cap('report','N05',['讲座报告'],'报告',until=cues['N05']['placement_end_seconds']+.4)
        cap('saved-copy','N06',['资料留好'],'资料留好')
        cap('clear-copy','N06',['安心清理'],'安心清理')
    # Prevent outgoing words overlapping the next semantic caption.
    for a,b in zip(caps,caps[1:]):
        a['end']=min(a['end'],b['start'])
        assert a['end']>a['start']+.15,(locale,a)
    if locale=='en':knots=[[0,0],[3,4.2],[5,5.6],[7.5,8.4],[10.5,11.2],[13.7,14.05],[17.5,17.5],[26,26]]
    else:
        n2=cues['N02']['placement_start_seconds'];pdf=word('N02','PDF')[0];report=word('N05','报告')[0]
        # Same visual objects/trajectories; allow full new speech comfortable time.
        knots=[[0,0],[3,n2-.1],[5,max(n2+.6,pdf-.35)],[7.5,cues['N03']['placement_start_seconds']-.15],[10.5,cues['N04']['placement_start_seconds']-.2],[13.7,word('N05','讲座总结')[0]],[14.5,report-.3],[15.27,max(report+.5,word('N05','报告')[1])],[17.5,cues['N06']['placement_start_seconds']-.2],[18.55,departure],[20.5,end_card],[26,duration]]
    assert all(b[0]>a[0] and b[1]>a[1] for a,b in zip(knots,knots[1:])),knots
    def map(t):
        for (a,b),(c,d) in zip(knots,knots[1:]):
            if t<=c:return b+(t-a)*(d-b)/(c-a)
        return duration
    frames=round(duration*60);end_frame=round(end_card*60)
    hero=[120,round(map(4.45)*60),round((caps[3]['line_times'][-1]+.22)*60),round((caps[4]['start']+.4)*60),round((caps[5]['start']+.5)*60),round(map(16)*60),round(map(19.4)*60),end_frame]
    handoff=[round(map(t)*60) for t in [11.9,12.9,13.5,16]]
    review=set([0,15,30,45,60,90,120,150,180,210,240,end_frame-1,end_frame,end_frame+1,end_frame+12,frames-1,*hero,*handoff])
    for c in caps:
        review.update(round(t*60) for t in [c['start'],min(c['end']-.13,c['start']+.3),c['end']-.01,*[t+.22 for t in c['line_times']]])
        review.add(round(min(c['end']-.13,max(c['line_times'])+.2)*60))
    review.add(round((caps[1]['start']+.25)*60))
    review.update(round(map(t)*60) for t in [4,4.9,7.49,8.8,10.3,15.5,16.5,17.49,18.05,18.54,19.2,20.1])
    locales[locale]={'duration':duration,'frames':frames,'end_card':end_card,'mix':'assets/sound/'+('r3-opening-mix-en.wav' if locale=='en' else 'r3-caption-male-mix-zh-Hans.wav'),'knots':knots,'captions':caps,'review_frames':sorted(f for f in review if 0<=f<frames),'hero_frames':hero,'handoff_frames':handoff,'report_start':map(14.75),'report_ready':map(15.27),'saved_full':map(18.05),'departure_start':map(18.55),'influx_complete':4,'middle_start':map(7.5),'middle_end':map(17.5),'sound_accents':[map(t) for t in [0,3,5,7.5,10.5,13.7,15.27,17.5,20.5]]}
    for c in cues.values():
        c['window_seconds']=[c['placement_start_seconds'],c['placement_end_seconds']+.1];all_cues.append(c)
        a=next(a for a in recognition['cues'] if a['locale']==locale and a['id']==c['id'])
        all_asr.append({**a,'word_timestamps':[{'word':w['word'],'start_seconds':w['start']+c['placement_start_seconds'],'end_seconds':w['end']+c['placement_start_seconds']} for w in a['words']]})
    print(locale,duration,'seconds',frames,'frames',len(review),'review samples')
write(ROOT/'R3_CAPTION_SYNC.json',{'authority':'OWNER_CAPTION_MALE_2026-10-07.md','status':'MEASURED','fps':60,'locales':locales})
write(V/'VOICE_TIMING.json',{'real_voice_source':True,'english_source_unchanged':True,'all_chinese_regenerated':True,'no_chinese_time_compression':True,'cues':all_cues,'subjective_listening':'NOT_RUN'})
write(V/'VOICE_ASR.json',{'engine':'Independent offline Whisper large-v3; English accepted recognition reused','cues':all_asr,'subjective_listening':'NOT_RUN'})
accepted=hashlib.sha256((ROOT/'assets/sound/r3-opening-mix-en.wav').read_bytes()).hexdigest()
assert accepted=='2811129e7557e7034f534f27a50b1822f20eb0786b408294818ee3a3d26a7f8b'
write(V/'CAPTION_SYNC_PROOF.json',{'status':'MEASURED_SOURCE_TIMINGS','english_accepted_mix_sha256':accepted,'captions':{l:c['captions'] for l,c in locales.items()},'not_full_transcript':True,'no_forced_duration':True})
