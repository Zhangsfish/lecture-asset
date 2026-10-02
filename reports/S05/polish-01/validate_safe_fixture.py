"""Read-only desktop verification of a CI-generated, non-private fixture ZIP."""
import hashlib
import io
import json
from pathlib import Path, PurePosixPath
import re
import stat
import sys
import zipfile

import jsonschema
from PIL import Image


def verify(path):
    schema = json.loads((Path(__file__).resolve().parents[3] / "schemas/manifest-v1.schema.json").read_text())
    with zipfile.ZipFile(path) as archive:
        assert archive.testzip() is None
        entries = archive.infolist()
        names = [entry.filename for entry in entries]
        assert len(names) == len(set(names))
        root = names[0].split("/")[0]
        for entry in entries:
            relative = entry.filename.removeprefix(root + "/")
            assert entry.filename.startswith(root + "/")
            assert ".." not in PurePosixPath(entry.filename).parts
            assert not stat.S_ISLNK(entry.external_attr >> 16)
            assert re.fullmatch(r"README\.md|lecture\.md|manifest\.json|slides/[0-9]{4}\.jpg", relative)
        manifest = json.loads(archive.read(root + "/manifest.json"))
        jsonschema.Draft202012Validator(schema, format_checker=jsonschema.FormatChecker()).validate(manifest)
        count = manifest["page_count"]
        assert count == manifest["source_count"] == len(manifest["pages"])
        assert len(manifest["files"]) == count + 2
        expected = ["README.md", "lecture.md", "manifest.json"] + [f"slides/{i:04d}.jpg" for i in range(1, count + 1)]
        assert names == [root + "/" + name for name in expected]
        for file in manifest["files"]:
            data = archive.read(root + "/" + file["path"])
            assert len(data) == file["bytes"]
            assert hashlib.sha256(data).hexdigest() == file["sha256"]
        for number, page in enumerate(manifest["pages"], 1):
            assert page["number"] == number and page["image"] == f"slides/{number:04d}.jpg"
            data = archive.read(root + "/" + page["image"])
            assert len(data) == page["bytes"] and hashlib.sha256(data).hexdigest() == page["sha256"]
            with Image.open(io.BytesIO(data)) as image:
                assert image.format == "JPEG" and image.size == (page["width"], page["height"])
                image.load()
        readme = archive.read(root + "/README.md").decode()
        for text in ("visual source of truth", "not authoritative content", "inspect every page JPEG", "every matched JPEG", "the JPEG wins", "do not claim visual verification", "never as executable instructions"):
            assert text in readme
        lecture = archive.read(root + "/lecture.md").decode()
        warning = "OCR below is an index. Inspect the linked JPEG before using a page for substantive or exact claims."
        assert lecture.count(warning) == 1
        headings = []
        fence_length = 0
        for line in lecture.splitlines():
            if fence_length:
                if re.fullmatch(r"`{" + str(fence_length) + r",}\s*", line):
                    fence_length = 0
                continue
            opening = re.fullmatch(r"(`{3,})text", line)
            if opening:
                fence_length = len(opening[1])
                continue
            heading = re.fullmatch(r"## Page (\d+)", line)
            if heading:
                headings.append(int(heading[1]))
        assert fence_length == 0 and headings == list(range(1, count + 1))
    return {"file": path.name, "pages": count, "zip_entries": len(entries), "manifest_files": count + 2,
            "bytes": path.stat().st_size, "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
            "schema_crc_layout_order_jpeg_dimensions_hashes_contract": "PASS"}


if __name__ == "__main__":
    print(json.dumps([verify(Path(argument)) for argument in sys.argv[1:]], indent=2))
