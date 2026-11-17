"""Build native installers for the publicly distributed free companion."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import plistlib
import shutil
import subprocess
from zipfile import ZipFile

EXPECTED = {
    "win-x64": "f0f8d34287cc69af4224d652b4081a6e26f8520384464e6c1cb29ee630e27794",
    "darwin-arm64": "15ae8e787713647534b784a2bc31673381e66d14ff660f5ea4238f1cabcc00ac",
    "darwin-x64": "622266f6b451149f2b1ea59bcffa85a8e24a2388ff906bd2d9abb01dda99c179",
}


def build(target, archive, output):
    source = Path(__file__).resolve().parent
    output = output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    digest = hashlib.sha256(archive.read_bytes()).hexdigest()
    if digest != EXPECTED[target]:
        raise RuntimeError("The free companion source package checksum differs from the pinned release.")
    stage = output / ("stage-" + target)
    stage.mkdir()
    with ZipFile(archive) as package:
        for info in package.infolist():
            destination = (stage / info.filename).resolve()
            if not destination.is_relative_to(stage):
                raise RuntimeError("The package member is outside the staging folder.")
            package.extract(info, stage)
            mode = info.external_attr >> 16
            if mode and destination.is_file():
                destination.chmod(mode & 0o777)
    payload = stage / "codex-project-chat-sort"
    runtime_version = json.loads((payload / "assets/runtime/package.json").read_text())["version"]
    if runtime_version != "0.3.0-rc.4":
        raise RuntimeError("Unexpected companion version")
    if target == "win-x64":
        compiler = shutil.which("makensis") or str(Path(os.environ.get("ProgramFiles(x86)", "C:/Program Files (x86)")) / "NSIS/makensis.exe")
        product = output / "Codex-Sidebar-Sort-Windows-x64-Setup.exe"
        subprocess.run([compiler, "/V3", "/DPAYLOAD=" + str(payload), "/DOUTPUT=" + str(product), str(source / "windows.nsi")], cwd=source, check=True)
    else:
        app_stage = stage / "disk"
        app_stage.mkdir()
        app = app_stage / "Install Codex Sidebar Sort.app"
        resources = app / "Contents/Resources"
        executable = app / "Contents/MacOS/Installer"
        executable.parent.mkdir(parents=True)
        resources.mkdir()
        architecture = "arm64" if target.endswith("arm64") else "x86_64"
        subprocess.run(["/usr/bin/swiftc", "-O", "-target", architecture + "-apple-macosx12.0", str(source / "MacInstaller.swift"), "-o", str(executable)], check=True)
        shutil.copytree(payload, resources / "payload")
        for name in ("mac-installer.mjs", "mcp-registration.mjs", "INSTALL.en.md"):
            shutil.copy2(source / name, resources / name)
        for bundle, role in ((app, "install"), (resources / "Uninstaller.app", "uninstall")):
            (bundle / "Contents/MacOS").mkdir(parents=True, exist_ok=True)
            (bundle / "Contents/Resources").mkdir(exist_ok=True)
            if role == "uninstall":
                shutil.copy2(executable, bundle / "Contents/MacOS/Installer")
            info = {
                "CFBundleExecutable": "Installer", "CFBundleIdentifier": "io.github.codex-sidebar-sort." + role,
                "CFBundleName": "Codex Sidebar Sort", "CFBundlePackageType": "APPL",
                "CFBundleShortVersionString": "0.3.0", "CFBundleVersion": "0.3.0.4",
                "LSMinimumSystemVersion": "12.0", "NSHighResolutionCapable": True,
                "SorterRole": role,
            }
            with (bundle / "Contents/Info.plist").open("wb") as handle:
                plistlib.dump(info, handle)
        shutil.copy2(source / "INSTALL.en.md", app_stage / "INSTALL.en.md")
        product = output / ("Codex-Sidebar-Sort-Mac-" + ("Apple-Silicon" if target.endswith("arm64") else "Intel") + ".dmg")
        subprocess.run(["/usr/bin/hdiutil", "create", "-volname", "Codex Sidebar Sort", "-srcfolder", str(app_stage), "-format", "UDZO", str(product)], check=True)
    result = {
        "installerVersion": "0.3.0-setup.1", "companionVersion": runtime_version,
        "target": target, "file": product.name, "bytes": product.stat().st_size,
        "sha256": hashlib.sha256(product.read_bytes()).hexdigest(),
        "sourcePackageSha256": digest, "bundledNode": True, "paidSkillIncluded": False,
        "commercialCodeSigning": False, "nativeInstallerLifecycle": "pending",
        "authenticatedNativeSorting": "pending-independent-cloud-login",
        "run": os.environ.get("GITHUB_SERVER_URL", "https://github.com") + "/" + os.environ.get("GITHUB_REPOSITORY", "") + "/actions/runs/" + os.environ.get("GITHUB_RUN_ID", ""),
    }
    (output / (target + "-installer.json")).write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result), flush=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--target", choices=EXPECTED, required=True)
    parser.add_argument("--zip", type=Path, required=True)
    parser.add_argument("--out", type=Path, required=True)
    options = parser.parse_args()
    build(options.target, options.zip, options.out)
