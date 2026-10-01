"""Read-only, content-redacted 200-page AI ZIP validator.

Usage: python validate_desktop_zip.py PRIVATE_ZIP_PATH
Only aggregate checks and a safe failure category are printed. No extraction occurs.
"""

import hashlib
import io
import json
import re
import sys
import zipfile
from datetime import datetime
from pathlib import Path

import jsonschema
from PIL import Image


def digest(data):
    return hashlib.sha256(data).hexdigest()


def load_bytes(archive, name):
    with archive.open(name) as source:
        return source.read()


def validate(path):
    schema_path = Path(__file__).resolve().parents[3] / "schemas" / "manifest-v1.schema.json"
    schema = json.loads(schema_path.read_text(encoding="utf-8"))
    zip_hash = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            zip_hash.update(chunk)

    with zipfile.ZipFile(path) as archive:
        entries = archive.infolist()
        names = [entry.filename for entry in entries]
        assert len(names) == len(set(names)), "duplicate_zip_entry"
        assert not any((entry.external_attr >> 16) & 0o170000 == 0o120000 for entry in entries), "symlink"
        files = [name for name in names if not name.endswith("/")]
        roots = {name.split("/", 1)[0] for name in files}
        assert len(roots) == 1, "multiple_roots"
        root = roots.pop()
        assert re.fullmatch(r"Lecture_[^/]+", root), "invalid_root"
        expected_rel = {"README.md", "lecture.md", "manifest.json"}
        expected_rel.update(f"slides/{number:04d}.jpg" for number in range(1, 201))
        assert set(files) == {f"{root}/{name}" for name in expected_rel}, "path_whitelist_or_count"
        assert all(not name.startswith("/") and ".." not in name.split("/") for name in names), "unsafe_path"

        manifest = json.loads(load_bytes(archive, f"{root}/manifest.json"))
        jsonschema.Draft202012Validator(schema, format_checker=jsonschema.FormatChecker()).validate(manifest)
        assert manifest["source_count"] == manifest["page_count"] == len(manifest["pages"]) == 200, "manifest_count"
        pages = manifest["pages"]
        assert [page["number"] for page in pages] == list(range(1, 201)), "page_numbers"
        assert [page["image"] for page in pages] == [f"slides/{number:04d}.jpg" for number in range(1, 201)], "image_order"
        assert len({page["selection_index"] for page in pages}) == 200, "selection_duplicate"

        def sort_key(page):
            captured = page["captured_at"]
            return (captured is None, datetime.fromisoformat(captured.replace("Z", "+00:00")) if captured else datetime.max.replace(tzinfo=datetime.now().astimezone().tzinfo), page["selection_index"])

        assert pages == sorted(pages, key=sort_key), "chronological_order"
        listed = manifest["files"]
        assert len(listed) == 202 and len({item["path"] for item in listed}) == 202, "manifest_file_count"
        assert {item["path"] for item in listed} == expected_rel - {"manifest.json"}, "manifest_file_set"
        file_records = {item["path"]: item for item in listed}
        jpeg_bytes = 0
        for rel in sorted(file_records):
            blob = load_bytes(archive, f"{root}/{rel}")
            record = file_records[rel]
            assert len(blob) == record["bytes"] and digest(blob) == record["sha256"], "file_integrity"
            if rel.startswith("slides/"):
                jpeg_bytes += len(blob)
                page = pages[int(rel[-8:-4]) - 1]
                assert len(blob) == page["bytes"] and digest(blob) == page["sha256"], "page_integrity"
                with Image.open(io.BytesIO(blob)) as image:
                    assert image.format == "JPEG" and image.size == (page["width"], page["height"]), "jpeg_dimensions"
                    image.verify()

        lecture = load_bytes(archive, f"{root}/lecture.md").decode("utf-8")
        blocks = [int(number) for number in re.findall(r"(?m)^## Page (\d{4})\s*$", lecture)]
        links = [int(number) for number in re.findall(r"\]\(slides/(\d{4})\.jpg\)", lecture)]
        assert blocks == links == list(range(1, 201)), "markdown_order"
        return {
            "status": "PASS",
            "zip_bytes": path.stat().st_size,
            "zip_sha256": zip_hash.hexdigest(),
            "jpeg_count": 200,
            "manifest_pages": 200,
            "markdown_pages": 200,
            "jpeg_total_bytes": jpeg_bytes,
            "schema": "PASS",
            "chronological_order": "PASS",
            "zip_crc_and_hashes": "PASS",
            "pdf_in_zip": False,
            "private_files_in_zip": False,
        }


if __name__ == "__main__":
    try:
        assert len(sys.argv) == 2, "usage"
        print(json.dumps(validate(Path(sys.argv[1])), sort_keys=True))
    except Exception as error:
        # Keep private file names, manifest data, OCR text and path out of logs.
        category = error.args[0] if isinstance(error, AssertionError) and error.args else type(error).__name__
        print(json.dumps({"status": "FAIL", "category": str(category)}))
        sys.exit(1)
