"""Deterministic fictional slides. Requires existing Pillow; never reads Photos."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import hashlib
import json
import argparse

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument('--font-dir', default='C:/Windows/Fonts')
args = parser.parse_args()
font_dir = Path(args.font_dir)
def font(size, bold=False):
    return ImageFont.truetype(str(font_dir / ('segoeuib.ttf' if bold else 'segoeui.ttf')), size)

topics = ['Learning that lasts', 'Start with a question', 'Connect new ideas',
          'Practice retrieval', 'Space the practice', 'Explain it simply',
          'Compare two examples', 'Notice the differences', 'Sketch the idea',
          'Make room for feedback', 'Build a useful cue', 'Pause and reflect',
          'Test a small change', 'Find the missing link', 'Review the evidence',
          'Look for patterns', 'Ask a better question', 'Teach a partner',
          'Return to the hard part', 'Use a concrete example', 'Keep a study note',
          'Choose the next step', 'Bring the ideas together', 'Questions for discussion']
out = ROOT / 'fixtures'
out.mkdir(parents=True, exist_ok=True)
records = []
for i, title in enumerate(topics):
    image = Image.new('RGB', (1920, 1080), '#FAFBFD')
    d = ImageDraw.Draw(image)
    d.rectangle((0, 0, 1920, 18), fill='#4772A8')
    d.text((115, 85), 'LEARNING LAB  /  FICTIONAL LECTURE', font=font(26, True), fill='#657485')
    d.text((110, 160), title, font=font(81, True), fill='#203247')
    lines = ['Ask what the idea means.', 'Link it to a concrete example.', 'Return to it with a fresh question.']
    for j, line in enumerate(lines):
        y = 365 + j * 112
        d.ellipse((115, y+15, 135, y+35), fill='#4772A8')
        d.text((162, y-7), line, font=font(42), fill='#3C4B5C')
    # Simple fictional bar diagram, not a claim about research results.
    for j, h in enumerate([150, 235, 320]):
        x = 1190 + j * 180
        d.rounded_rectangle((x, 825-h, x+110, 825), radius=12,
                            fill=['#D8E4F2', '#9BB8D5', '#4772A8'][j])
        d.text((x+10, 855), ['A', 'B', 'C'][j], font=font(30), fill='#657485')
    d.line((1120, 825, 1790, 825), fill='#CBD4DF', width=3)
    d.text((115, 994), f'Synthetic demo only                                      {i+1:02d} / 24',
           font=font(27), fill='#7B8795')
    exif = Image.Exif()
    exif[36867] = f'2026:09:30 09:{i:02d}:00'
    exif[306] = exif[36867]
    exif[274] = 1
    target = out / f'lecture-{i+1:02d}.jpg'
    image.save(target, quality=94, subsampling=0, exif=exif)
    records.append({'file': target.name, 'sha256': hashlib.sha256(target.read_bytes()).hexdigest(),
                    'title': title, 'pixels': [1920, 1080], 'synthetic': True})
(out / 'SOURCES.json').write_text(json.dumps(records, indent=2)+'\n', encoding='utf-8')
print('Fictional slides:', len(records))
