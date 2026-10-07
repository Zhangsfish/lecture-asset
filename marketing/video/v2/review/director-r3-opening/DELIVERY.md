# Owner opening revision — complete narrated films

**READY_FOR_DIRECTOR_FINAL_REVIEW**. Same PR #18. Prior R3 media remain unchanged.

## Exact source

Owner revision base: `a5a2e8bdab27c04bd0feb5636f0a649f29eebfe8`. Exact tested/rendered implementation: `2b682774ab422d598c9a86a2f784245ee1c4f230`. Latest main fetched during this revision: `df7755abea679fc776959fa0843c625428034541`. Separate final evidence commit; rendered HTML/CSS/JS byte-identical after final status-only update (RENDER_INPUT_FREEZE.json); packaging validation baseline corrected to owner-revision base, without motion/visual/audio changes.

## What changed

First frame shows only the original P01–P08 life photos. At about0.63s the same L01–L12 lecture pages start arriving from outside the frame, displacing the life photos. By about2.89s the album has become the earlier cluttered composition. The same objects subsequently extract and sort; no flattened scene PNG is used as video input.

Opening expanded to4.2s after measuring full narration. Early/middle beats retimed on the same paused GSAP master timeline. Full film remains26s/1560f/60fps; saved-before-cleanup remains; all six end-card components still appear together at1230f/20.5s. P01–P08 at the end are the original set. Same HyperFrames/TypeScript/GSAP/HTML/CSS/FFmpeg chain, original materials/assets/fonts/provider icons and later story.

## Complete opening narration

The previous R3 shortened N01 to fit a2.75s window. This revision restores both clauses instead of condensing words. Chinese uses owner wording“又太麻烦”. N01 regenerated using existing pinned stock-voice Qwen3-TTS; N02–N07 waveforms reused with measured placements. No cloud purchase, cloning, silent voice or word cut.

| Locale | Actual full sentence | Duration(s) | Starts(s) | Ends(s) |
|---|---|---:|---:|---:|
| en | Lecture photos everywhere. Too scattered for AI. | 3.724958 | 0.15 | 3.874958 |
| zh-Hans | 照片塞满相册，交给 AI 又太麻烦。 | 4.000583 | 0.15 | 4.150583 |

14/14 actual WAV phrases independently recognized after normalization. More importantly, opening AAC decoded directly from both final MP4s is independently transcribed in OPENING_AUDIO_CHECK.json; both initial and final clauses are present, before N02 at4.3s. This confirms final-file completeness, not subjective pronunciation/taste approval.

## Complete media

1080×1920 narrated masters;720×1280 narrated previews; both muted sizes. All8 films decode fully with correct26s/1560frames/60fps and audio counts.

| File | Bytes | SHA256 |
|---|---:|---|
| director-cut-en-chatgpt.mp4 | 11406427 | `b6cb5faf793cfb94caa65e38382b14a7a73ed46a523fb242ddcc866a6f4c0fa7` |
| director-cut-en-chatgpt-muted.mp4 | 10751891 | `c422b222680812ed7bc4464716d003d74e413e761dd4f55af033aae28b8666b7` |
| director-cut-en-chatgpt-720.mp4 | 3986663 | `9e3c7bb5532a928cc6cbeab8108a2eb2562b8ddc5ed208ff99dd02a58107b467` |
| director-cut-en-chatgpt-720-muted.mp4 | 3436068 | `373ef622f1ce0597ed59d7bc2e044faf414e712c001a9ac66f84ccf207d11747` |
| director-cut-zh-workbuddy.mp4 | 11335502 | `332548939036257164a196f41b4d1f12a9b281fd8286776364f4211e7b20b3fa` |
| director-cut-zh-workbuddy-muted.mp4 | 10680882 | `d7c3c0e1219cd1da2bf2f3c24745c27503c2031da565a0c90023a816e0b59683` |
| director-cut-zh-workbuddy-720.mp4 | 3984967 | `cade2399a30bf4ab90235163ee93f42cd1c5e894d89a0cc7febd4fbaacff5061` |
| director-cut-zh-workbuddy-720-muted.mp4 | 3435041 | `444dbecebb889e0d5c767b080946b283f84027a40d36ae029d2db1023a788981` |

OPENING_SEQUENCE_EN/ZH.jpg and CONTACT_SHEET_EN/ZH.jpg come from encoded movies. Opening/middle/ending text contact, four AI handoff frames and end-card onset/sequence retained. Original phase-a/director-r1/director-r2/director-r3 media unchanged.

## Actual validation and limits

Build/typecheck, zero-error HF lint, actual platform fonts, shuffled seek determinism, life-only first frame, completed influx, clipping/safe bounds, report hold, saved-before-departure and simultaneous tail PASS.86 decoded/native samples checked. QR independently decoded from both resolutions/locales. Every original asset hash unchanged. Actual final AAC correlates with new narrated mix; integrated loudness/true-peak measured. Music remains original132BPM drums/bass,7.5dB voice ducking, retimed accents.

Producer inspected opening progression and actual encoded contact/transition frames. Director aesthetic approval pending. **Subjective listening/narration naturalness/phone-speaker listening: NOT_RUN**; automated ASR and signal checks do not replace hearing.

**Public download availability: UNCONFIRMED**, inherited PUBLISH_HOLD_NOT_LIVE_VERIFIED; no public posting authorized or performed. No App/Packages/store screenshots/ASC/TestFlight/real photo deletion/publishing/merge. Primary RC workspace and its uncommitted work were preserved by using a separate same-branch Git worktree. No owner account/recording action required.
