"""Six static Store compositions. Real captures are only uniformly scaled/clipped.

Real App base unchanged. Frames 5/6 add explicitly illustrative system layers.
Run on Windows with installed Pillow/numpy and Microsoft YaHei fonts.
English renderer and final outputs are never invoked or overwritten.
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import argparse
import hashlib
import json
import numpy as np
from phone_overlays_zh_hans import apply_overlay, NAMES, DELETE_TITLE, DELETE_BODY

ROOT = Path(__file__).resolve().parents[1]
P = argparse.ArgumentParser()
P.add_argument('--font-dir', default='C:/Windows/Fonts')
P.add_argument('--icc', default='C:/Windows/System32/spool/drivers/color/sRGB Color Space Profile.icm')
A = P.parse_args()
ICC = Path(A.icc).read_bytes()
W, H = 1320, 2868
HEADLINE_SIZE, HEADLINE_LINE_HEIGHT = 84, 126
HEADLINE_ORIGIN = (108, 222)
PHONE_WIDTH, PHONE_Y = 748, 1240
SUBTITLE_SIZE, SUBTITLE_COLOR = 42, '#5D6B7A'
BLUE, INK, MUTED, MINT = '#4772A8', '#203247', '#6C7A89', '#4B907C'

STORY = [
    ('01-lecture-photos', 'selection', ['一场讲座。', '几十张 PPT 照片。'], '很少再翻，又舍不得删。', ''),
    ('02-select-and-sort', 'review', ['批量选好。', '按拍摄时间排好。'], '长按并滑动，连续选择。', ''),
    ('03-generate-pdf-zip', 'ready', ['一次生成', 'AI ZIP 和 PDF。'], '', ''),
    ('04-pdf-for-review', 'pdf', ['PDF 留着。', '以后随时回看。'], '', ''),
    ('05-ai-zip-to-ai', 'ready', ['把 AI ZIP 交给 AI。', '继续理解这场讲座。'], '', ''),
    ('06-save-then-clean', 'ready', ['先保存。', '再决定清理什么。'], '', ''),
]

def font(size, bold=False):
    return ImageFont.truetype(str(Path(A.font_dir)/('msyhbd.ttc' if bold else 'msyh.ttc')), size)

TEXT_BOUNDS = []
def text(im, xy, value, size=32, fill=INK, bold=False):
    d = ImageDraw.Draw(im)
    bounds = d.textbbox(xy, value, font=font(size, bold))
    assert 0 <= bounds[0] <= bounds[2] <= W and 0 <= bounds[1] <= bounds[3] <= H, (value, bounds)
    TEXT_BOUNDS.append({'text':value, 'size':size, 'bounds':list(bounds)})
    d.text(xy, value, font=font(size, bold), fill=fill)

def panel(im, box, radius=28, color='white', shadow=28):
    layer = Image.new('RGBA', im.size)
    d = ImageDraw.Draw(layer)
    shifted = (box[0], box[1]+12, box[2], box[3]+12)
    d.rounded_rectangle(shifted, radius, fill=(30, 52, 74, shadow))
    im.alpha_composite(layer.filter(ImageFilter.GaussianBlur(22)))
    ImageDraw.Draw(im).rounded_rectangle(box, radius, fill=color)

def check(im, x, y, size=44, color=BLUE):
    d = ImageDraw.Draw(im)
    d.ellipse((x,y,x+size,y+size),fill=color)
    d.line([(x+size*.26,y+size*.52),(x+size*.43,y+size*.69),(x+size*.75,y+size*.34)],
           fill='white',width=max(3,int(size*.075)),joint='curve')

def arrow(im, points, color='#AABFD5', width=7):
    d = ImageDraw.Draw(im)
    d.line(points, fill=color,width=width,joint='curve')
    x,y = points[-1]
    d.line([(x-12,y-16),(x,y),(x+12,y-16)],fill=color,width=width,joint='curve')

def slide_card(im, number, x, y, width=405, angle=0, selected=False):
    raw = Image.open(ROOT/'fixtures'/f'lecture-{number:02d}.jpg').convert('RGB')
    h = round(width*raw.height/raw.width)
    card = Image.new('RGBA',(width+36,h+36))
    ImageDraw.Draw(card).rounded_rectangle((0,0,width+36,h+36),22,fill='white')
    card.paste(raw.resize((width,h),Image.Resampling.LANCZOS),(18,18))
    if selected:
        ImageDraw.Draw(card).rounded_rectangle((2,2,width+33,h+33),22,outline=BLUE,width=4)
        check(card,width-28,8,42)
    card = card.rotate(angle, resample=Image.Resampling.BICUBIC, expand=True)
    # Blur on the full canvas so the shadow does not clip to a hard rectangle.
    shadow = Image.new('RGBA',im.size)
    tint = Image.new('RGBA',card.size,(32,50,71,0))
    tint.putalpha(card.getchannel('A').point(lambda v: round(v*.11)))
    shadow.alpha_composite(tint,(x,y+16))
    im.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(18)))
    im.alpha_composite(card,(x,y))

def file_card(im, x, y, label, color, width=245, height=310):
    panel(im,(x,y,x+width,y+height),32)
    d = ImageDraw.Draw(im)
    d.rounded_rectangle((x+26,y+25,x+width-26,y+height-80),18,fill='#F2F6FA')
    # Fold and paper, matching the tutorial's flat file-card language.
    px, py = x+width//2-51, y+50
    d.polygon([(px,py),(px+76,py),(px+102,py+26),(px+102,py+135),(px,py+135)], fill='white')
    d.line([(px+76,py),(px+76,py+26),(px+102,py+26)], fill='#C4D2E0',width=3)
    if 'ZIP' in label:
        for yy in range(py+25,py+106,13):
            d.rectangle((px+43,yy,px+53,yy+7), fill=color)
        d.rounded_rectangle((px+39,py+107,px+58,py+125),4,outline=color,width=3)
    else:
        for j in range(4): d.rounded_rectangle((px+20,py+35+j*19,px+80-j*7,py+40+j*19),2,fill=color)
    f = font(37,True)
    tw = d.textlength(label,font=f)
    d.text((x+(width-tw)/2,y+height-65),label,font=f,fill=color)

def phone(im, capture, y=PHONE_Y, width=PHONE_WIDTH):
    raw = Image.open(ROOT/'captures'/'zh-Hans'/f'store-zh-hans-{capture}.png').convert('RGB')
    assert raw.size == (1320,2868)
    frame_scale = width/748
    border = round(14*frame_scale)
    corner = round(83*frame_scale)
    sw = width-2*border
    sh = round(sw*raw.height/raw.width)
    height = sh+2*border
    x = (W-width)//2
    panel(im,(x,y,x+width,y+height),radius=round(98*frame_scale),color='#20252B',shadow=55)
    screen = raw.resize((sw,sh),Image.Resampling.LANCZOS).convert('RGBA')
    mask = Image.new('L',screen.size)
    ImageDraw.Draw(mask).rounded_rectangle((0,0,sw,sh),radius=corner,fill=255)
    screen.putalpha(mask)
    im.alpha_composite(screen,(x+border,y+border))
    # No replacement status bar, synthesized controls or fictional app screen.
    return {'raw':f'store-zh-hans-{capture}.png','screen_rect':[x+border,y+border,sw,sh],
            'phone_rect':[x,y,width,height],
            'screen_corner_radius':corner,
            'phone_bottom_cropped':y+height>H,
            'transform':'uniform LANCZOS resize; rounded corner mask; canvas crop if out of bounds'}

def background():
    yy, xx = np.mgrid[0:H,0:W]
    arr = np.zeros((H,W,3),dtype=np.float32)+[250,251,252]
    for cx,cy,sigma,color,amount in [(-130,1500,600,[204,223,244],.72),
                                    (1430,1450,670,[216,237,228],.65)]:
        a = np.exp(-((xx-cx)**2+(yy-cy)**2)/(2*sigma*sigma))*amount
        arr = arr*(1-a[:,:,None])+np.array(color)*a[:,:,None]
    return Image.fromarray(np.uint8(np.clip(arr,0,255)),'RGB').convert('RGBA')

def header(im, index, lines, subtitle):
    icon = Image.open(Path('App/Assets.xcassets/AppIcon.appiconset/AppIcon.png')).convert('RGBA').resize((57,57),Image.Resampling.LANCZOS)
    mask = Image.new('L',(57,57)); ImageDraw.Draw(mask).rounded_rectangle((0,0,57,57),13,fill=255)
    icon.putalpha(mask); im.alpha_composite(icon,(112,98))
    text(im,(189,106),'Lecture Asset',29,fill=MUTED,bold=True)
    assert max(ImageDraw.Draw(im).textlength(line,font=font(HEADLINE_SIZE,True)) for line in lines)<=1096
    for n,line in enumerate(lines):
        text(im,(HEADLINE_ORIGIN[0],HEADLINE_ORIGIN[1]+n*HEADLINE_LINE_HEIGHT),line,
             HEADLINE_SIZE, BLUE if n==1 else INK,True)
    if subtitle: text(im,(113,518),subtitle,SUBTITLE_SIZE,fill=SUBTITLE_COLOR)

def render(index, item):
    name,capture,lines,sub,zh = item
    TEXT_BOUNDS.clear()
    im = background()
    header(im,index,lines,sub)
    if index==1:
        slide_card(im,20,170,735,465,angle=8)
        slide_card(im,22,638,746,435,angle=-7)
        slide_card(im,24,424,654,420,angle=2)
    elif index==2:
        slide_card(im,19,132,691,290,angle=7,selected=True)
        slide_card(im,20,491,691,290,angle=0,selected=True)
        slide_card(im,21,850,691,290,angle=-7,selected=True)
        d=ImageDraw.Draw(im)
        d.line([(260,973),(648,973),(1040,973)],fill='#90B0D1',width=5)
        d.ellipse((237,950,283,996),fill='white',outline=BLUE,width=4)
        d.ellipse((245,958,275,988),outline='#90B0D1',width=2)
        d.polygon([(1028,963),(1047,973),(1028,983)],fill='#90B0D1')
        d.line([(260,1024),(650,1024),(1040,1024)],fill=BLUE,width=5)
        for x,label in [(260,'09:18'),(650,'09:19'),(1040,'09:20')]:
            d.ellipse((x-9,1015,x+9,1033),fill=BLUE)
            text(im,(x-45,1050),label,28,fill=MUTED)
    elif index==3:
        slide_card(im,24,193,737,298,angle=5)
        slide_card(im,23,154,706,298,angle=-4)
        d=ImageDraw.Draw(im)
        d.line([(502,836),(611,836),(611,649),(1090,649),(1090,690)],fill='#AABFD5',width=6,joint='curve')
        d.line([(611,836),(668,836),(668,690),(804,690)],fill='#AABFD5',width=6,joint='curve')
        # A stack branches to two distinct outputs, never a native UI control.
        file_card(im,713,686,'PDF',MINT,215,307)
        file_card(im,980,717,'AI ZIP',BLUE,215,307)
    elif index==4:
        # A legible enlarged fictional slide, outside the real PDF viewer.
        slide_card(im,13,195,620,884,angle=0)
        panel(im,(804,1034,1119,1105),20)
        text(im,(833,1048),'PDF · 12 页',29,fill=MINT,bold=True)
    elif index==5:
        text(im,(466,646),'导出后 · AI 工具示例',SUBTITLE_SIZE,fill=SUBTITLE_COLOR)
        file_card(im,115,733,'AI ZIP',BLUE,228,310)
        d=ImageDraw.Draw(im)
        d.line((371,888,421,888),fill='#AABFD5',width=7)
        d.polygon([(414,875),(434,888),(414,901)],fill='#AABFD5')
        panel(im,(466,701,1205,1112),32)
        text(im,(505,737),'AI 工作区',41,bold=True)
        text(im,(1033,751),'示例',25,fill=MUTED)
        d.line((503,817,1169,817),fill='#E3E9F0',width=2)
        for j,(left,right) in enumerate([('总结','提问'),('学习笔记','讲座资料')]):
            for k,value in enumerate([left,right]):
                x,y=504+k*326,855+j*105
                d.rounded_rectangle((x,y,x+301,y+75),18,fill='#F3F7FB')
                text(im,(x+19,y+17),value,29,fill=BLUE,bold=True)
        text(im,(466,1150),'使用能读取图片的 AI 工具。',SUBTITLE_SIZE,fill=SUBTITLE_COLOR)
    elif index==6:
        panel(im,(402,668,918,774),28)
        check(im,436,696,47,MINT)
        text(im,(499,693),'确认 ZIP 已保存',33,bold=True)
        d=ImageDraw.Draw(im)
        d.line([(660,795),(660,828),(368,828),(368,862)],fill='#AABFD5',width=5)
        d.line([(660,828),(952,828),(952,862)],fill='#AABFD5',width=5)
        panel(im,(104,882,620,1024),24)
        panel(im,(700,882,1216,1024),24)
        text(im,(136,912),'删除源照片',33,bold=True)
        text(im,(732,900),'保留相册照片，',33,bold=True)
        text(im,(732,947),'清除 App 文件',33,bold=True)
        text(im,(126,1065),'删除源照片仍需单独确认。',SUBTITLE_SIZE,fill=SUBTITLE_COLOR)
    # Draw the native screen last: even a soft illustrative shadow may not
    # recolor screenshot pixels. Scene 4's bigger paper sits above the bezel.
    info = phone(im,capture)
    info['illustrative_overlay'] = None
    if index in (5,6):
        x,y,w,h = info['screen_rect']
        base = Image.open(ROOT/'captures'/'zh-Hans'/info['raw']).convert('RGB').resize((w,h),Image.Resampling.LANCZOS)
        kind = 'share' if index==5 else 'delete'
        composite, coverage = apply_overlay(base,kind,ROOT,A.font_dir)
        mask = Image.new('L',(w,h))
        ImageDraw.Draw(mask).rounded_rectangle((0,0,w,h),radius=info['screen_corner_radius'],fill=255)
        composite=composite.convert('RGBA'); composite.putalpha(mask)
        im.alpha_composite(composite,(x,y))
        info['illustrative_overlay']={'kind':kind,'actual_system_capture':False,
            'base_capture':info['raw'],'first_row':NAMES if index==5 else None,
            'filename':'Lecture_2026-10-04_AI_ZIP.zip' if index==5 else None,
            'preview':'fixtures/lecture-13.jpg' if index==6 else None,
            'delete_title':DELETE_TITLE if index==6 else None,
            'delete_body':DELETE_BODY if index==6 else None,
            'note':'Illustration only; generic destination categories, not installed apps.'}
    output=ROOT/'store'/'zh-Hans'/(name+'.png')
    output.parent.mkdir(parents=True,exist_ok=True)
    im.convert('RGB').save(output,icc_profile=ICC,optimize=True)
    info['external_text_bounds'] = list(TEXT_BOUNDS)
    info.update({'file':str(output.relative_to(ROOT)).replace('\\','/'),
                 'headline':' '.join(lines),'headline_lines':lines,'headline_zh_Hans':' '.join(lines),'subtitle':sub,
                 'headline_style':{'size':HEADLINE_SIZE,'line_height':HEADLINE_LINE_HEIGHT,'origin':list(HEADLINE_ORIGIN)},
                 'subtitle_style':{'size':SUBTITLE_SIZE,'color':SUBTITLE_COLOR,'origin':[113,518]},
                 'sha256':hashlib.sha256(output.read_bytes()).hexdigest(),
                 'pixels':[W,H],'mode':'RGB','icc_sha256':hashlib.sha256(ICC).hexdigest()})
    return info

results=[render(n,item) for n,item in enumerate(STORY,1)]
(ROOT/'RENDER_MANIFEST_ZH_HANS.json').write_text(json.dumps(results,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
# Contact sheet is a review aid, not an App Store asset.
thumbw=330; thumbh=717
sheet=Image.new('RGB',(3*thumbw,2*thumbh),'white')
for i,r in enumerate(results):
    raw=Image.open(ROOT/r['file']).resize((thumbw,thumbh),Image.Resampling.LANCZOS)
    sheet.paste(raw,((i%3)*thumbw,(i//3)*thumbh))
sheet.save(ROOT/'CONTACT_SHEET_ZH_HANS.png',icc_profile=ICC)
print('Rendered six Chinese RGB/sRGB Store PNGs and contact sheet.')
