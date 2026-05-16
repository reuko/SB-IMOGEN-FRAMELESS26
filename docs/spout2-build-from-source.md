# Building Spout2_DX12 Plugin from Source (UE 5.3)

## The Problem

UE 5.3's build tool (UBT) checks `_MSC_VER` and rejects any MSVC compiler newer than **14.39** (Visual Studio 2022 17.9). Recent VS 2022 updates and VS 2026 ship with MSVC 14.44+ which breaks UE 5.3's engine headers (`ConcurrentLinearAllocator.h` uses `__has_feature`, a Clang-only builtin that newer MSVC now warns about — and UE treats warnings as errors).

## What You Need

### 1. Visual Studio 2022 (any edition)
Community, Professional, or Build Tools — doesn't matter, but it must be a **VS 2022** install (not VS 2026). UE 5.3's UBT only looks for toolchains under VS 2022 installations.

### 2. Required VS 2022 Individual Components
Open **Visual Studio Installer** → Modify VS 2022 → **Individual Components** tab:

- ✅ **MSVC v143 - VS 2022 C++ x64/x86 build tools (v14.38-17.8)** — this is the critical one
- ✅ **Windows 10 SDK** (any recent version, e.g. 10.0.22621.0)
- ✅ **.NET Framework 4.6.2 developer tools** — NOT just the targeting pack, must be the full "developer tools" which installs the `NETFXSDK` registry key that UBT looks for

### 3. UBT Configuration
Create or edit this file:

```
%APPDATA%\Unreal Engine\UnrealBuildTool\BuildConfiguration.xml
```

Contents:
```xml
<?xml version="1.0" encoding="utf-8" ?>
<Configuration xmlns="https://www.unrealengine.com/BuildConfiguration">
	<WindowsPlatform>
		<Compiler>VisualStudio2022</Compiler>
		<CompilerVersion>14.38.33130</CompilerVersion>
	</WindowsPlatform>
</Configuration>
```

This forces UBT to use the 14.38 toolset instead of picking the newest (broken) one.

**Note:** The exact version number `14.38.33130` matches the folder name in `VS2022/VC/Tools/MSVC/`. If your install creates a slightly different version, check the folder and update accordingly.

### 4. Build

Either:
- Open the `.uproject` in UE 5.3 Editor (it will compile automatically)
- Or from command line:
```
"C:/Program Files/Epic Games/UE_5.3/Engine/Build/BatchFiles/Build.bat" AIMOGEN_VIZZIES_26Editor Win64 Development "D:/Projects/AIMOGEN26/AIMOGEN_VIZZIES_26.uproject" -WaitMutex
```

## Verification

A successful build shows:
```
Using Visual Studio 2022 14.38.33145 toolchain (...)
[1/13] Copy Spout.dll
[2/13] Copy SpoutDX12.dll
...
[12/13] Link [x64] UnrealEditor-Spout2_DX12.dll
[13/13] WriteMetadata
```

No `Detected compiler newer than Visual Studio 2022` warning, no `__has_feature` errors.

## Quick Diagnostic

If the build fails, check these in order:

| Error | Fix |
|---|---|
| `Could not find NetFxSDK install dir` | Install ".NET Framework 4.6.2 developer tools" in VS Installer |
| `Unable to find valid 14.38 C++ toolchain for VisualStudio2022` | Install the 14.38 toolset under a VS **2022** install, not VS 2026 |
| `Detected compiler newer than Visual Studio 2022` + `__has_feature` | CompilerVersion in BuildConfiguration.xml isn't working — check the XML path and version string |
| `error C4668: '__has_feature'` | Using MSVC 14.40+ — need 14.38 or 14.39 |
