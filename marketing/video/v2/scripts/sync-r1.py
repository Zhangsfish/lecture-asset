"""Synchronize active direction only. Never overwrite Phase A evidence."""
from pathlib import Path
import json, hashlib, subprocess
V2=Path(__file__).resolve().parents[1]
ROOT=V2.parents[2]
def write(name,text):
    (V2/name).write_text(text.strip()+"\n",encoding="utf-8")
timings=[(0,180),(180,330),(330,480),(480,690),(690,840),(840,1062),(1062,1170),(1170,1320)]
zh=[
 ["舍不得删。","交给 AI，又太乱。"],["选好。排好。"],
 ["PDF，留着回看。","AI ZIP，交给 AI。"],["连怎么读，都准备好了。"],
 ["交给 WorkBuddy。"],["总结。报告。"],["留好资料，再清相册。"],
 ["把讲座交给 AI，","把相册还给自己。"]]
en=[
 ["Too useful to delete.","Too scattered for AI."],["Select. Put it in order."],
 ["PDF. Keep it for later.","AI ZIP. Ready to share."],["Reading instructions included."],
 ["Over to ChatGPT."],["A summary. A report."],["Keep the files. Clear the photos."],
 ["Hand the lecture to AI.","Take back your photo library."]]
names=["mixed-library","selection-follow","two-deliverables","inside-the-zip","external-handoff","readable-results","saved-then-clear","life-returned"]
views=["wide occluding photo space","follow the ordered pages","file split / sleeve-edge closeup",
       "continuous archive contents / small orbiting camera arc","same ZIP handed into external content space",
       "summary assembles / report turns front / hold","same album / saved cue before departure","front-facing personal photos / simultaneous slogan"]
