"""Summarize actual A checks; no motion/provider/device pass claims."""
from pathlib import Path
from fontTools.ttLib import TTCollection
import hashlib
import json
import platform
import subprocess

V2=Path(__file__).resolve().parents[1]
ROOT=V2.parents[2]
review=V2/"review/phase-a"
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
plan=json.loads((V2/"plan.json").read_text(encoding="utf-8"))
tests=json.loads((review/"VALIDATION.json").read_text(encoding="utf-8"))
tested=subprocess.check_output(["git","rev-parse","HEAD"],cwd=ROOT,text=True).strip()
def command(args):
    result=subprocess.run(args,cwd=V2,text=True,capture_output=True,encoding="utf-8")
    return {"command":args,"exit_code":result.returncode,"stdout":result.stdout.strip()}
tools=[
    command(["node","--version"]),command(["cmd","/c","npm","--version"]),
    command(["powershell","-NoProfile","-Command","(Get-Item 'C:/Program Files/Google/Chrome/Application/chrome.exe').VersionInfo.ProductVersion"]),
    command(["E:/video_to_md/readable-transcript/resource/bin/ffmpeg.exe","-version"])
]
tools[-1]["stdout"]=tools[-1]["stdout"].splitlines()[0]
packages={}
for pkg in ["hyperframes","gsap","typescript","esbuild","puppeteer-core"]:
    packages[pkg]=json.loads((V2/"node_modules"/pkg/"package.json").read_text(encoding="utf-8"))["version"]
ledger=json.loads((V2/"ASSET_LEDGER.json").read_text(encoding="utf-8"))
fonts=[a for a in ledger["assets"] if "/fonts/" in a["path"]]
required=set("".join(c for s in plan["scenes"] for c in s["copy"])+"".join(plan["rules"])+"观察变化寻找联系核对证据ZIP 已保存Lecture Asset")
glyphs=TTCollection(str(V2/"assets/fonts/msyhbd.ttc")).fonts[0].getBestCmap()
missing=[char for char in sorted(required) if not char.isspace() and ord(char) not in glyphs]
assert not missing,missing
protected={}
for file in subprocess.check_output(["git","ls-tree","-r","--name-only",plan["base_sha"]],cwd=ROOT,text=True).splitlines():
    if file.startswith(("App/","AppResources/","Packages/","schemas/",".github/","reports/S05/store-screenshots-01/")) or file in ["project.yml","AGENTS.md","STATUS.md","docs/PRODUCT_DECISIONS.md","docs/SPEC.md"]:
        original=subprocess.check_output(["git","show",plan["base_sha"]+":"+file],cwd=ROOT)
        assert hashlib.sha256(original).hexdigest()==sha(ROOT/file),file
        protected[file]=sha(ROOT/file)
env={"os":platform.platform(),"python":platform.python_version(),"packages":packages,"commands":tools,"fonts":fonts,
     "icc_sha256":sha(Path("C:/Windows/System32/spool/drivers/color/sRGB Color Space Profile.icm")),
     "font_binary_committed":False,"renderer":"HyperFrames native static snapshot + system Chrome SwiftShader","paid_services":False}
(review/"ENVIRONMENT.json").write_text(json.dumps(env,ensure_ascii=False,indent=2),encoding="utf-8")
(review/"PROTECTED_PATHS.json").write_text(json.dumps({"base":plan["base_sha"],"count":len(protected),"files":protected},indent=2),encoding="utf-8")
tests["tested_code_sha"]=tested
tests["checks"]["all_required_cjk_and_latin_glyphs"]="PASS"
tests["checks"]["protected_files_byte_identical"]="PASS"
tests["checks"]["protected_file_count"]=len(protected)
tests["source_digests"]={str(p.relative_to(V2)).replace("\\","/"):sha(p) for p in sorted((V2/"src").glob("*"))}
tests["actual_commands"]=["npm install --no-audit --no-fund","npm run build","node scripts/render-frames.mjs","node scripts/inspect-dom.mjs","F:/anaconda3/python.exe scripts/review.py","F:/anaconda3/python.exe scripts/evidence.py"]
tests["visual_review"]="Native snapshots actually viewed individually and as carousel; author assessment, owner approval pending."
tests["notes"]=["Scene 1 shows a late hook still; all three subtitles remain locked in SHOTLIST, 2.8s readability belongs to Phase B.",
 "Scene 4 rules and Scene 6 result are static peak treatments; motion/music/beat synchronization NOT_RUN.",
 "Summary/report is editorial concept, not recorded provider output.",
 "HyperFrames warns atlas exceeds 2MB inline threshold; local PNG decoding/rendering checked. No self-contained single-file HTML claim."]
