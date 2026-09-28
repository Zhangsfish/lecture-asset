"""Print safe diagnostic categories from private Xcode signing logs.

Never print raw Apple account, certificate, provisioning or upload output.
"""

from pathlib import Path
import sys


text = Path(sys.argv[1]).read_text(errors="replace").lower()
categories = {
    "APP_RECORD_OR_BUNDLE_ID": ("no app record", "bundle identifier is not available"),
    "API_AUTHORIZATION": ("http 401", "http 403", "authentication failed", "not authorized", "permission denied"),
    "DEVELOPMENT_CERTIFICATE_MISSING": (
        'no signing certificate "apple development"',
        'no signing certificate "ios development"',
        "no signing certificate matching",
    ),
    "DISTRIBUTION_CERTIFICATE_MISSING": (
        'no signing certificate "apple distribution"',
        'no signing certificate "ios distribution"',
    ),
    "NO_REGISTERED_DEVICE": ("team has no devices", "no devices are registered"),
    "NO_MATCHING_PROFILE": ("no profiles for", "no matching provisioning profiles"),
    "PROFILE_CREATION_FAILED": ("failed to create provisioning profile", "could not create a provisioning profile"),
    "PROFILE_CAPABILITY_MISMATCH": ("provisioning profile doesn't include", "provisioning profile does not include"),
    "PROVISIONING_PROFILE_OTHER": ("provisioning profile",),
    "UNSIGNED_ARCHIVE_REJECTED": (
        "archive is not signed", "archive was not signed", "unsigned archive",
        "archive does not contain a signed", "not a valid archive",
    ),
    "CLOUD_SIGNING_ISSUE": ("cloud signing", "cloud-managed certificate"),
    "APP_ICON": ("app icon", "appicon"),
    "UPLOAD_PROCESSING": ("upload failed", "could not upload", "processing"),
}
matched = [name for name, terms in categories.items() if any(term in text for term in terms)]
print("S00_PRIVATE_LOG_CATEGORIES=" + (",".join(matched) if matched else "OTHER"))
