"""Export frozen bilingual Store masters into the owner's medium-display slot.

Run from any directory with the existing Pillow environment. Never run a renderer.
"""
from __future__ import annotations

import hashlib
import io
import json
import platform
import subprocess
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile, ZipInfo

from PIL import Image, ImageCms, ImageDraw, ImageFont, __version__ as PILLOW_VERSION

TASK = Path(__file__).resolve().parents[1]
REPO = TASK.parents[2]
SOURCE = REPO / "reports/S05/store-screenshots-01"
BASE = "5483ed23a0a4502614ad4946ee94790763229997"
TARGET = (1206, 2622)
NAMES = (
    "01-lecture-photos.png", "02-select-and-sort.png",
    "03-generate-pdf-zip.png", "04-pdf-for-review.png",
    "05-ai-zip-to-ai.png", "06-save-then-clean.png",
)
LOCALES = ("en", "zh-Hans")


def git(*args: str) -> bytes:
    return subprocess.check_output(["git", *args], cwd=REPO)


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def frozen_inventory() -> dict[str, str]:
    """Check all historical task files through Git; pin image bytes independently."""
    git("diff", "--exit-code", BASE, "--", "reports/S05/store-screenshots-01")
    paths = [SOURCE / "store" / loc / name for loc in LOCALES for name in NAMES]
    paths += [SOURCE / "CONTACT_SHEET.png", SOURCE / "CONTACT_SHEET_ZH_HANS.png"]
    result = {}
    for path in paths:
        relative = path.relative_to(REPO).as_posix()
        actual = sha(path.read_bytes())
        assert actual == sha(git("show", BASE + ":" + relative)), relative
        result[relative] = actual
    return result


def json_write(path: Path, data: object) -> None:
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def encode(image: Image.Image) -> tuple[bytes, Image.Image, bytes]:
    assert image.format == "PNG" and image.mode == "RGB" and image.size == (1320, 2868)
    assert "transparency" not in image.info
    icc = image.info["icc_profile"]
    assert "srgb" in ImageCms.getProfileDescription(
        ImageCms.ImageCmsProfile(io.BytesIO(icc))).lower()
    height = round(image.height * TARGET[0] / image.width)
    assert height == 2620
    resized = image.resize((TARGET[0], height), Image.Resampling.LANCZOS)
    final = Image.new("RGB", TARGET)
    final.paste(resized, (0, 1))
    final.paste(resized.crop((0, 0, TARGET[0], 1)), (0, 0))
    final.paste(resized.crop((0, height - 1, TARGET[0], height)), (0, TARGET[1] - 1))
    buffer = io.BytesIO()
    final.save(buffer, format="PNG", icc_profile=icc, optimize=True)
    return buffer.getvalue(), resized, icc


def verify_png(data: bytes, expected: Image.Image, icc: bytes) -> dict:
    with Image.open(io.BytesIO(data)) as output:
        output.load()
        assert output.format == "PNG" and output.size == TARGET
        assert output.mode == "RGB" and "A" not in output.getbands()
        assert "transparency" not in output.info and output.info["icc_profile"] == icc
        # Full expected resized content is present, with only the documented edge rows.
        assert output.crop((0, 1, 1206, 2621)).tobytes() == expected.tobytes()
        assert output.crop((0, 0, 1206, 1)).tobytes() == expected.crop((0, 0, 1206, 1)).tobytes()
        assert output.crop((0, 2621, 1206, 2622)).tobytes() == expected.crop((0, 2619, 1206, 2620)).tobytes()
    return {"size": list(TARGET), "mode": "RGB", "alpha": False,
            "srgb_icc_preserved": True, "complete_resampled_content": True,
            "top_bottom_edge_rows_match": True}