plan={
 "id":"lecture-asset-v2-director-r1","status":"READY_FOR_DIRECTOR_CUT_REVIEW",
 "authority":"DIRECTOR_NEXT.md","instruction_sha256":hashlib.sha256((V2/"DIRECTOR_NEXT.md").read_bytes()).hexdigest(),
 "branch_input_sha":subprocess.check_output(["git","rev-parse","HEAD"],cwd=ROOT,text=True).strip(),
 "latest_main_at_start":"4995c1d0d70ebdf3712416bf96ee31219fc67720",
 "original_pr_base_sha":"bf3a0c52d1678ce3eceedaff1a90ae982250b695",
 "width":1080,"height":1920,"output_width":720,"output_height":1280,"fps":60,"duration_frames":1320,"duration_seconds":22,
 "variants":[{"id":"en-chatgpt","locale":"en","provider":"ChatGPT"},{"id":"zh-workbuddy","locale":"zh-Hans","provider":"WorkBuddy"}],
 "personal_ids":["P"+str(i).zfill(2) for i in range(1,9)],
 "lecture_ids":["L"+str(i).zfill(2) for i in range(1,13)],
 "rules":{"zh-Hans":["页图为准","索引定位","回图核对"],"en":["Images first","Index to navigate","Verify on the page"]},
 "scenes":[{"id":i+1,"name":names[i],"in":a,"out":b,"copy":{"zh-Hans":zh[i],"en":en[i]},"view":views[i]} for i,(a,b) in enumerate(timings)],
 "hero_frames":[45,264,420,594,822,1014,1137,1254],
 "audio_cues":[{"frame":3,"name":"photo-wipe"},{"frame":184,"name":"selection-sweep"},
   {"frame":296,"name":"stack-settle"},{"frame":492,"name":"sleeve-open"},
   {"frame":714,"name":"handoff"},{"frame":966,"name":"report-resolve"},{"frame":1090,"name":"album-release"}],
 "saved_confirm_frame":1077,"first_departure_frame":1087,"slogan_settled_by_frame":1182,
 "source_summary":{"source":"accepted fixtures 13–24 / assets/lecture/0001.jpg–0012.jpg",
  "bullets":["Ask what the idea means.","Link it to a concrete example.","Return to it with a fresh question."],
  "topics":["Test a small change","Review the evidence","Use a concrete example","Questions for discussion"],
  "output_status":"editorial illustrative summary; not provider transcript"}
}
write("plan.json",json.dumps(plan,ensure_ascii=False,indent=2))
write("CREATIVE_BRIEF.md","""
# V2 / director R1

Authority: DIRECTOR_NEXT.md, fetched PR input 89c705d; latest main at start recorded in plan.json.
Current delivery: a complete 22.000s / 1320-frame / 60fps conceptual director cut.
Working canvas 1080×1920, review films 720×1280: English/ChatGPT and zh-Hans/WorkBuddy, with muted copies.
Stop READY_FOR_DIRECTOR_CUT_REVIEW. A-only approval gate and old timings are superseded.

Story: life photos crowded by lecture → user selection and chronological order →
separate PDF + AI ZIP → the same archive opens its images/index/mapping/reading rules →
external AI handoff → related illustrative summary/report → saved files precede source-photo departure →
the same P01–P08 remain, with the two slogan lines simultaneously held.

Wide photo-space, follow-camera, archive macro and front-facing report replace the repeated poster header.
No live UI, webpage clone, orbit diagram, invented trend graph, quantitative speed/storage claim,
real provider transcript or new product action. No voiceover.
Phase A evidence remains historical and untouched. Old v1 export/provider blockers do not block R1.
""")
write("STYLE_RULES.md","""
# Director R1 visual rules

Use DIRECTOR_NEXT.md. Deep #090B10, warm white paper #EEEAE1, Calm cobalt #4772A8.
Life atlas and twelve lecture textures unchanged. No particles, full-screen glow or gradient title cards.

- First frame is a crowded photographic world, not a title/logo.
- Captions live beside the action, not a fixed top band. One main sentence at a time.
- Stable object IDs P01–P08, L01–L12, zip-hero, pdf-hero, readme-layer, summary, report.
- A thin landscape cobalt sleeve with light paper edges replaces the toy box / thick zipper.
- Archive opening is one depth-connected fan, paired text indexes and corresponding page/file lines.
- External provider is plain text naming a conceptual destination, no browser/chatter shell.
- Summary/report uses source-related meaning/example/fresh-question structure; no fabricated numbers/chart.
- Report turns to a front-readable plane and settles for frames 966–1062.
- Saved cue precedes all lecture departures. Same life atlas crops return; no storage-reclamation claim.
- Slogan settles by frame 1182 and remains readable to 1319. Only background breath continues.

Installed Microsoft YaHei and Segoe UI, local font copies ignored. Working safe text zone:
x 80..900, y 160..1560. Review at 360px width; this is our conservative production zone,
not a claim about platform official masks.

One paused GSAP master, seek(frame/60), driving camera, content and typography.
No CSS time-based animation, flattened poster slideshow, new rendering engine or generative video.
""")
rows=["# R1 locked shotlist","","22 seconds / 1320 frames. DIRECTOR_NEXT is authoritative; ranges [in,out).",
      "","| Scene | Frames / seconds | 中文 | English | Shot |","|---|---|---|---|---|"]
for s in plan["scenes"]:
 rows.append("| S%02d | [%d,%d) / %.1f–%.1fs | %s | %s | %s |"%(s["id"],s["in"],s["out"],s["in"]/60,s["out"]/60," → ".join(s["copy"]["zh-Hans"])," → ".join(s["copy"]["en"]),s["view"]))
rows += ["","S01 captions: [6,78), [90,171). S02 stack stable [294,330).",
 "S04: unfold [480,552), read/highlight [552,642), close [642,690).",
 "S06: gather [840,912), form [912,966), hold [966,1062).",
 "S07: saved at 1077; departures begin 1087. S08 both lines settled by 1182.",
 "Music/SFX are included in R1; muted versions preserve exact video. No public publication authorization."]
