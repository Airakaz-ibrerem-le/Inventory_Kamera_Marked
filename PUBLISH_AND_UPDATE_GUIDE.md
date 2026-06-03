# Inventory Kamera Personal Fork Guide

This guide explains how to build/publish the modified Inventory Kamera executable and how to keep a personal fork updated while preserving the custom artifact `marked` feature.

## Context

This fork adds support for Genshin Impact artifact marks/favorites.

The modified export adds this field to artifacts:

```json
"marked": true
```

or:

```json
"marked": false
```

This is intended for personal tooling and filtering/scoring programs.

## Important files changed

The custom feature mainly touches:

```txt
InventoryKamera/game/Artifact.cs
InventoryKamera/scraping/ArtifactScraper.cs
InventoryKamera/scraping/InventoryScraper.cs
InventoryKamera/data/InventoryKamera.cs
InventoryKamera/InventoryKamera.csproj
```

Summary of changes:

- Added `marked` to artifact JSON serialization.
- Added mark icon bitmap extraction.
- Added yellow star pixel detection.
- Added `marked.png` debug logging.
- Shifted artifact bitmap indexes after adding the mark bitmap.
- Added build compatibility package `System.Resources.Extensions`.

---

# 1. Publishing / building the executable

## Requirements

You need Visual Studio / MSBuild installed.

Current known working MSBuild path:

```powershell
A:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe
```

If your path is different, find it with:

```powershell
Get-ChildItem "A:\Program Files\Microsoft Visual Studio" -Recurse -Filter MSBuild.exe -ErrorAction SilentlyContinue
```

or:

```powershell
Get-ChildItem "C:\Program Files\Microsoft Visual Studio" -Recurse -Filter MSBuild.exe -ErrorAction SilentlyContinue
```

## Recommended publish script

Use the file at the repository root:

```txt
publish.ps1
```

## Running the publish script

From the repository root:

```powershell
.\publish.ps1
```

If PowerShell blocks scripts, run this once:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

Then run again:

```powershell
.\publish.ps1
```

## Output executable

After a successful build, the executable is located at:

```txt
InventoryKamera/bin/Release/InventoryKamera.exe
```

Run that executable to test your modified version.

## Common build issue: executable locked

If the build fails with an error saying `InventoryKamera.exe` is currently in use, close Inventory Kamera.

Or force-close it:

```powershell
Stop-Process -Name InventoryKamera -Force
```

Then run:

```powershell
.\publish.ps1
```

---

# 2. Updating the fork from upstream

This is the recommended workflow for keeping the personal fork updated while preserving the custom `marked` feature.

## Required one-time setup

Make sure your fork has the original repository configured as `upstream`.

Check remotes:

```bash
git remote -v
```

You should see something like:

```txt
origin    https://github.com/YOUR_USERNAME/Inventory_Kamera.git
upstream  https://github.com/ORIGINAL_OWNER/Inventory_Kamera.git
```

If `upstream` is missing, add it:

```bash
git remote add upstream https://github.com/ORIGINAL_OWNER/Inventory_Kamera.git
```

Replace the URL with the real upstream repository URL.

---

## Updating when upstream releases a new version

### Step 1: fetch upstream updates

```bash
git fetch upstream --tags
```

### Step 2: update your local master branch

```bash
git checkout master
git pull origin master
git merge upstream/master
git push origin master
```

If the upstream default branch is not `master`, use the correct branch name, for example `main`.

### Step 3: rebase your personal branch

```bash
git checkout personal-marked-support
git rebase master
```

If there are no conflicts, Git will automatically replay your custom marked feature on top of the updated app.

### Step 4: resolve conflicts if needed

If Git reports conflicts, they will probably be in one of these files:

```txt
InventoryKamera/game/Artifact.cs
InventoryKamera/scraping/ArtifactScraper.cs
InventoryKamera/scraping/InventoryScraper.cs
InventoryKamera/data/InventoryKamera.cs
InventoryKamera/InventoryKamera.csproj
```

After resolving conflicts:

```bash
git add .
git rebase --continue
```

When the rebase is done, rebuild:

```powershell
.\publish.ps1
```

Then test the marked feature again.

### Step 5: push the updated personal branch

Because rebase rewrites branch history, push with:

```bash
git push --force-with-lease origin personal-marked-support
```

Use `--force-with-lease`, not plain `--force`.

---

# 3. Quick command cheat sheet

## Build/publish

```powershell
.\publish.ps1
```

## Fetch updates

```bash
git fetch upstream --tags
```

## Update master

```bash
git checkout master
git pull origin master
git merge upstream/master
git push origin master
```

## Rebase personal changes

```bash
git checkout personal-marked-support
git rebase master
```

## Push rebased branch

```bash
git push --force-with-lease origin personal-marked-support
```

---

# 6. Notes

This fork is for personal use.

The `marked` field may not be part of the official GOOD format, so external tools may ignore it or reject it if they use strict schema validation.

For personal programs, it is safe to consume the custom field directly.

Example:

```json
{
  "setKey": "exampleSet",
  "slotKey": "flower",
  "rarity": 5,
  "level": 20,
  "locked": false,
  "marked": true
}
```
