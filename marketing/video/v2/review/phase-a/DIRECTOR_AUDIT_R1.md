# PR #18 — director audit R1

Reviewed PR head: `125858df0675b9946ebd4752a127db0c6beee5ad`.
Reported tested authoring SHA: `bbb4265040dfa0e9c933538cf9734c35066e854b`.
Base main: `bf3a0c52d1678ce3eceedaff1a90ae982250b695`.

Verdict: **CHANGES_REQUESTED — source/composition review. No final visual acceptance.**
Next authorization: perform the corrections in `../../DIRECTOR_NEXT.md` and produce the complete R1 director animatic in this same PR. This is an explicit corrective-cut authorization, not a claim that the original Phase A passed visual review. Do not stop for another owner design decision. Do not merge or publish.

## Evidence inspected

- Actual PR metadata and both base→head and tested→head comparisons.
- Full `src/style-frames.ts` and `src/style.css`.
- README, SHOTLIST, delivery, test-result manifest and raw HyperFrames snapshot log.
- The GitHub comparison confirms all current changes are within `marketing/video/v2/` and the post-tested commit contains review/report outputs, not changed authoring source.
- The snapshot log reports successful individual still captures. These are not video playback or animation evidence.

## Visual inspection limitation

The contact-sheet PNG was retrieved through the connector as base64, but no rendered image pixels were exposed for inspection in this audit environment. Raw-file downloads failed. This audit does **not** claim that the contact sheet or eight original PNGs were visually viewed, or that the Windows rendering/font tests were independently rerun. Author assertions of visual quality are not substituted for a director's pixel review. The next delivery must expose the actual MP4 and compact visual review images as specified in DIRECTOR_NEXT.md; final visual acceptance remains open.

## Findings grounded in the source

### R1-01 — repeated poster layout is hard-coded

`head()` and `.headline` put essentially every scene at the same x=84/y=194, 96px heading; the eyebrow is repeated in every frame and the main objects generally start below y=640. The resulting structure reserves a large stable header band through most of the film. Revise the scene graph to use wide/macro/front-facing compositions and object-specific typography. Do not animate eight poster pages with identical entrances.

### R1-02 — the opening copy is overloaded by design

SHOTLIST assigns three separate subtitles to 2.8 seconds and defers the known reading problem to B. Resolve it now: two short beats, immediate recognition of lecture photos among personal pictures, no introductory sentence repeating the image.

### R1-03 — the archive climax is a set of disconnected panels

`anatomy()` places page thumbnails, OCR lines, a number grid and a README card in separate boxes. These represent the correct file roles but do not yet define the promised transformation of a single package. Keep the roles; replace the disconnected panel composition with one spatial stack that opens and reconnects to its same ZIP object. The reading rules should be brief legible annotations, not the visual main character.

### R1-04 — the receiving AI space and report lack product-specific meaning

`handoff()` uses an arbitrary orbital diagram and workspace skeleton. `result()` uses empty lines and a hard-coded rising line chart. Neither adds lecture-specific meaning. Replace the arbitrary orbit with the actual handoff of the archive; replace the decorative data trend with a conceptual argument/evidence structure based on the included lecture examples. The summary/report may be entirely editorial; do not label it a real provider transcript.

### R1-05 — the current animation source is intentionally still-only

Each generated HTML registers a 0.1-second empty GSAP tween. This is appropriate for A but provides no motion evidence. The next cut must animate persistent source objects and a single 22-second timeline. PNG fades, slideshows, or Ken Burns over the eight completed posters are not acceptable substitutes.

### R1-06 — international localization is not yet an international cut

The ChatGPT alternate only changes a provider name; `html()` and the scene text remain Chinese. The next deliverable must have a complete English text track plus the Chinese track on the same composition, not a provider-name swap presented as English localization.

### R1-07 — media readiness and delivery need to cover actual pixels

The photographic atlas is a CSS background and is not covered by `document.images.map(decode)`. Explicitly preload/decode CSS image textures as well as HTML images. The log also notes the atlas was not inlined. Package/reference it correctly; do not call the render self-contained when it depends on a missing local asset. Next delivery includes MP4, source-tied keyframes and small image proxies rather than only E-drive paths.

## Preserve

Story order, final Chinese slogan, source photo identity, accepted App icon, the distinction between PDF and AI ZIP, complete archive roles, existing locked renderer where usable, and all protected production paths. The entire v2 film remains a conceptual product promo; no owner recording, exact export/provenance retest, account login or v1 provider-evidence gate is required to render it.

Only the conceptual claim boundary remains: external AI is external; no measured speed/storage promises; no statement that the illustration is actual recorded provider output. This is not a request to restore a product tutorial.