write("SHOTLIST.md","\n".join(rows))
write("STORYBOARD.md","""
# Director R1 storyboard / actual timeline

Historical static posters remain review/phase-a. R1 is not motion over those PNGs.
Current compositions and bilingual copy are specified in plan.json + DIRECTOR_NEXT.

| Shot | Focal transformation | Representative actual frame |
|---|---|---|
| 1 | Mixed life/lecture photo depth, a foreground page wipes past | 45 |
| 2 | Selected pages follow ordered trail, then one stable stack | 264 |
| 3 | Same paper stack splits into PDF and thin AI ZIP | 420 |
| 4 | Same sleeve opens pages, paired index and mapping, README rules | 594 |
| 5 | Same ZIP enters explicitly external provider space | 822 |
| 6 | Related summary and front-facing readable report settle | 1014 |
| 7 | Saved cue, then lecture departure; same life remains | 1137 |
| 8 | Same P01–P08, both slogan lines and icon/name held | 1254 |

Output: review/director-r1/ — two complete 720p films and muted copies; 1080p
timeline snapshots per language; actual encoded-film extraction; contact sheets;
180×320 <=8192-byte JPEG proxies + exact base64; QA and delivery.
Director review pending. No automatic Phase C.
""")
write("PROVIDER_VARIANTS.md","""
# True bilingual R1 variants

English/ChatGPT is the primary TikTok director cut. Chinese/WorkBuddy shares the
same persistent objects, 1320-frame timing, camera, assets and sound.
Every primary caption, rule, summary/report line, saved cue and end slogan is localized.
The original English lecture photos and technical filenames are source content, not App UI.

Both providers are external plain-text destinations, not integrations or website reproductions.
Summary/report is marked once Illustrative output / 结果示意. It is grounded in the included
synthetic lecture's meaning → concrete example → fresh-question content, not a recorded response.
No provider account, prompt, Send click, exact archive export or screen recording is needed for this concept.
No actual model output VERIFIED claim. No partnership or availability promise.
""")
write("ASSET_MANIFEST.md","""
# R1 asset manifest

Keep ASSET_LEDGER.json as the original image/font hash authority.
assets/life-atlas.png is the same original fictional photographic atlas; no regeneration.
P01–P08 reuse fixed CSS 2×4 crops in both opening/ending, one DOM object per logical photo.
assets/lecture/0001.jpg–0012.jpg are the unchanged accepted synthetic fixtures 13–24.
assets/app-icon.png is the accepted icon copy, unchanged.

Source text was checked against the actual fixture generator and images:
Ask what the idea means. / Link it to a concrete example. / Return to it with a fresh question.
The synthetic page topics include Test a small change / Review the evidence /
Use a concrete example / Questions for discussion. R1 summary/report reflects those ideas.
All result content is editorial illustration, not a claimed provider transcript.
PDF remains outside ZIP; fan/index/mapping/README explain the existing archive roles,
not a newly validated production export.

assets/sound/director-score.wav is deterministic original local synthesis from
scripts/make-score.py. No purchased/downloaded track, voiceover or audio API.
Exact cues and source hashes are in review/director-r1 QA/SOUND.
Fonts remain local installed copies, not redistributed.

Full pictures and films are review artifacts within this existing PR, not a public campaign.
No private photo/account/OCR/identifier assets, third-party logo or new screenshot capture.
""")
write("README.md","""
# Lecture Asset v2 — director R1

Current authority: DIRECTOR_NEXT.md. This PR #18 delivers the complete corrective
director cut. Stop READY_FOR_DIRECTOR_CUT_REVIEW; no merge, release or Phase C.

22.000 seconds / 1320 frames / 60fps; 1080×1920 authoring, 720×1280 review MP4.
English/ChatGPT + Chinese/WorkBuddy + muted versions.

## Reproduce

Reuse installed local fonts under ignored assets/fonts/ and the existing exact npm lock.
Do not rerun bootstrap.py or historical Phase A render/review/evidence commands:
they describe the superseded still-only stage and must not overwrite its evidence.

1. F:/anaconda3/python.exe scripts/make-score.py
2. npm run build
3. node scripts/director-render.mjs — actual full HyperFrames timeline renders.
4. node scripts/director-qa.mjs — readiness, safe text, ordered IDs, forward/reverse seek.
5. F:/anaconda3/python.exe scripts/director-package.py — encode 720p/muted, extract
   timeline film frames, contact sheets, small JPEG/base64 review proxies, media QA.

All production pixels are rendered from persistent HTML/CSS/SVG source objects on
one paused GSAP timeline, not the old eight PNGs. FFmpeg encodes/scales/extracts media.
DOM/seek inspection is verification, never a second movie production pipeline.
Both CSS atlas and HTML images explicitly await decode. No missing absolute asset dependency.

Current delivery/evidence: review/director-r1/. Historical Phase A is retained unchanged.
Conceptual AI outputs do not reinstate v1 provider/export gates.
No App/Packages/Store/ASC/TestFlight changes, new tools/accounts/purchases or public posting.
""")
print("Synchronized director R1 plan and active documents; Phase A preserved.")
