"""Select only named synthetic UI attachments; do not publish xcresult paths/IDs."""
import hashlib
import json
from pathlib import Path
import shutil
import struct
import sys

source, dest = map(Path, sys.argv[1:3])
dest.mkdir(parents=True, exist_ok=True)
names = {'store-en-'+n for n in ['selection', 'review', 'prepared', 'ready', 'pdf', 'building', 'share', 'delete-confirmation']}
found = {}
def walk(node):
    if isinstance(node, list):
        for item in node: walk(item)
    elif isinstance(node, dict):
        # Xcode 26 manifest: suggestedHumanReadableName/exportedFileName.
        label = node.get('suggestedHumanReadableName', node.get('name', ''))
        for name in names:
            if label.startswith(name):
                file = node.get('exportedFileName', node.get('fileName', node.get('filename')))
                if file:
                    found[name] = source / file
        for value in node.values(): walk(value)
walk(json.loads((source / 'manifest.json').read_text()))
for extra in sys.argv[3:]:
    source = Path(extra)
    walk(json.loads((source / 'manifest.json').read_text()))
if set(found) != names:
    raise SystemExit('Missing named capture(s): '+str(sorted(names-set(found))))
records = []
for name in sorted(found):
    raw = found[name].read_bytes()
    assert raw[:8] == b'\x89PNG\r\n\x1a\n'
    width, height = struct.unpack('>II', raw[16:24])
    assert (width, height) == (1320, 2868), (width, height)
    shutil.copyfile(found[name], dest / (name+'.png'))
    records.append({'file':name+'.png', 'pixels':[width,height],
                    'sha256':hashlib.sha256(raw).hexdigest()})
(dest/'CAPTURES.json').write_text(json.dumps(records, indent=2)+'\n')
print('Exported synthetic real-UI captures:', len(records))
