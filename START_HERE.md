# ANJAR AI — Fresh Start Guide

## Step 1 — Install required software (if not already installed)

Download and install these in order:

1. **Node.js v20** — https://nodejs.org → Download LTS (v20.x)
   - During install: tick "Add to PATH" ✅
   - Verify: open PowerShell and type `node --version` → should show v20.x

2. **Git** — https://git-scm.com/download/win
   - All defaults are fine
   - Verify: `git --version`

3. **EAS CLI** — in PowerShell:
   ```
   npm install -g eas-cli
   ```

---

## Step 2 — Create the project folder

In PowerShell:
```
mkdir C:\ANJAR_v3
```

Extract ALL files from this zip into C:\ANJAR_v3
You should see: App.js, package.json, app.json, eas.json, index.js, babel.config.js, metro.config.js

---

## Step 3 — Set up git (one time only)

```
git config --global user.email "elijar1977@gmail.com"
git config --global user.name "Jaro"
```

---

## Step 4 — Go to folder and install packages

```
cd C:\ANJAR_v3
npm install
```

Wait 2-3 minutes. Ignore all "deprecated" warnings — normal.

---

## Step 5 — Set up git repo

```
git init
Set-Content .gitignore "node_modules`n.expo`n*.log`nandroid`nios"
git add .
git commit -m "ANJAR initial"
```

---

## Step 6 — Log in to Expo

```
npx eas-cli login
```

Username: elijar
Password: your Expo password

---

## Step 7 — Build the APK

```
npx eas-cli build --platform android --profile preview
```

Answer Y to everything. Build takes 10-20 minutes on Expo's servers.
Watch progress at: https://expo.dev/accounts/elijar/projects/anjarnative/builds

---

## Step 8 — Install on tablet

When build finishes, download the APK from the Expo page.
Transfer to tablet via USB or email to yourself.
On tablet: tap the APK file → Install.

---

## What the app does

- She hears you say "Anjar" and wakes up
- Answers any question in 11 languages (EN PL HU DE FR ES IT PT UA CZ RO)
- Plays radio: say "Anjar, play radio chill"
- Searches YouTube: say "Anjar, play Dawid Podsiadło"
- Tells weather: say "Anjar, weather in Rochdale"
- Voice: your phone's built-in voice by default (free, no signup)
- Optional human voice: get a free ElevenLabs key at elevenlabs.io

---

## Your existing credentials (already in the app)

- Expo account: elijar / elijar1977@gmail.com
- EAS Project ID: 60c75ef9-6888-4811-b7fb-2aecea272eb2
- Cloudflare proxy: already embedded — no setup needed
- Claude AI brain: already connected via proxy — no setup needed
