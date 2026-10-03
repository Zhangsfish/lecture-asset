# S05-B2 visual review

## Baseline and design sequence
29.1 was functional but used one large gray demo container, dominant system icons
and discrete phase swaps. It did not visibly teach the 0.15-second press before
sweeping. Current task requires local teaching, not marketing.

First implementation builds five time-addressable native SwiftUI storyboard
states and renders them on GitHub-hosted macOS/iOS Simulator before final playback
timing. The production artwork itself is rendered, not a separate web mockup.
Static design source: c6475d5b1e529c6a4725b05ad5f64a251b194bc2, run 37102294248.
All five native images were inspected before playback source 618cbb4 was committed.

## Unified art direction
- White floating slide/file cards, cobalt primary and mint secondary identity.
- Local Canvas slide artwork: geometric diagrams, bars and text-like lines.
- Restrained shadow/depth; no large gray wrapper, no remote artwork/new SDK.
- Small title, illustration first, five-position indicator, pinned navigation.

## Five shots
1. Finger lands, a Hold label/ripple appears, then row sweep selects cards.
   Brief press precedes all sweep movement; real gallery recognizer is unchanged.
2. Distinct photos and tiny synthetic time labels move into chronological order;
   a misplaced fourth photo is tapped and exits. Three ordered cards remain.
3. Explicit Generate press, stack compresses, OCR-like lines briefly appear,
   two file cards separate with distinct ZIP/PDF colors.
4. ZIP enters a folder, external-save confirmation cue arrives, then two cleanup
   choices appear. These are decorative objects, never real delete controls.
5. Saved ZIP moves via an abstract sheet to an AI conversation; user prompt and
   a three-row illustrative result appear. Only generic “AI” and “Example” labels;
   no vendor logos/names and no claim about universal AI output capabilities.

## Accessibility and evidence limits
Reduce Motion shows the deterministic settled state with identical scene summaries.
Decorative artwork is hidden from individual VoiceOver traversal; each scene has
one localized description. Fixed-size illustration text belongs to vector artwork;
real title/navigation follow Dynamic Type and remain outside the illustration.
Large text can scroll while navigation stays pinned.

Automated checks cover rendering, five-page navigation, Skip/replay, permissions,
retained job precedence, Reduce Motion and XXXL reachability. Source inspection
checks scene labels/local-only imports and protects frozen processing sources.
Owner physical-device aesthetics, perceived pacing and physical VoiceOver remain
NOT_RUN; screenshots/CI are not substitutes for those judgments.

## Actual visual inspection / final evidence

Final source: `618cbb4fa25068f7d117c6da6007ad0e2aa96518`, green run 37103184270.

- `screenshots/scene-1.png` … `scene-5.png`: five Chinese native settled drawings.
- `screenshots/full-screen/`: five actual English production-screen screenshots,
  including Skip, indicator, navigation and Done only on the fifth scene.
- `screenshots/accessibility-xxxl/`: five static production-screen captures with
  Accessibility XXXL and Reduce Motion; navigation was hittable on every page.
  These tests capture immediately around page changes; transient native button
  label blending is visible in some captures, not claimed as settled typography.
- `animation/native-five-scenes.mp4`: 17.5 seconds, H.264, 780×1060, 20 fps;
  production time-addressable SwiftUI artwork, 3 seconds per shot plus 0.5-second
  evidence hold. Not an owner recording or a separate marketing animation.
- `animation/phases/`: thirty native per-phase screenshots (six per scene).
- `EVIDENCE_INDEX.json`: file size/hash, test, exact source and run provenance.

Inspected final pictures and frame progression:

1. At 0.6 s, finger is still on the initial tile, Hold/ripple is visible and the
   sweep has not selected later tiles. Hold runs about 0.45–0.68 s (0.23 s), then
   the soft turning sweep/check cascade progresses. No immediate-drag implication.
2. Cards actually travel from mixed positions, spring-settle into 09:00/09:02/09:04
   order; the fourth mistaken card receives a tap and leaves. Time labels are
   invented artwork, not photo metadata.
3. Generate press precedes stack compression; small text lines occupy the central
   processing node before two distinct paper files separate. Not an SF Symbol swap.
4. At 1.6 s the folder/save-confirmation cue exists with no cleanup choices; at
   2.1 s both paths appear below it. Final labels are readable and separate.
5. At 1.0 s the local abstract sheet and ZIP are visible; then a neutral AI chat,
   user request and three-line Example result settle. Preliminary duplicate ZIP
   overlap was removed. No brand marks, guaranteed-output promise or real action.

No gray all-in-one demo wrapper remains. Vector slide artwork, paper folds and
folder forms provide the objects; system symbols are only minor checks/cleanup
cues. Final full-screen shots keep the illustration as the focal point with
smaller headings and pinned navigation. Video orientation was checked against
an extracted first-shot frame; temporal phase progression was inspected through
native snapshots and movie frames. This is a developer visual review, not owner
approval of aesthetics or a physical-device usability certification.

## Owner/device boundary

Owner can use the new Internal preview to judge perceived rhythm/legibility and
physical VoiceOver. No owner 100/200-page processing, WeChat/vendor handoff or
destructive source cleanup test is requested. Actual full-screen simulator video
recording was not needed: deterministic native animation plus production UI
screenshots are supplied instead.
