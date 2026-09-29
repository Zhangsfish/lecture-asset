"""Independent JSON Schema and ZIP integrity check of public synthetic evidence."""
import hashlib
import json
from pathlib import Path
import sys
import zipfile

from jsonschema import Draft202012Validator, FormatChecker

archive_path = Path(sys.argv[1])
schema = json.loads(Path("schemas/manifest-v1.schema.json").read_text(encoding="utf-8"))
Draft202012Validator.check_schema(schema)
with zipfile.ZipFile(archive_path) as archive:
    names = archive.namelist()
    assert len(names) == 23 and len(names) == len(set(names))
    assert archive.testzip() is None, "CRC failure"
    root = names[0].split("/", 1)[0]
    assert names == [f"{root}/README.md", f"{root}/lecture.md", f"{root}/manifest.json"] + [
        f"{root}/slides/{index:04d}.jpg" for index in range(1, 21)
    ]
    assert all(not info.is_dir() and not (info.external_attr >> 16) & 0o170000 == 0o120000
               for info in archive.infolist())
    manifest = json.loads(archive.read(f"{root}/manifest.json"))
    Draft202012Validator(schema, format_checker=FormatChecker()).validate(manifest)
    assert manifest["source_count"] == manifest["page_count"] == len(manifest["pages"]) == 20
    assert manifest["pages"][0]["ocr"]["status"] == "failed"
    assert manifest["pages"][1]["ocr"]["status"] == "empty"
    assert [entry["path"] for entry in manifest["files"]] == ["README.md", "lecture.md"] + [
        f"slides/{index:04d}.jpg" for index in range(1, 21)
    ]
    for file_record in manifest["files"]:
        contents = archive.read(f"{root}/{file_record['path']}")
        assert len(contents) == file_record["bytes"]
        assert hashlib.sha256(contents).hexdigest() == file_record["sha256"]
    markdown = archive.read(f"{root}/lecture.md").decode("utf-8")
    for index in range(1, 21):
        assert markdown.count(f"![Page {index:04d}](slides/{index:04d}.jpg)") == 1
    assert not any(name.lower().endswith((".pdf", ".mov", ".heic", ".jsonl")) for name in names)
print("S02_SYNTHETIC_SCHEMA_ZIP_HASH_CRC_PASS pages=20")
