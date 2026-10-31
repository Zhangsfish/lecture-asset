"""Fail if the review fix changes any production behavior beyond two labels."""
import argparse
import copy
import hashlib
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
BASE = "585e753e7142cfe64babfdd28a1673f558ab84dd"
PROTECTED = ["App", "AppResources", "Packages", "schemas", "project.yml", "public-pages",
             "reports/S05/store-screenshots-01", "reports/S05/store-screenshots-medium-01",
             ".github/workflows/s05-final-rc.yml", "scripts/s05_final_rc.sh",
             "scripts/s05_rc_verify.py", "scripts/s05_rc_bridge.py", "scripts/s05_rc_status.swift"]


def git(*args):
    return subprocess.check_output(["git", *args], cwd=ROOT)


def audit():
    original = json.loads(git("show", BASE + ":App/Localizable.xcstrings"))
    changed = json.loads((ROOT / "App/Localizable.xcstrings").read_text(encoding="utf-8"))
    expected = copy.deepcopy(original)
    for locale, old, new in [("en", "Allow full access", "Continue"),
                             ("zh-Hans", "允许完整访问", "继续")]:
        value = expected["strings"]["permission.allow"]["localizations"][locale]["stringUnit"]
        assert value["value"] == old
        value["value"] = new
    assert changed == expected, "Only permission.allow translations may change"
    paths = git("diff", "--name-only", BASE, "--", *PROTECTED).decode().splitlines()
    assert paths == ["App/Localizable.xcstrings"], paths
    hashes = {path: hashlib.sha256((ROOT / path).read_bytes()).hexdigest() for path in [
        "App/ContentView.swift", "App/PhotoLibraryModel.swift", "App/AgeAssuranceEntryView.swift",
        "App/AgeAssuranceService.swift", "App/LectureAssetApp.swift", "project.yml",
        "scripts/s05_rc_verify.py", "scripts/s05_final_rc.sh", ".github/workflows/s05-final-rc.yml"]}
    return {"base_sha": BASE, "tested_sha": git("rev-parse", "HEAD").decode().strip(),
            "production_diff": paths, "catalog_only_two_values": True,
            "protected_production_and_old_release_paths": "PASS", "unchanged_sha256": hashes,
            "status": "PASS", "asc_and_upload": "NOT_RUN"}


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    result = audit()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print("APP_REVIEW_SCOPE_PASS: only two permission.allow values changed in production")
