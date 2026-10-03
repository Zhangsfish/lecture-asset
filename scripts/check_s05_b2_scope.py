"""Focused source contract, complementary to real Xcode/simulator evidence."""
import json
import re
import subprocess
from pathlib import Path

BASE = "b95af078d8eaba4da620107ecc15982682d7f309"
protected = ["App", ":!App/TutorialView.swift", ":!App/TutorialArtwork.swift", ":!App/Localizable.xcstrings",
             "AppResources", "schemas", "Packages", "project.yml",
             "scripts/s00_testflight_release.sh", ".github/workflows/s00-testflight.yml"]
changed = subprocess.check_output(["git", "diff", BASE, "--", *protected], text=True)
assert not changed, "Protected selection/processing/archive/share/delete source changed"
view = Path("App/TutorialView.swift").read_text(encoding="utf-8")
art = Path("App/TutorialArtwork.swift").read_text(encoding="utf-8")
assert '"tutorial.ai"' in view and 'Self.titles.count - 1' in view
assert all(x not in view + art for x in ["import Photos", "URLSession", "ShareLink", "UIActivityViewController",
                                       "UIApplication", "openURL", "WorkBuddy", "ChatGPT", "Kimi", "DeepSeek",
                                       "WKWebView", "AVPlayer", "StoreKit"])
assert "accessibilityReduceMotion" in view
assert "tutorial.aiVoice" in view and "allowsHitTesting(false)" in art
catalog = json.loads(Path("App/Localizable.xcstrings").read_text(encoding="utf-8"))["strings"]
expected = {"en": "Tap to select; press and drag to sweep, up to 200 photos.",
            "zh-Hans": "点按选择；长按并滑动可连续选择，最多 200 张"}
for language, text in expected.items():
    assert catalog["selection.hint"]["localizations"][language]["stringUnit"]["value"] == text
gesture = Path("App/PhotoGridView.swift").read_text(encoding="utf-8")
assert "press.minimumPressDuration = 0.15" in gesture
# Existing privacy, archive and exact cleanup contract stay byte-for-byte baseline.
print("S05_B2_SCOPE_PASS: copy/5 scenes/local artwork; protected sources unchanged")
