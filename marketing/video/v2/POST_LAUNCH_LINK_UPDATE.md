# Owner acceptance and post-launch end-card update

Owner accepted the current bilingual film and explicitly authorized merging PR #18 on 2026-10-07.
Accepted delivery head: `99145299cf3ad8008e1ce293a140a601cb02de1d`.
Rendered/tested implementation: `cdfd6a22b7153d0e631e3383be42446b9192d5b1`.
Accepted outputs: `review/director-r3-caption-male/`.

## Required follow-up after public App Store launch

**OPEN / REQUIRED BEFORE PUBLIC VIDEO DISTRIBUTION**

The owner explicitly requires replacing the final-scene download link after the App is publicly live. The current end-card QR encodes `https://apps.apple.com/us/app/id6816814541`; that registered-ID destination is not evidence that the App can currently be downloaded.

1. Obtain and verify the actual live Lecture Asset App Store product link for each intended region. Confirm App ID `6816814541` and product identity; no automatic storefront change.
2. Replace the end-card link and regenerate its QR in both Chinese and English versions. Update `PUBLISH_LINK.json` and the renderer's actual QR input, rather than changing report text alone. If the verified final URL is identical, record that evidence explicitly and verify the QR against it.
3. Re-export every release/distribution variant using that end card, including masters, previews and muted variants; preserve accepted story, voice and visuals.
4. Decode the QR from actual exported end-card frames at1080 and720, and verify the destination opens the correct publicly downloadable App. Record verified URL, lookup date, decoded payload and new output hashes.
5. Do not mark public availability verified or distribute the film until that check is complete. Public posting still requires separate owner authorization.

This merge does not authorize App Review, ASC/storefront changes, TestFlight upload or publication. Existing public-availability evidence remains unconfirmed; no account or listing changes were made.
