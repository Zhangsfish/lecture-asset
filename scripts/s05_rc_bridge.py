"""Disposable ad-hoc entitlement context; never a shippable distribution App.

All command output stays in memory. Publish only fixed safe diagnostics.
"""
import hashlib
import json
from pathlib import Path
import plistlib
import subprocess
import sys


def run(args):
    result = subprocess.run(args, capture_output=True)
    if result.returncode:
        raise RuntimeError("bridge command failed")
    return result


def tree_hash(root):
    digest = hashlib.sha256()
    for path in sorted(root.rglob("*")):
        digest.update(str(path.relative_to(root)).encode())
        if path.is_symlink():
            digest.update(b"LINK" + path.readlink().as_posix().encode())
        elif path.is_file():
            with path.open("rb") as file:
                digest.update(hashlib.file_digest(file, "sha256").digest())
    return digest.hexdigest()


def nested_code(app):
    # Sign actual code, not Swift package resource bundles. Reject extensions
    # requiring independent entitlement decisions instead of inventing values.
    bundles = []
    for path in app.rglob("*"):
        if path.is_symlink() or not path.is_dir():
            continue
        if path.suffix in (".appex", ".app", ".xpc"):
            raise RuntimeError("unexpected independently entitled nested bundle")
        if path.suffix == ".framework":
            bundles.append(path)
    loose = []
    magic = {b"\xfe\xed\xfa\xce", b"\xce\xfa\xed\xfe", b"\xfe\xed\xfa\xcf",
             b"\xcf\xfa\xed\xfe", b"\xca\xfe\xba\xbe", b"\xbe\xba\xfe\xca"}
    info = plistlib.loads((app / "Info.plist").read_bytes())
    main = app / info["CFBundleExecutable"]
    for path in app.rglob("*"):
        if not path.is_file() or path.is_symlink() or path == main:
            continue
        if any(parent in bundles for parent in path.parents):
            continue
        with path.open("rb") as file:
            if file.read(4) in magic:
                loose.append(path)
    return sorted(bundles + loose, key=lambda p: len(p.parts), reverse=True)


def main():
    original, bridge, entitlements, output = map(Path, sys.argv[1:])
    result = {"bridge_signing": "FAIL", "bridge_archive_signed_age": "missing",
              "bridge_signature_type": "UNCONFIRMED", "shippable": False,
              "signing_uses_deep": False, "original_archive_unchanged": False}
    before = tree_hash(original)
    try:
        if bridge.exists() or original.resolve() == bridge.resolve():
            raise RuntimeError("copy must be new and distinct")
        existing = plistlib.loads(entitlements.read_bytes())
        if existing.get("com.apple.developer.declared-age-range") is not True:
            raise RuntimeError("existing entitlement missing")
        run(["ditto", str(original), str(bridge)])
        app = bridge / "Products/Applications/Lecture Asset.app"
        nested = nested_code(app)
        result["nested_code_count"] = len(nested)
        for path in nested:
            run(["codesign", "--force", "--sign", "-", str(path)])
        run(["codesign", "--force", "--sign", "-", "--entitlements", str(entitlements), str(app)])
        # --deep is verification only, never signing.
        run(["codesign", "--verify", "--deep", "--strict", str(app)])
        signed = plistlib.loads(run(["codesign", "-d", "--entitlements", ":-", str(app)]).stdout)
        detail = run(["codesign", "-dv", "--verbose=4", str(app)]).stderr
        result["bridge_archive_signed_age"] = signed.get("com.apple.developer.declared-age-range") is True
        if not result["bridge_archive_signed_age"] or b"Signature=adhoc" not in detail:
            raise RuntimeError("bridge entitlement/signature mismatch")
        result.update(bridge_signing="PASS", bridge_signature_type="ad-hoc", codesign_verification="PASS")
    except Exception:
        result.update(bridge_signing="FAIL", failure_code="ADHOC_ENTITLEMENT_BRIDGE_FAILED")
    finally:
        result["original_archive_unchanged"] = before == tree_hash(original)
        if not result["original_archive_unchanged"]:
            result.update(bridge_signing="FAIL", failure_code="ADHOC_ENTITLEMENT_BRIDGE_FAILED")
        output.write_text(json.dumps(result, indent=2) + "\n")
    print("S05_RC_BRIDGE_" + result["bridge_signing"])
    sys.exit(0 if result["bridge_signing"] == "PASS" else 1)


if __name__ == "__main__":
    try:
        main()
    except Exception:
        print("ADHOC_ENTITLEMENT_BRIDGE_FAILED")
        sys.exit(1)
