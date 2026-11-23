# Post-launch download end-card patch

Owner request 2026-11-23: verify the now-public App Store listing and repair the accepted bilingual promo download ending. Base: a0c925fc4120f39ef47df69b5874814189e13f94. Follow POST_LAUNCH_LINK_UPDATE.md; accepted source movies in review/director-r3-caption-male remain immutable.

Only locale-specific public product URLs, generated QR assets and the Chinese storefront search cue change. Narrative, timing, music, narration, provider examples and composition remain accepted. No App/Packages/store screenshots/ASC/TestFlight changes or public posting.

PUBLIC_AVAILABILITY.json and evidence/ contain Apple public lookup/product-page observations. The actual renderer reads PUBLISH_LINK.json live_destinations. scripts/post-launch-capture.mjs captures the unchanged paused GSAP timeline's ending using existing renderer assets/fonts; scripts/post-launch-cta.py patches only QR/search rectangles after frame 1230 in accepted movies with FFmpeg, preserving original AAC packets. Video encoding is repeated; do not claim whole-file or decoded-pixel identity. Old media and source audio are not overwritten. New masters/previews/muted exports, encoded-frame QR tests, preservation results and DELIVERY.md are this folder's handoff.

Stop READY_FOR_AUDIT. Public availability is separate from authorization to post; this request does not authorize publishing an advertisement or merging a PR.
