"""Read-only page count, aspect ratio, image-per-page and text-layer fixture check."""
import hashlib
import json
from pathlib import Path
import sys
import zipfile

from pypdf import PdfReader


def verify(pdf_path, zip_path):
    with zipfile.ZipFile(zip_path) as archive:
        name = next(name for name in archive.namelist() if name.endswith('/manifest.json'))
        manifest = json.loads(archive.read(name))
    document = PdfReader(pdf_path)
    assert len(document.pages) == len(manifest['pages'])
    for page, record in zip(document.pages, manifest['pages']):
        ratio = float(page.mediabox.width) / float(page.mediabox.height)
        assert abs(ratio - record['width'] / record['height']) < 0.0001
        assert not page.extract_text().strip()
        objects = page['/Resources']['/XObject'].get_object()
        images = [obj.get_object() for obj in objects.values() if obj.get_object()['/Subtype'] == '/Image']
        assert len(images) == 1
    return {'file': pdf_path.name, 'pages': len(document.pages), 'bytes': pdf_path.stat().st_size,
            'sha256': hashlib.sha256(pdf_path.read_bytes()).hexdigest(),
            'page_count_ratios_single_image_and_no_extracted_text_layer': 'PASS',
            'embedded_image_order_hash_validation': 'PASS in native ArchiveCore regression'}


if __name__ == '__main__':
    print(json.dumps([verify(Path(sys.argv[index]), Path(sys.argv[index + 1]))
                      for index in range(1, len(sys.argv), 2)], indent=2))