(review/"TEST_RESULTS.json").write_text(json.dumps(tests,ensure_ascii=False,indent=2),encoding="utf-8")
(review/"ENVIRONMENT.md").write_text("""# Actual environment

Windows / Node 24.15.0 / npm 11.12.1 / Chrome 154.0.8037.93.
HyperFrames 0.8.132, GSAP 3.15.0, TypeScript 7.0.2, esbuild 0.28.2.
FFmpeg 9.0.1 is available; NOT_RUN for video export in this still-only phase.
Python 3.11.7 / Pillow 10.2.0 / fontTools; installed Microsoft YaHei + Segoe UI.
Exact package versions, font hashes, ICC and actual commands: ENVIRONMENT.json.

Native snapshot renderer: system Chrome, SwiftShader (--no-browser-gpu).
Puppeteer DOM inspection does not capture pixels. Contact sheet uses existing
Pillow and installed Windows sRGB ICC (no new color-management dependency).
Local npm dependencies installed in v2 only under existing project authorization.
Fonts are ignored local copies; none redistributed. No accounts/credentials used
for render; GitHub push uses existing credential helper without printing it.
""",encoding="utf-8")
(review/"DELIVERY.md").write_text(f"""# V2 Phase A delivery

Status: **READY_FOR_PHASE_A_REVIEW** — stop for owner review.
Base: {plan['base_sha']}.
Tested authoring code: {tested}.
Current owner request authorizes v2 A, not historical M01 or next stages.

## Delivered

Six requested documents, repository-source review/inventory, source/asset ledger,
eight native 1080×1920 RGB/sRGB style frames, one ChatGPT-name alternate and
[CONTACT_SHEET.png](CONTACT_SHEET.png). Only marketing/video/v2 changed.

### Author visual review

- Opening is physically crowded photos rather than an App walkthrough.
- The same ordered lecture sheets turn into PDF and a larger AI ZIP; ZIP remains
  separate from its companion PDF.
- Scene 4 has the strongest information density: twelve complete page images,
  OCR index, page mapping and three readable reading rules.
- Scene 6 contrasts compressed Summary with a foreground Report. It is an
  editorial outcome concept; no invented ChatGPT/WorkBuddy transcript.
- Scene 7 shows ZIP saved before lecture cards depart. P01–P08 match opening,
  including source hash/crop; Scene 8 leaves the same life album and exact slogan.
- No clipped headline/rules, no phone/system/provider page clone, no gradient
  background, no cheap particle/glow layer, no storage/recently-deleted claim.

These are representative stills. Poster hierarchy is reviewable; actual kinetic
impact and beat are not demonstrated by stills. Scene 1's three subtitles in
2.8 seconds are the main reading-rate risk to check in B without rewriting story.
Owner approval has not been assumed. Viral/Apple-film quality is not a tested
performance claim.

## Actual verification

TypeScript build; nine actual HyperFrames snapshots; nine browser DOM/readiness
checks; CJK/Latin glyph coverage; eight 1080×1920 RGB/sRGB outputs; source fixtures
and icon bytes; same eight life IDs/crops in 1/7/8; {len(protected)} protected
baseline files byte-identical. See TEST_RESULTS, RENDER_LOG and DOM_INSPECTION.

Changed no App/runtime/Packages/schema/localization/project/workflow/Store assets.
No ASC, TestFlight, App Review, public posting, paid service or destructive test.

## NOT_RUN / next gate

Phase B 22-second animatic, moving transitions, final pacing, music/SFX, Phase C
cn/int'l/silent masters, real provider response evidence and public publication:
**NOT_RUN**. A requires owner visual approval; no next phase starts automatically.
The concept treatment does not resolve independent v1 M00 export/provider
evidence blockers, and nothing in v1 was overwritten.
""",encoding="utf-8")
print(json.dumps({"tested":tested,"protected_files":len(protected),"glyphs":"PASS","stage":"READY_FOR_PHASE_A_REVIEW"},ensure_ascii=False))
