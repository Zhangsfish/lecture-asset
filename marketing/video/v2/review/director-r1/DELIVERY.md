# Director R1 — full bilingual cut

**READY_FOR_DIRECTOR_CUT_REVIEW** · PR #18, same branch. Not final visual approval.

## Source and authority

- Original PR base: bf3a0c52d1678ce3eceedaff1a90ae982250b695.
- Latest fetched main at start: 4995c1d0d70ebdf3712416bf96ee31219fc67720.
- Director branch input: 89c705d495deacd506ae1db6d19516c2b723f137.
- Render authoring source: 99c455ac4d012ede22cc48091a2c430f99c263e6.
- Tested implementation/presentation validation: 99c455ac4d012ede22cc48091a2c430f99c263e6.
- DIRECTOR_NEXT.md is the sole current directive. Phase A and its audit remain unchanged.
- No main/other-PR merge or cherry-pick. All new changes are within marketing/video/v2/.

## Delivery

Four MP4 files in this directory: English / ChatGPT and zh-Hans / WorkBuddy,
each with score and a corresponding muted copy. Each video is 720×1280,
60fps, 1320 frames, 22.000 seconds. Authoring canvas is 1080×1920.

CONTACT_SHEET.jpg is English; CONTACT_SHEET_ZH.jpg is Chinese. keyframes/ has
eight native 1080×1920 timeline captures per language. TRANSITIONS-* samples
both continuous halves at scene boundaries and states. proxy/ contains
180×320 JPEG review images, each ≤8192 bytes, with exact base64 wrapped at
120 characters. Source/proxy hashes and frame positions are in TIMELINE.json.

These images are review outputs, never animation input. One paused GSAP timeline
animates stable P01–P08, L01–L12, the same ZIP sleeve, independent PDF, index,
mapping, reading layer and report. The atlas, source lecture JPEGs, icon and
their hashes are unchanged. All asset URLs inside the composition are relative;
installed fonts are locally copied, ignored and not redistributed.

## R1 findings addressed

| Finding | Concrete implementation |
|---|---|
| R1-01 | Mixed-photo wide space → ordered tracking → sleeve close approach → inside fan → frontal report → relaxed album. Caption positions follow scenes; no repeated eyebrow. |
| R1-02 | Two intro captions only; first frame is mixed photos, foreground wipe completes in 21 frames. |
| R1-03 | The same sleeve releases source pages, paired index strips, page-mapping lines and a thin reading layer, then folds back. |
| R1-04 | No orbit, empty webpage, placeholder bars or invented rising chart. External provider is a plain named concept space. Report uses meaning/example/question from actual synthetic lecture bullets. |
| R1-05 | 22-second native object/camera timeline, not eight finished PNGs. Original score and six sound-effect voices / seven cues are synchronized to frame clock. |
| R1-06 | English captions, rules, result text, saved cue and slogan are fully English. Chinese source-index English wording remains user-document content, not fake translated App UI. |
| R1-07 | Explicit font loading, HTML image decode and CSS atlas decode complete before timeline registration; asset readiness and actual encoded frames are checked. |

## Internal review and two focused corrections

1. Moved the reading layer below the sleeve, retained all three readable rules,
   eliminated the mirror-written cover back, and checked the computed seek state
   rather than nonvisual CSS property insertion order.
2. Kept the sleeve front readable during external handoff (32° opening), sampled
   S05 at frame 822 after its source fan unfolds, and aligned the report's third
   section label to Conclusion / 结论. No third redesign round.

Internal visual inspection used actual timeline temporal samples and decoded MP4
frames, including S01–S04 and S05–S08 sequences; not an assertion of real-time
human playback. Captions were inspected at 360px-equivalent preview scale.
Both end lines settle before frame 1182 and remain still; Saved appears before
any source-page departure. Original P01–P08 identity/crop remains at both ends.

## Actual checks and limits

See QA.json for actual commands and measurements:

- TypeScript/build and dual-language DOM, resource, safety-zone and shuffled
  forward/reverse seek checks pass.
- ffprobe verifies each delivered video's exact frames/fps/dimensions/duration;
  all frames/audio decode. Sound copies contain one audio track, muted copies none.
- Decoded audio has no clipped samples; local source peak is −11.56 dBFS.
- All 30 encoded temporal samples per language match corresponding native
  timeline captures within explicit lossy H.264/GPU tolerance.
- HyperFrames 0.8.132 reports a sub_timeline_readiness_timeout in preflight.
  This warning is retained in QA.json, not suppressed or presented as a clean log.
  Actual frame 0 and 29 further samples show the ready timeline, fonts and atlas;
  no encoded sample fails comparison. Full video decode succeeds.
- Original asset hashes and untouched Phase A history verified; protected paths
  unchanged. App / Packages / screenshots / ASC / TestFlight / other PRs untouched.
- **Human audio listening: NOT_RUN. Director final visual approval: NOT_RUN.**
  No provider recording or real generation claim: report is labeled illustrative
  and derives from the safe synthetic lecture. No account, private photo,
  destructive deletion, paid service or promotional publication was used.

No blocking environment issue remains. Stop for director review; no Phase C,
merge, self-approval, store publication or next task.
