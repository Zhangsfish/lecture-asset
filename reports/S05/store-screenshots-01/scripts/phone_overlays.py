"""Owner-requested illustrative system layers; all destinations are generic."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
NAMES = ['AI', 'My Computer', 'Chat', 'Friends']
DELETE_TITLE = 'Allow “Lecture Asset” to delete 12 photos?'
DELETE_BODY = 'These photos will be deleted from iCloud Photos on all your devices. They’ll remain in Recently Deleted for 30 days.'

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
            x=30+i*175; cx=x+70; cy=top+258
            box((cx-50,cy-50,cx+50,cy+50),22,'#454A52')
            if i==0:
                def sparkle(sx,sy,r):
                    points=[(sx,sy-r),(sx+r*.28,sy-r*.28),(sx+r,sy),
                            (sx+r*.28,sy+r*.28),(sx,sy+r),
                            (sx-r*.28,sy+r*.28),(sx-r,sy),(sx-r*.28,sy-r*.28)]
                    d.polygon([(round(a*scale),round(b*scale)) for a,b in points],fill='white')
                sparkle(cx-6,cy+4,29)
                sparkle(cx+26,cy-25,10)
                sparkle(cx+29,cy+26,7)
            elif i==1:
                line([(cx-29,cy+14),(cx-29,cy-23),(cx+29,cy-23),
                      (cx+29,cy+14),(cx-29,cy+14)],'white',3)
                line([(cx-29,cy+14),(cx-38,cy+24),(cx+38,cy+24),
                      (cx+29,cy+14)],'white',3)
            elif i==2:
                # Two offset outlined bubbles, no platform-specific mark.
                for ox,oy in [(10,-10),(-12,12)]:
                    bounds=(cx+ox-25,cy+oy-18,cx+ox+25,cy+oy+14)
                    d.rounded_rectangle(tuple(round(v*scale) for v in bounds),9*scale,
                                        fill='#454A52',outline='white',width=3*scale)
                    line([(cx+ox-16,cy+oy+14),(cx+ox-21,cy+oy+23),
                          (cx+ox-4,cy+oy+14)],'white',3)
            else:
                for ox in [-20,20]:
                    d.ellipse(tuple(round(v*scale) for v in
                              (cx+ox-10,cy-27,cx+ox+10,cy-7)),fill='white')
                    box((cx+ox-17,cy+1,cx+ox+17,cy+26),13,'white')
            label(name,x+70,top+323,23,centered=True)
        line([(27,top+375),(w-27,top+375)])
        box((25,top+573,w-25,top+653),18,'#38383B')
        label('Share destination examples',w/2,top+596,25,centered=True)
        label('Availability depends on installed apps.',w/2,top+684,21,'#A6A6AD',centered=True)
    elif kind == 'delete':
        box((0,0,w,h),0,(0,0,0,95))
        left,right,top,bottom=64,w-64,460,1125
        box((left,top,right,bottom),30,'#29292C')
        title_lines=['Allow “Lecture Asset” to','delete 12 photos?']
        body_lines=['These photos will be deleted from iCloud',
                    'Photos on all your devices. They’ll remain',
                    'in Recently Deleted for 30 days.']
        assert ' '.join(title_lines)==DELETE_TITLE
        assert ' '.join(body_lines)==DELETE_BODY
        label(title_lines[0],w/2,top+32,29,bold=True,centered=True)
        label(title_lines[1],w/2,top+72,29,bold=True,centered=True)
        for j,t in enumerate(body_lines):
            label(t,w/2,top+129+j*33,24,'#E3E3E8',centered=True)
        preview=Image.open(root/'fixtures/lecture-13.jpg').convert('RGB')
        preview.thumbnail((462*scale,260*scale),Image.Resampling.LANCZOS)
        px=(w*scale-preview.width)//2; py=(top+259)*scale
        layer.paste(preview,(px,py))
        line([(left,top+597),(right,top+597)])
        line([(w/2,top+597),(w/2,bottom)])
        label("Don't Allow",(left+w/2)/2,top+617,27,'#71AFFF',centered=True)
        label('Delete',(w/2+right)/2,top+617,27,'#FF6969',centered=True)
    else:
        raise ValueError(kind)
    layer=layer.resize(base.size,Image.Resampling.LANCZOS)
    return Image.alpha_composite(base.convert('RGBA'),layer).convert('RGB'),layer.getchannel('A')
