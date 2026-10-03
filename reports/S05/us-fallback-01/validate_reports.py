"""Report-only validation; does not build, launch, upload or mutate ASC."""
import hashlib
import json
from pathlib import Path
import re
import subprocess


ROOT = Path(__file__).resolve().parents[3]
FOLDER = Path(__file__).resolve().parent
BASE = "72e194c0b4ce87485f70288202dbd70d91365d2a"
ACCEPTED = "618cbb4fa25068f7d117c6da6007ad0e2aa96518"


def git(*args):
    return subprocess.check_output(["git", *args], cwd=ROOT, text=True).strip()


checks = []


def check(name, condition, detail):
    checks.append({"name": name, "status": "PASS" if condition else "FAIL", "detail": detail})


required = ["AGENTS.md", "DELIVERY.md", "ENVIRONMENT.md", "US_LEGAL.md", "US_ASC_FIELDS.md",
            "APP_PRIVACY_RECOMMENDATION.md", "AGE_RATING_US.md", "STORE_CONVERSION_AUDIT.md",
            "PROMO_READY.md", "listing-en.json", "sources.json"]
check("delivery_files", all((FOLDER / x).is_file() for x in required), required)
changed = sorted(set(git("diff", "--name-only", BASE).splitlines()
                     + git("ls-files", "--others", "--exclude-standard").splitlines()))
check("only_report_scope", all(x.startswith("reports/S05/us-fallback-01/") for x in changed), changed)
runtime_paths = ["App", "AppResources", "Packages", "project.yml", "schemas"]
diff = git("diff", ACCEPTED, "--", *runtime_paths)
check("accepted_runtime_unchanged", not diff, {"compared_sha": ACCEPTED, "paths": runtime_paths})
check("base_ancestry", subprocess.run(["git", "merge-base", "--is-ancestor", BASE, "HEAD"], cwd=ROOT).returncode == 0, BASE)

listing = json.loads((FOLDER / "listing-en.json").read_text(encoding="utf-8"))
limits = {"name": 30, "subtitle": 30, "keywords": 100, "promotional_text": 170, "description": 4000}
lengths = {key: len(listing[key].encode("utf-8")) if key == "keywords" else len(listing[key]) for key in limits}
check("listing_field_limits", all(lengths[k] <= v for k, v in limits.items()), lengths)
check("listing_is_proposed_only", listing["applied_to_asc"] is False and listing["version"] == "0.1.0", "No ASC mutation")
sheet = (FOLDER / "US_ASC_FIELDS.md").read_text(encoding="utf-8")
blocks = re.findall(r"```text\n(.*?)\n```", sheet, re.S)
check("paste_blocks_exact", blocks == [listing["description"], listing["review_notes"]], "JSON and Markdown match")
previous = (ROOT / "reports/S05/release-preflight-01/METADATA_EN.md").read_text(encoding="utf-8")
description = previous.split("## Description\n\n", 1)[1].split("\n## Declarations", 1)[0].strip()
check("existing_english_description_reused", description == listing["description"], "D0 draft reused verbatim")

broken = []
for path in FOLDER.glob("*.md"):
    for link in re.findall(r"\]\(([^)]+)\)", path.read_text(encoding="utf-8")):
        if "://" in link or link.startswith("#"):
            continue
        if not (path.parent / link.split("#", 1)[0]).exists():
            broken.append({"file": path.name, "link": link})
check("local_report_links", not broken, broken)

assets = [ROOT / "App/Assets.xcassets/AppIcon.appiconset/AppIcon.png"]
assets += sorted((ROOT / "reports/S05/release-preflight-01/screenshots").glob("*.png"))
check("reviewed_asset_set", len(assets) == 6 and all(p.is_file() for p in assets), "Icon + five Chinese screenshots")
asset_hashes = [{"path": p.relative_to(ROOT).as_posix(), "sha256": hashlib.sha256(p.read_bytes()).hexdigest()} for p in assets]

source = json.loads((FOLDER / "sources.json").read_text(encoding="utf-8"))
check("public_pages_reachable", all(r["status"] == 200 for r in source["direct_https_checks"] if r["key"] in ("privacy_page", "support_page")), "Direct HTTPS, no login; Chinese pages")
check("official_api_documents_fetched", all(r["status"] == 200 for r in source["direct_https_checks"] if r["key"].endswith("_api")), "Official Apple Markdown read")
api_present = git("grep", "-n", "-E", "DeclaredAgeRange|PermissionKit|AgeRangeService", BASE, "--", "App") if subprocess.run(["git", "grep", "-q", "-E", "DeclaredAgeRange|PermissionKit|AgeRangeService", BASE, "--", "App"], cwd=ROOT).returncode == 0 else ""
check("current_age_api_gap_confirmed", not api_present, "No age-assurance integration in current App source")

results = {
    "stage": "S05-D1", "date": "2026-10-03", "status": "READY_FOR_AUDIT",
    "preparation_status": "READY_FOR_OWNER_US_DECISION", "us_release_clearance": "BLOCKED",
    "base_sha": BASE, "tested_code_sha": BASE, "accepted_runtime_sha": ACCEPTED,
    "runtime_source_changed": False, "us_launch_runtime_change_required": "YES",
    "existing_testflight": {"version": "0.1.0", "build": "30.1", "state": "VALID", "audience": "INTERNAL_ONLY", "evidence": "D0 snapshot; not re-queried this round"},
    "checks": checks, "reviewed_assets": asset_hashes,
    "not_run": ["Xcode build", "new CI", "new TestFlight upload", "new device QA", "complete live court docket", "ASC questionnaire entry", "English screenshot production", "conversion experiment", "Remotion render", "distribution RC", "App Review", "public release"],
    "unresolved": ["Texas older-OS/new-account age API coverage and consent handling", "Louisiana platform rollout clarification after 2027 statutory postponement", "complete current litigation docket / pre-release legal confirmation", "owner privacy and identity/rights/release decisions", "final English screenshot set and public English help/policy usability"],
    "china_support_case_id_recorded": False,
}
(FOLDER / "TEST_RESULTS.json").write_text(json.dumps(results, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"checks": checks, "failures": sum(x["status"] == "FAIL" for x in checks)}, ensure_ascii=False, indent=2))
raise SystemExit(any(x["status"] == "FAIL" for x in checks))
