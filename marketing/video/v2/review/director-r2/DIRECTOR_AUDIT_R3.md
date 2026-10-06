# Director R3 audit — R2 changes required

Date: 2026-10-06.
Reviewed delivery: `374caad73650532d12685413a5447e119bf90959`.
Reported tested rendering source: `1e1aff951c7aef6c4218731f8fa6895e4f5960b8`.
Decision: **CHANGES_REQUIRED**. Execute `../../DIRECTOR_R3.md` on the same PR #18.

## Evidence actually inspected

Read the current PR and actual `src/r2.css`, `src/r2-timeline.ts`, `scripts/r2-score.py`, active workspace instructions and media inventory. Reconstructed and displayed two exact-byte EN composition proxies, checking their Git blob identities:
- `proxy/en/S03.jpg`: 3668 bytes, blob `40f943dd613646b4b63df0834ff24d2e4ebcd86b`.
- `proxy/en/AI-01.jpg`: 1949 bytes, blob `14784b2f36d9eee987f64a696c53804e3e85bad8`.

The owner watched/heard the full R2 films and supplied the aesthetic rejection. Independent acquisition/playback of the MP4s and subjective audio listening were not completed in this review environment. Proxy inspection establishes coarse composition only, not fine raster quality or a complete motion review. No listening PASS is claimed.

## Findings and decisions

### R3-01 — score is designed as ambience, not a short-form product launch

`r2-score.py` explicitly implements sparse warm decaying plucks, three low sine pads and occasional foley. It has no sustained drum groove or narration. Increasing gain or speeding up that file will not change its musical function. Replace its use in R3 with a new rhythm-led arrangement and separately mixed bilingual voiceover. Keep the old file for historical reproduction only.

### R3-02 — the main typography and the liked ending do not share a coherent display hierarchy

The actual font is not Arial: R2 binds Segoe UI Regular and Microsoft YaHei. In Chinese `.main-copy` uses weight 400 while `#slogan` uses 700; English only a real regular face is loaded. Declaring a family or removing caption rectangles did not produce a display typography system. The inspected S03 proxy still reads as small regular file labels beneath small objects in large empty space.

Use one explicit display-family/weight system for headline and ending in each locale, with deliberate line breaks, real font faces and font-render proof. Keep the ending's two-line rhythm/color hierarchy; carry that authority through the rest of the film. A new font alone is not sufficient: remove verbose duplicate copy and end punctuation from the visual title layer, align text to the hero composition, and allow it to rest.

### R3-03 — the CTA delay is an explicit previous director instruction

R2 shows slogan at 20.5s, brand at 20.8s and `#download` at 22.5s. This matches the previous R2 specification; it is not a Codex implementation accident. The owner has now rejected that rhythm. R3 replaces it with one fully composed end card at **frame 1230 / 20.5s**: slogan, icon/name, official badge, search cue and QR become visible together and hold through frame 1559.

### R3-04 — voiceover is a new required deliverable

The existing film has no spoken narrator. R3 must contain an actual Chinese narrator track in the WorkBuddy film and actual English narration in the ChatGPT film. Do not report a voiceover adapter or silent placeholder as completed narration. Use official preset-voice synthesis, not an unofficial TikTok endpoint, downloaded influencer speech or cloning a person.

### R3-05 — punctuation belongs to different layers

On-screen promotional type will omit sentence punctuation and use line breaks/spacing. TTS input retains punctuation needed for natural phrasing. Actual filenames, provider marks, official badges and accessibility transcripts are separate. This is our campaign decision, not a claim that Apple never uses punctuation.

## Retain

Story order, photo identities, lecture fixtures, app/provider icons, conceptual ZIP-send/AI-result exchange, separate PDF/ZIP, saved-before-cleanup and the download destination. Do not restart a new video direction, new rendering engine, provider-recording gate or real-device demo.

## Next result

Complete 26-second bilingual R3 with driving music, real narration, a unified typography system and simultaneous download end card. Complete the primary audio route or the approved local fallback before claiming narrated final delivery. Public availability remains a separate verification state; retain the launch CTA while a public-posting hold is unresolved.
