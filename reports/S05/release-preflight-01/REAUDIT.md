# S05-D0 report-only re-audit

Status: **READY_FOR_REAUDIT**, awaiting independent review; no merge.
Reviewed head: `ab811e713e5f1a71b42343e7fcb9f52ded858192`.
Latest main fetched again2026-10-03: `43e669b59f3a6135d21286bdecaa0444104b0575`, unchanged. PR10 open, Ready for review; one independent COMMENTED review requests two report corrections, no issue/inline comments at this check.

## Corrections

- US.md: official [current Utah Chapter13-76](https://le.utah.gov/xcode/Title13/Chapter76/C13-76_2025050720250507.pdf) fully text-read. Section13-76-202(1)–(6) uses2027-05-06, marked amended Chapter157,2026 General Session. Same timetable in13-76-201/401. Older Apple February news and2025 URL filename are not controlling current timetable. Statutory timing confirmed; other US applicability/enforcement/platform gates still unresolved. Attempted web PDF screenshot could not resolve content type; no rendered PDF verification claimed, text evidence is sufficient for date correction.
- CHINA.md: [MIIT105](https://www.miit.gov.cn/zwgk/zcwj/wjfb/tz/art/2023/art_920db564162e4312916a01bed6540ad8.html) and [government-site practical FAQ](https://wxb.xzdw.gov.cn/qwfb/zyjs/202310/t20231018_406352.html) read. FAQ's complete-offline/link risk statement is in its hardware-companion context; separate SDK nuance retained. Government publication credits Guangming, not a product-specific ministry decision. With actual developer homepage/support/mail/system sharing, record **STRONG_FILING_RISK / LIKELY_RELEASE_BLOCKER_PENDING_AUTHORITATIVE_CLASSIFICATION**, not legal certainty or exemption.
- Original [MIIT interpretation URL](https://www.miit.gov.cn/jgsj/xgj/hlwgl/art/2023/art_564bf0759d7e41d5b4aa8ce4996b9e84.html) timed out twice; same-title [Shandong Communications Administration official publication](https://sdca.miit.gov.cn/zwgk/zcwj/zcjd/art/2023/art_d2403c10b72d48dcb944df6d8e44ee82.html) read as transparent fallback. No false original-fetch PASS.
- TEST_RESULTS.json/DELIVERY.md inherit corrected risk/timing. RC_PLAN.md confirms target0.1.0 from baseline; ASC1.0 is a reconciliation task, not an owner version choice.
- OWNER_RELEASE_DECISION.md and OWNER_PORTAL_CHECKLIST.md: technical facts prefilled from retained evidence; at most8 bundled owner response groups, unknowns blank, legal/contact values private. Read-only portal navigation distinguishes app-info and version page. Manual release default prefilled; distribution RC NOT YET AUTHORIZED; Review DO NOT SUBMIT.

## Actual checks and retained evidence

Local Windows PowerShell / existing F:/anaconda3/python.exe; no install. Actual commands:

```powershell
git -c http.proxy= -c https.proxy= fetch origin main
git diff ab811e713e5f1a71b42343e7fcb9f52ded858192 --name-only
F:/anaconda3/python.exe .git/d0_reaudit_check.py
F:/anaconda3/python.exe scripts/s05_d0_check_release_prep.py
git diff --check
```

Local checker: report JSON parses; updated Utah/China/result/form contracts; Markdown local file links resolve; all5 screenshot bytes match the committed SHA256 index and reviewed head; protected App/resources/packages/schema/project objects match reviewed head; every staged change is under this report directory. PASS. Local helpers under.git are not product/tests delivered to CI.

CI/read-only ASC/public HTTP/screenshots/icon evidence from first delivery is retained **as dated evidence**, not a new execution claim. No new workflow dispatch, TestFlight, release build, ASC API query or private portal action this revision. Prior accepted runtime/CI and source identity remain unchanged. No photo/device/share/destructive retest; no snapshot update or screenshot regeneration.

Owner portal/legal fields remain NOT_CHECKED/UNRESOLVED/BLOCKED_OWNER_ACTION until genuinely answered. Form is prepared, not owner-approved. Neither selecting a proposed storefront nor approving copy automatically authorizes portal mutation, RC upload, Review or public release. Final report head is recorded in PR handoff; this report revision does not invalidate accepted runtime code but itself requires re-audit.
