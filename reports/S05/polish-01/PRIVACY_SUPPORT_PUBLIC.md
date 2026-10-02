# Privacy and Support static pages

The finalized deploy-ready sources are `web/static/privacy.html` and `web/static/support.html`. They use only the owner-approved email `zhangs.taq@gmail.com` and homepage `https://zhang-shuo-portfolio.vercel.app/`. They explain on-device processing, separate share targets, omitted Live Photo motion/audio, explicit source deletion, destructive App-only cleanup and Recently Deleted behavior.

App About uses user-initiated mailto/external openURL and a copy-email fallback; it does not attach photos, OCR, logs or identifiers and does not preload the homepage. A read-only HTTP fetch of the homepage returned 200; the fetched HTML contained no payment-link keywords and linked the approved homepage/GitHub.

Hosting is not enabled by this PR. Deployment path: publish the exact `web/static` directory using GitHub Pages Actions, with read-only contents, Pages write and OIDC permissions; configure Pages source as GitHub Actions in repository Settings → Pages. The resulting support/privacy URLs must be verified anonymously after publication and only then entered into App Store Connect. No paid host, placeholder URL, metadata modification or account-setting change was performed. Public hosting remains BLOCKED_OWNER_ACTION.
