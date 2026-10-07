# Director review R2 — R1 is not visually approved

Reviewed delivery head: `9703ba0ea266f539b410eacf2fa2a24f7ca67028`.
Reported tested implementation: `99c455ac4d012ede22cc48091a2c430f99c263e6`.
Decision: **CHANGES_REQUIRED — implement DIRECTOR_R2.md on this same PR.**

## Evidence and review boundary

Read actual `src/director-html.ts`, `src/director.css`, `src/director-timeline.ts`, current task/PR metadata and review asset locations. Reconstructed and inspected the exact-byte EN S05 and S06 JPEG proxies, with Git blob identity checked:
- S05: 6312 bytes, Git blob `f6d4be358ca93f9b2adc99a0c2811837c16e51ab`.
- S06: 6183 bytes, Git blob `e0cc31799a5e924c27c2d607db536d237d5e08f6`.

These are low-resolution composition inspections, not full-resolution image-quality or full-motion/audio approval. Full MP4 acquisition/playback and independent listening were not completed in this review environment. The owner watched the delivered videos and explicitly rejected the style discontinuity and subtitle quality. This review does not relabel the producer's technical checks as a director quality PASS.

## Findings

### R2-01 — photographic scenes and desktop-like panels use incompatible design languages

`director.css` uses inset highlights on `#zip-cover`, saturated flat-blue file covers, rigid cream `#readme-layer` / `#report`, and 208px divider-based report rows. S06's inspected proxy reads as a software list/settings panel placed on top of scenic photography. This is editorially drawn HTML, not a real iOS popup; fix the artwork, not the App.

Remove faux-beveled window/file styling. Unify the photographs, dossier, reading layers, conversation and report with a single light direction, neutral paper, charcoal surroundings, restrained cobalt accents and contemporary spacing. A dark background alone does not establish cohesion.

### R2-02 — captions are overlays rather than designed typography

`.caption` gives nearly every line an opaque dark plate, padding, heavy type and rapid 0.10s reveal. Scene-specific overrides multiply sizes and positions. This competes with the objects and creates a patched-together subtitle look. Preserve the accepted final slogan as the typography reference; redesign earlier copy with no caption plates, fewer phrases, aligned negative space and readable holds.

### R2-03 — the AI handoff is a label, not an understandable exchange

`#destination` contains text only. S05 shows a ZIP floating below a huge provider name; the next scene makes a report appear independently. Add the correct official ChatGPT / WorkBuddy icon and a concise outgoing-ZIP → receiving-AI → generating → report interaction. The output surface must grow from the response, not open as an unrelated old-fashioned panel.

### R2-04 — there is no download action at the end

The existing end contains slogan, icon and product name only. The owner's new requirement explicitly supersedes the previous no-CTA instruction. Add a proper App Store download ending, direct product destination and same-phone search instruction. Keep production going while separately tracking whether the public listing is live; a registered Apple ID alone is not proof of public download availability.

### R2-05 — localization and visual continuity details

`director-html.ts` hardcodes `Meaning → example → question` inside every index strip for both locales. Localize or remove it. Do not keep the same dim life photographs as stationary wallpaper underneath every middle scene. Let them recede spatially and return for the final same-P01–P08 cleanup payoff.

## Retained

Keep the existing photographic atlas, lecture fixtures, app icon, narrative order, persistent-object timeline and working rendering pipeline. Retain the exact Chinese final slogan. Do not restore real-device captures, provider recording/export gates, or the earlier M00 illustration assets.

## Next authorized delivery

A complete high-fidelity R2 bilingual cut, with unified art direction, branded conceptual AI exchange, and download end card. New duration is 26 seconds / 1560 frames at 60fps to provide a readable interaction and CTA. Instructions are in `../../DIRECTOR_R2.md`.

No new owner design vote. No merge or posting. No App/Store/ASC/TestFlight mutation.
