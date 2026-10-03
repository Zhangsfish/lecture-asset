"""Focused release preparation checks; no private data or account mutation."""
from pathlib import Path
import argparse
import re
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--pages-only', action='store_true')
args = parser.parse_args()
for name, sibling in [('privacy', 'support'), ('support', 'privacy')]:
    html = Path(f'web/static/{name}.html').read_text(encoding='utf-8')
    assert 'zhangs.taq@gmail.com' in html
    assert 'https://zhang-shuo-portfolio.vercel.app/' in html
    assert f'href="{sibling}.html"' in html
    assert not re.search(r'<script\b|<iframe\b|<form\b', html, re.I)
    assert not re.search(r'TODO|placeholder|example\.com', html, re.I)
print('D0_PUBLIC_CONTENT_PASS')
if not args.pages_only:
    base = '43e669b59f3a6135d21286bdecaa0444104b0575'
    changed = subprocess.check_output(['git', 'diff', '--name-only', base, 'HEAD'], text=True).splitlines()
    assert not any(p.startswith(('App/', 'AppResources/', 'Packages/', 'schemas/')) or p == 'project.yml' for p in changed), changed
    print('D0_ACCEPTED_RUNTIME_UNCHANGED')
