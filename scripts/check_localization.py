"""Audit the two supported catalogs and UI key references without running iOS."""
import argparse
import collections
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]


def audit():
    catalog = json.loads((ROOT / "App/Localizable.xcstrings").read_text(encoding="utf-8"))
    strings = catalog["strings"]
    sources = {str(p.relative_to(ROOT)): p.read_text(encoding="utf-8")
               for p in sorted((ROOT / "App").glob("*.swift"))}
    combined = "\n".join(sources.values())
    missing, untranslated, extra = {}, {}, {}
    counts = {}
    for locale in ("en", "zh-Hans"):
        missing[locale] = [k for k, v in strings.items()
                           if not v.get("localizations", {}).get(locale, {}).get("stringUnit", {}).get("value")]
        untranslated[locale] = [k for k, v in strings.items()
                                if v.get("localizations", {}).get(locale, {}).get("stringUnit", {}).get("state") != "translated"]
        counts[locale] = len(strings) - len(missing[locale])
    for key, value in strings.items():
        others = set(value.get("localizations", {})) - {"en", "zh-Hans"}
        if others:
            extra[key] = sorted(others)
    referenced = set(re.findall(r'"((?:app|permission|selection|confirm|common|processing|archive|export|about|tutorial)\.[A-Za-z]+)"', combined))
    referenced.discard("archive.json")  # Private checkpoint filename, not a UI key.
    duplicates = {}
    for locale in ("en", "zh-Hans"):
        groups = collections.defaultdict(list)
        for key, value in strings.items():
            groups[value["localizations"][locale]["stringUnit"]["value"]].append(key)
        duplicates[locale] = [keys for keys in groups.values() if len(keys) > 1]
    result = dict(supported_locales=["en", "zh-Hans"], total_keys=len(strings),
                  localized_counts=counts, missing=missing, not_translated=untranslated,
                  unsupported_locales=extra, missing_referenced_keys=sorted(referenced - strings.keys()),
                  unused_in_app=sorted(strings.keys() - referenced), duplicate_values=duplicates,
                  same_value_in_both=[key for key, value in strings.items()
                                     if value["localizations"]["en"]["stringUnit"]["value"] ==
                                     value["localizations"]["zh-Hans"]["stringUnit"]["value"]])
    assert catalog["sourceLanguage"] == "en"
    assert not any(missing.values()) and not any(untranslated.values()) and not extra
    assert not result["missing_referenced_keys"]
    for locale, name in (("en", "Lecture Asset"), ("zh-Hans", "Lecture Asset")):
        info = (ROOT / f"App/{locale}.lproj/InfoPlist.strings").read_text(encoding="utf-8")
        assert f'"CFBundleDisplayName" = "{name}";' in info
        assert '"NSPhotoLibraryUsageDescription"' in info
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    data = json.dumps(audit(), ensure_ascii=False, indent=2) + "\n"
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(data, encoding="utf-8")
    else:
        print(data)
