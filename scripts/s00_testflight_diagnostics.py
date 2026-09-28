"""Print safe diagnostic categories from private Xcode signing logs.

Never print raw Apple account, certificate, provisioning or upload output.
"""

from pathlib import Path
import re
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

# Keep only fixed vocabulary from Xcode error lines. All names, identifiers,
# paths, addresses, tokens and unknown text become one redaction marker.
safe_words = set("""
error exportarchive no matching profiles profile provisioning for were found
cloud managed signing sign signed unsigned archive apple distribution
certificate certificates app store connect development identity team account
permission access denied not authorized available unavailable missing
failed fail could cannot unable create created use using automatic manually
requires required is are was has have with this the a an to of and or
valid invalid expired revoked existing local remote key authentication
service request server network response unable code entitlement bundle id
""".split())
safe_lines = []
for line in text.splitlines():
    if "error:" not in line and "cloud signing" not in line and "no profiles for" not in line:
        continue
    words = re.findall(r"[a-z]+", line)
    filtered = []
    for word in words:
        safe = word if word in safe_words else "[redacted]"
        if safe != "[redacted]" or not filtered or filtered[-1] != safe:
            filtered.append(safe)
    summary = " ".join(filtered[:45])
    if summary and summary not in safe_lines:
        safe_lines.append(summary)
    if len(safe_lines) == 6:
        break
for index, line in enumerate(safe_lines, start=1):
    print(f"S00_PRIVATE_ERROR_TERMS_{index}={line}")