def contact_sheet(locale: str, icc: bytes) -> Path:
    # Contact labels use Pillow's included Latin bitmap font, no font download.
    font = ImageFont.load_default()
    sheet = Image.new("RGB", (1060, 1580), "#E7ECF2")
    draw = ImageDraw.Draw(sheet)
    draw.text((22, 12), f"Lecture Asset | {locale} | 1206 x 2622 | upload copies", font=font, fill="#203247")
    for index, name in enumerate(NAMES):
        x, y = 20 + (index % 3) * 350, 42 + (index // 3) * 770
        with Image.open(TASK / "store" / locale / name) as image:
            preview = image.resize((330, 718), Image.Resampling.LANCZOS)
        sheet.paste(preview, (x, y))
        draw.text((x, y + 726), f"{index + 1:02d}  {name[3:-4]}", font=font, fill="#203247")
    suffix = "EN" if locale == "en" else "ZH_HANS"
    path = TASK / ("CONTACT_SHEET_" + suffix + ".png")
    sheet.save(path, icc_profile=icc, optimize=True)
    return path


def bundle(entries: list[dict]) -> dict:
    archive = TASK / "LectureAsset-AppStore-1206x2622.zip"
    readme = (
        "Lecture Asset - App Store screenshot upload copies\n"
        "1206 x 2622 RGB/sRGB PNG; no alpha.\n"
        "en: English, zh-Hans: Simplified Chinese. Upload each language separately.\n"
        "Use iPhone with Dynamic Island (medium display). Keep order01 through06.\n"
        "Do not upload the ZIP or contact sheets as screenshots; extract PNG files first.\n"
        "Frozen1320x2868 masters are unchanged. No ASC upload was performed.\n"
    ).encode("utf-8")
    files = {entry["archive_path"]: (TASK / entry["file"]).read_bytes() for entry in entries}
    files["README.txt"] = readme
    with ZipFile(archive, "w", compression=ZIP_DEFLATED, compresslevel=6) as output:
        for name, data in files.items():
            info = ZipInfo(name, date_time=(2026, 10, 15, 0, 0, 0))
            info.compress_type = ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            output.writestr(info, data)
    with ZipFile(archive) as opened:
        assert opened.testzip() is None
        assert set(opened.namelist()) == set(files)
        assert len(opened.namelist()) == len(files) == 13
        for name, data in files.items():
            assert not name.startswith("/") and ".." not in Path(name).parts
            assert opened.read(name) == data
    return {"file": archive.name, "sha256": sha(archive.read_bytes()),
            "bytes": archive.stat().st_size, "png_count": 12,
            "entry_count_including_readme": 13, "reopen_crc_and_all_bytes": "PASS"}


def main() -> None:
    frozen_before = frozen_inventory()
    entries, sheets = [], []
    for locale in LOCALES:
        manifest_name = "RENDER_MANIFEST.json" if locale == "en" else "RENDER_MANIFEST_ZH_HANS.json"
        historical = json.loads((SOURCE / manifest_name).read_text(encoding="utf-8"))
        assert [Path(item["file"]).name for item in historical] == list(NAMES)
        for index, name in enumerate(NAMES):
            source = SOURCE / "store" / locale / name
            with Image.open(source) as image:
                data, resized, icc = encode(image)
                assert encode(image)[0] == data, "Non-deterministic PNG encoding"
            target = TASK / "store" / locale / name
            target.parent.mkdir(parents=True, exist_ok=True)
            if target.exists():
                assert target.read_bytes() == data, "Refuse to replace a different derivative"
            else:
                target.write_bytes(data)
            checks = verify_png(target.read_bytes(), resized, icc)
            # Existing Chinese external text boxes transform with the entire image.
            for text in historical[index].get("external_text_bounds", []):
                left, top, right, bottom = text["bounds"]
                assert 0 <= left <= right <= 1320 and 0 <= top <= bottom <= 2868
                mapped = [left * 1206 / 1320, 1 + top * 2620 / 2868,
                          right * 1206 / 1320, 1 + bottom * 2620 / 2868]
                assert 0 <= mapped[0] <= mapped[2] <= 1206
                assert 1 <= mapped[1] <= mapped[3] <= 2621
            entries.append({"file": target.relative_to(TASK).as_posix(),
                            "archive_path": f"{locale}/{name}", "page": index + 1,
                            "source": source.relative_to(REPO).as_posix(),
                            "source_sha256": sha(source.read_bytes()),
                            "output_sha256": sha(data), "bytes": len(data),
                            "icc_sha256": sha(icc), "checks": checks,
                            "deterministic_repeat": True,
                            "illustrative_overlay": historical[index].get("illustrative_overlay"),
                            "source_phone_rect": historical[index]["phone_rect"],
                            "transform": {"resize": [1206, 2620], "padding_top_bottom": [1, 1],
                                          "nominal_scale": 1206 / 1320,
                                          "integer_height_rounding_px": 2620 - 2868 * 1206 / 1320}})
        path = contact_sheet(locale, icc)
        sheets.append({"file": path.name, "sha256": sha(path.read_bytes())})
    zipped = bundle(entries)
    assert frozen_inventory() == frozen_before
    assert len(entries) == 12
    manifest = {"date": "2026-10-15", "base_sha": BASE,
                "target_slot": "iPhone with Dynamic Island (medium display)",
                "target_size": list(TARGET), "source_masters": [1320, 2868],
                "method": "LANCZOS aspect-preserving integer resize; duplicate1 edge row top and bottom; no crop or repaint",
                "frozen_images_and_contact_sheets": frozen_before,
                "frames": entries, "new_contact_sheets": sheets, "bundle": zipped}
    json_write(TASK / "EXPORT_MANIFEST.json", manifest)
    report = {"status": "PASS_LOCAL_EXPORT_VALIDATION", "base_sha": BASE,
              "tested_export_source_sha": git("rev-parse", "HEAD").decode().strip(),
              "environment": {"python": platform.python_version(), "pillow": PILLOW_VERSION,
                              "platform": platform.system()},
              "locales": {locale: {"png_count": 6, "size": list(TARGET)} for locale in LOCALES},
              "frozen_12_masters_and_2_contact_sheets_byte_identical": "PASS",
              "all_historical_screenshot_task_files_git_unchanged": "PASS",
              "png_rgb_srgb_no_alpha_full_decode": "PASS",
              "no_crop_complete_resampled_pixels_and_padding": "PASS",
              "repeat_encoding_byte_identical": "PASS",
              "existing_chinese_text_bounds_within_output": "PASS",
              "zip_reopen_crc_count_and_bytes": "PASS",
              "new_font_or_package_install": False,
              "visual_review": "PENDING_ACTUAL_CONTACT_AND_FULL_SIZE_INSPECTION",
              "asc_upload_acceptance_lecture_asset": "NOT_RUN",
              "new_capture_xcode_testflight_or_runtime_tests": "NOT_RUN_ASSET_EXPORT_ONLY",
              "scope_check": "PENDING_FINAL_GIT_DIFF",
              "owner_upload_order": "01,02,03,04,05,06 separately for each locale"}
    json_write(TASK / "TEST_RESULTS.json", report)
    print("PASS:12 PNGs at1206x2622 RGB/sRGB/no alpha; frozen images unchanged; ZIP verified")
    print(TASK)


if __name__ == "__main__":
    main()
