"""Owner-requested illustrative system layers, not captured iOS/provider UI."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import math

NAMES = ['ChatGPT', 'Gemini', 'Claude', 'WorkBuddy']

def apply_overlay(base, kind, root, font_dir='C:/Windows/Fonts'):
    scale = 2
    w, h = base.size
    layer = Image.new('RGBA', (w*scale, h*scale))
    d = ImageDraw.Draw(layer)
    def box(bounds, radius=0, fill='#252527'):
        d.rounded_rectangle(tuple(round(v*scale) for v in bounds), radius*scale, fill=fill)
    def line(points, fill='#48484A', width=1):
        d.line([(int(x*scale),int(y*scale)) for x,y in points], fill=fill, width=width*scale)
    def label(value, x, y, size=25, color='white', bold=False, centered=False):
        f = ImageFont.truetype(str(Path(font_dir)/('segoeuib.ttf' if bold else 'segoeui.ttf')),size*scale)
        if centered: x -= d.textlength(value,font=f)/scale/2
        d.text((round(x*scale),round(y*scale)),value,font=f,fill=color)
    if kind == 'share':
        top = 790
        box((0,top,w,h+30),38)
        box((w/2-34,top+13,w/2+34,top+19),3,'#717173')
        box((29,top+48,97,top+132),10,'#E4E4E7')
        for k in range(5): box((58+(k%2)*7,top+61+k*9,65+(k%2)*7,top+66+k*9),0,'#929297')
        label('ZIP',63,top+107,15,'#77777B',centered=True)
        label('Lecture_2026-10-04_',119,top+49,27,bold=True)
        label('AI_ZIP.zip',119,top+85,27,bold=True)
        label('ZIP Archive',119,top+124,23,'#AAAAB0')
        box((w-77,top+51,w-29,top+99),24,'#3E3E40')
        line([(w-62,top+66),(w-44,top+84)],'#B8B8BE',3)
        line([(w-44,top+66),(w-62,top+84)],'#B8B8BE',3)
        line([(27,top+174),(w-27,top+174)])
        for i,name in enumerate(NAMES):
            x=30+i*175
            icon_path=root/'illustrative-assets'/f'{name.lower()}.png'
            icon=Image.open(icon_path).convert('RGBA').resize((100*scale,100*scale),Image.Resampling.LANCZOS)
            mask=Image.new('L',icon.size)
            ImageDraw.Draw(mask).rounded_rectangle((0,0,199,199),44,fill=255)
            icon.putalpha(mask)
            layer.alpha_composite(icon,((x+20)*scale,(top+208)*scale))
            label(name,x+70,top+323,23,centered=True)
        line([(27,top+375),(w-27,top+375)])
        for i,name in enumerate(['AirDrop','Messages','Mail','Save to Files']):
            x=30+i*175; cx=x+70; cy=top+453
            box((cx-46,cy-46,cx+46,cy+46),24,['#347AF6','#35B759','#347AF6','#454548'][i])
            if i==0:
                for r in [12,25,36]: d.ellipse(tuple(int(v*scale) for v in (cx-r,cy-r,cx+r,cy+r)),outline='white',width=2*scale)
            elif i==1:
                box((cx-29,cy-22,cx+29,cy+20),16,'white')
                d.polygon([(int(vx*scale),int(vy*scale)) for vx,vy in [(cx-19,cy+12),(cx-24,cy+31),(cx,cy+17)]],fill='white')
            elif i==2:
                box((cx-30,cy-21,cx+30,cy+21),4,'white')
                line([(cx-29,cy-19),(cx,cy+4),(cx+29,cy-19)],'#347AF6',2)
            else:
                line([(cx-29,cy-20),(cx-10,cy-20),(cx-2,cy-11),(cx+29,cy-11),(cx+29,cy+25),(cx-29,cy+25),(cx-29,cy-20)],'white',3)
            label(name,cx,top+514,22,centered=True)
        box((25,top+573,w-25,top+653),18,'#38383B')
        label('Share destination examples',w/2,top+596,25,centered=True)
        label('Availability depends on installed apps.',w/2,top+684,21,'#A6A6AD',centered=True)
    elif kind == 'delete':
        box((0,0,w,h),0,(0,0,0,95))
        left,right,top,bottom=64,w-64,460,1125
        box((left,top,right,bottom),30,'#29292C')
        label('Allow "Lecture Asset" to',w/2,top+32,29,bold=True,centered=True)
        label('delete this photo?',w/2,top+72,29,bold=True,centered=True)
        for j,t in enumerate(['This photo will be deleted from iCloud','Photos on all your devices. It will be in','Recently Deleted for 30 days.']):
            label(t,w/2,top+129+j*33,24,'#E3E3E8',centered=True)
        preview=Image.open(root/'fixtures/lecture-13.jpg').convert('RGB')
        preview.thumbnail((462*scale,260*scale),Image.Resampling.LANCZOS)
        px=(w*scale-preview.width)//2; py=(top+259)*scale
        layer.paste(preview,(px,py))
        label('System confirmation example',w/2,top+548,20,'#B3B3BA',centered=True)
        line([(left,top+597),(right,top+597)])
        line([(w/2,top+597),(w/2,bottom)])
        label("Don't Allow",(left+w/2)/2,top+617,27,'#71AFFF',centered=True)
        label('Delete',(w/2+right)/2,top+617,27,'#FF6969',centered=True)
    else:
        raise ValueError(kind)
    layer=layer.resize(base.size,Image.Resampling.LANCZOS)
    return Image.alpha_composite(base.convert('RGBA'),layer).convert('RGB'),layer.getchannel('A')
