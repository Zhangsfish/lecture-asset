"""Inspect only synthetic simulator output, never copy a private job or source ID to CI artifacts."""
import hashlib
import json
from pathlib import Path
import sys
import zipfile

root = Path(sys.argv[1])
states = list(root.glob("*/archive.json"))
assert len(states) == 1, "Expected one synthetic archive checkpoint"
state = json.loads(states[0].read_text())
assert state["phase"] == "ready", state.get("failure_code")
assert len(state["ocr_by_page"]) == 1
folder = states[0].parent / "exports"
zip_path = folder / state["zip_name"]
pdf_path = folder / state["pdf_name"]
assert zip_path.is_file() and pdf_path.is_file()
assert hashlib.sha256(zip_path.read_bytes()).hexdigest() == state["zip_sha256"]
assert hashlib.sha256(pdf_path.read_bytes()).hexdigest() == state["pdf_sha256"]
with zipfile.ZipFile(zip_path) as archive:
    assert archive.testzip() is None
    names = archive.namelist()
    assert len(names) == 4
    assert names[-1].endswith("/slides/0001.jpg")
    assert not any(name.endswith(".pdf") for name in names)
print("S02_SYNTHETIC_SIMULATOR_READY_PASS pages=1 zip_crc=pass pdf=present")
