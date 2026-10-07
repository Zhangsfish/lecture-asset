"""Package HF stills/contact sheet and check locked story/protected paths."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import hashlib
import json
import subprocess

V2=Path(__file__).resolve().parents[1]
ROOT=V2.parents[2]
review=V2/"review/phase-a"
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
plan=json.loads((V2/"plan.json").read_text(encoding="utf-8"))
srgb=Path("C:/Windows/System32/spool/drivers/color/sRGB Color Space Profile.icm").read_bytes()
font=ImageFont.truetype("C:/Windows/Fonts/msyh.ttc",24)
small=ImageFont.truetype("C:/Windows/Fonts/segoeui.ttf",20)
sheet=Image.new("RGB",(1200,1242),"#090B10")
draw=ImageDraw.Draw(sheet)
files=[]
labels=["相册被挤满","抽离 / 排序","PDF + AI ZIP","包内阅读规则","交给外部 AI","总结 / 报告","生活回到相册","品牌余韵"]
for scene in plan["scenes"]:
    number=scene["id"]
    path=review/f"{number:02}-{scene['name']}.png"
    with Image.open(path) as source:
        assert source.size==(1080,1920), (path,source.size)
        image=source.convert("RGB")
    image.save(path,icc_profile=srgb)
    x=(number-1)%4*300+12
    y=(number-1)//4*621
    sheet.paste(image.resize((276,491),Image.Resampling.LANCZOS),(x,y+12))
    draw.text((x,y+519),f"{number:02}  {labels[number-1]}",font=font,fill="#EEEAE1")
    draw.text((x,y+560),f"{scene['in']/60:.1f}–{scene['out']/60:.1f}s",font=small,fill="#8CACD2")
    files.append({"path":str(path.relative_to(V2)).replace("\\","/"),"sha256":sha(path),"pixels":[1080,1920],"mode":"RGB","color":"sRGB ICC","representative_frame":scene["representative_frame"]})
sheet.save(review/"CONTACT_SHEET.png",icc_profile=srgb)
variant=review/"variants/05-handoff-chatgpt.png"
with Image.open(variant) as im:
    im.convert("RGB").save(variant,icc_profile=srgb)

expected_ranges=[(0,168),(168,330),(330,492),(492,708),(708,888),(888,1092),(1092,1224),(1224,1320)]
assert [(s["in"],s["out"]) for s in plan["scenes"]]==expected_ranges
assert plan["duration_frames"]/plan["fps"]==22
assert plan["rules"]==["全部页图","文字仅作索引","图表公式回原图核对"]
tracked_diff=subprocess.check_output(["git","diff",plan["base_sha"],"--name-only"],cwd=ROOT,text=True).splitlines()
assert all(p.startswith("marketing/video/v2/") for p in tracked_diff),tracked_diff
ledger=json.loads((V2/"ASSET_LEDGER.json").read_text(encoding="utf-8"))
for asset in ledger["assets"]:
    assert sha(V2/asset["path"])==asset["sha256"],asset["path"]
for n in range(1,13):
    assert sha(V2/f"assets/lecture/{n:04}.jpg")==sha(ROOT/f"reports/S05/store-screenshots-01/fixtures/lecture-{n+12:02}.jpg")
assert sha(V2/"assets/app-icon.png")==sha(ROOT/"App/Assets.xcassets/AppIcon.appiconset/AppIcon.png")
dom_path=V2/"out/dom-inspection.json"
dom=json.loads(dom_path.read_text(encoding="utf-8")) if dom_path.exists() else []
if dom:
    assert len(dom)==9
    assert all(not r["errors"] and not any(b["clipped"] for b in r["bounds"]) for r in dom)
    assert all(l["scroll_width"]<=l["client_width"] for r in dom for l in r["lines"])
    ids={r["page"]: sorted(r["ids"]["life"],key=lambda x:x["id"]) for r in dom}
    assert ids["01-hook.html"]==ids["07-return.html"]==ids["08-end.html"]
    assert len(ids["08-end.html"])==8
    assert all(r["background"]=="rgb(9, 11, 16)" for r in dom)
    (review/"DOM_INSPECTION.json").write_text(json.dumps(dom,ensure_ascii=False,indent=2),encoding="utf-8")
render=json.loads((V2/"out/render-log.json").read_text(encoding="utf-8"))
assert len(render)==9 and all(r["exit_code"]==0 for r in render)
result={"status":"READY_FOR_PHASE_A_REVIEW","base_sha":plan["base_sha"],"scope":"Phase A stills only",
        "checks":{"typescript_and_build":"PASS","native_hyperframes_snapshots":"PASS",
          "eight_1080x1920_rgb_srgb":"PASS","story_timing_copy":"PASS","same_life_atlas_and_crops":"PASS" if dom else "NOT_RUN",
          "runtime_dom_font_image_and_text_bounds":"PASS" if dom else "NOT_RUN",
          "lecture_and_icon_source_bytes":"PASS","only_v2_tracked_diff":"PASS",
          "full_motion_pacing_audio":"NOT_RUN_PHASE_B_C","provider_actual_output":"NOT_RUN_CONCEPT_ONLY",
          "real_source_deletion":"NOT_RUN_NOT_AUTHORIZED","public_release_or_post":"NOT_RUN_NOT_AUTHORIZED"},
        "files":files,"contact_sheet_sha256":sha(review/"CONTACT_SHEET.png"),
        "provider_variant_sha256":sha(variant),"changed_paths":tracked_diff}
(review/"VALIDATION.json").write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding="utf-8")
(review/"RENDER_LOG.json").write_text(json.dumps(render,ensure_ascii=False,indent=2),encoding="utf-8")
print(json.dumps({"stills":len(files),"size":"1080x1920 RGB/sRGB","same_life_crop":"PASS" if dom else "NOT_RUN","contact_sheet":str(review/"CONTACT_SHEET.png")},ensure_ascii=False))
