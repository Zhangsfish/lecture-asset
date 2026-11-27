"""Remove only an unused framework copied beside an already statically linked App.

No source, executable, model, notice or arbitrary bundle resource is rewritten.
All guards must pass before removing this exact ephemeral archive path.
"""
from pathlib import Path
import hashlib
import json
import os
import plistlib
import re
import shutil
import subprocess
import sys

sys.path.insert(0, str(Path.cwd() / 'scripts'))
from verify_release_bundle import validate_resources

app = Path(sys.argv[1]).resolve(strict=True)
temporary = Path(os.environ['RUNNER_TEMP']).resolve(strict=True)
if not app.is_relative_to(temporary) or app.name != 'eBOOK.app':
    raise ValueError('Not the ephemeral eBOOK archive')
info = plistlib.loads((app / 'Info.plist').read_bytes())
if info.get('CFBundleIdentifier') != 'com.zhangsfish.ebook':
    raise ValueError('Wrong archived product')
validate_resources(app)
framework = app / 'Frameworks/onnxruntime.framework'
if not framework.exists():
    print('EBOOK_ARCHIVE_NO_UNUSED_ONNX_FRAMEWORK')
    sys.exit(0)
if framework.is_symlink() or not framework.resolve(strict=True).is_relative_to(app):
    raise ValueError('Unexpected framework location')
framework_info = plistlib.loads((framework / 'Info.plist').read_bytes())
if framework_info.get('CFBundleIdentifier') != 'com.microsoft.onnxruntime' or framework_info.get('CFBundleExecutable') != 'onnxruntime':
    raise ValueError('Unexpected embedded framework')
allowed = {'Info.plist', 'onnxruntime', '_CodeSignature/CodeResources'}
files = [path for path in framework.rglob('*') if path.is_file()]
if any(path.is_symlink() for path in framework.rglob('*')) or {path.relative_to(framework).as_posix() for path in files} - allowed:
    print('EBOOK_ARCHIVE_FRAMEWORK_HAS_UNVERIFIED_RESOURCES_NO_REMOVAL')
    sys.exit(2)
executable = app / 'eBOOK'
dependencies = subprocess.run(['otool', '-L', str(executable)], capture_output=True, text=True)
symbols = subprocess.run(['nm', '-g', str(executable)], capture_output=True, text=True)
if dependencies.returncode or symbols.returncode:
    raise ValueError('Unable to inspect linked App')
code_items = [executable] + sorted(app.glob('*.dylib'))
for code_item in code_items:
    linkage = subprocess.run(['otool', '-L', str(code_item)], capture_output=True, text=True)
    if linkage.returncode or any('onnxruntime' in line.lower() for line in linkage.stdout.splitlines()[1:]):
        raise ValueError('App has an ONNX dynamic dependency or unreadable linkage')
static_proof = 'SYMBOL_TABLE' if re.search(r'(?m)^\s*[0-9a-fA-F]+\s+[Tt]\s+_OrtGetApiBase\s*$', symbols.stdout) else None
link_map = Path(os.environ['EBOOK_RELEASE_LINK_MAP'])
if not static_proof and link_map.is_file():
    mapping = link_map.read_text(errors='replace')
    objects = dict(re.findall(r'(?m)^\[\s*(\d+)\]\s+(.+)$', mapping))
    active = mapping.split('# Symbols:', 1)[-1].split('# Dead Stripped Symbols:', 1)[0]
    for address, index in re.findall(r'(?m)^0x([0-9A-Fa-f]+)\s+0x[0-9A-Fa-f]+\s+\[\s*(\d+)\]\s+_OrtGetApiBase\s*$', active):
        origin = objects.get(index, '')
        if int(address, 16) and re.search(r'onnxruntime\.framework/onnxruntime.*\([^)]*\.o\)', origin):
            static_proof = 'ACTIVE_STATIC_ARCHIVE_LINK_MAP'
if not static_proof:
    print('EBOOK_ARCHIVE_STATIC_ONNX_SYMBOL_NOT_PROVEN_NO_REMOVAL')
    sys.exit(2)
before = hashlib.sha256(executable.read_bytes()).hexdigest()
if before != 'f35c58465cc729b41aec172c0a536a7eb7e7be23dd4a84292114cdd6b07ca934':
    raise ValueError('Link-map generation changed the previously measured executable')
removed_sha = hashlib.sha256((framework / 'onnxruntime').read_bytes()).hexdigest()
removed_bytes = sum(path.stat().st_size for path in files)
# Exact resolved path was checked above; this is a newly built runner-only archive.
shutil.rmtree(framework)
after = hashlib.sha256(executable.read_bytes()).hexdigest()
if before != after:
    raise ValueError('App executable changed')
resources = validate_resources(app)
print('EBOOK_ARCHIVE_PACKAGING_ADJUSTMENT ' + json.dumps({
    'action': 'REMOVE_UNUSED_EMBEDDED_ONNX_FRAMEWORK',
    'app_executable_sha256': after, 'app_executable_unchanged': True,
    'static_OrtGetApiBase_defined': True, 'dynamic_onnx_dependency': False,
    'static_link_proof': static_proof,
    'removed_framework_binary_sha256': removed_sha, 'removed_bytes': removed_bytes,
    'app_bytes_after': sum(path.stat().st_size for path in app.rglob('*') if path.is_file()),
    **resources,
}, sort_keys=True))
