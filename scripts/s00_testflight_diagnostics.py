"""Print safe diagnostic categories from private Xcode signing logs.

Never print raw Apple account, certificate, provisioning or upload output.
"""

from pathlib import Path
import sys


text = Path(sys.argv[1]).read_text(errors="replace").lower()
categories = {
    "APP_RECORD_OR_BUNDLE_ID": ("no app record", "bundle identifier is not available", "bundle id"),
    "API_AUTHORIZATION": ("401", "403", "authentication failed", "not authorized"),
    "PROVISIONING_PROFILE": ("no profiles for", "provisioning profile"),
    "SIGNING_CERTIFICATE": ("no signing certificate", "signing certificate"),
    "APP_ICON": ("app icon", "appicon"),
    "UPLOAD_PROCESSING": ("upload failed", "could not upload", "processing"),
}
matched = [name for name, terms in categories.items() if any(term in text for term in terms)]
print("S00_PRIVATE_LOG_CATEGORIES=" + (",".join(matched) if matched else "OTHER"))
