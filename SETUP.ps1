# ANJAR Setup Script — runs everything automatically
# Right-click this file → Run with PowerShell

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ANJAR SETUP — Professional Edition" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $dir
Write-Host "Working in: $dir" -ForegroundColor Gray

# ── Write package.json ──
Write-Host "[1/6] Writing package.json..." -ForegroundColor Yellow
$pkg = @{
  name = "anjarnative"
  version = "1.0.0"
  main = "index.js"
  scripts = @{ start = "expo start"; android = "expo run:android" }
  dependencies = @{
    "expo" = "51.0.28"
    "expo-av" = "14.0.7"
    "expo-build-properties" = "0.12.5"
    "expo-file-system" = "17.0.1"
    "expo-speech" = "12.0.2"
    "expo-speech-recognition" = "0.2.8"
    "expo-status-bar" = "1.12.1"
    "react" = "18.2.0"
    "react-native" = "0.73.6"
    "@react-native-async-storage/async-storage" = "1.21.0"
    "@react-native-picker/picker" = "2.7.5"
    "react-native-keep-awake" = "4.0.0"
    "react-native-linear-gradient" = "2.8.3"
    "react-native-svg" = "15.2.0"
  }
  devDependencies = @{ "@babel/core" = "7.24.0" }
}
$pkg | ConvertTo-Json -Depth 5 | Set-Content "package.json" -Encoding UTF8
Write-Host "  OK" -ForegroundColor Green

# ── Write app.json ──
Write-Host "[2/6] Writing app.json..." -ForegroundColor Yellow
$app = @{
  expo = @{
    name = "ANJAR"
    slug = "anjarnative"
    version = "1.0.0"
    orientation = "portrait"
    scheme = "anjar"
    userInterfaceStyle = "dark"
    splash = @{ backgroundColor = "#020609" }
    android = @{
      package = "com.anjar.family"
      versionCode = 1
      jsEngine = "jsc"
      adaptiveIcon = @{ backgroundColor = "#020609" }
      permissions = @(
        "android.permission.RECORD_AUDIO",
        "android.permission.INTERNET",
        "android.permission.WAKE_LOCK"
      )
    }
    plugins = @(
      ,@(
        "expo-build-properties",
        @{
          android = @{
            kotlinVersion = "2.1.0"
            compileSdkVersion = 34
            targetSdkVersion = 34
            minSdkVersion = 24
          }
        }
      )
    )
    extra = @{ eas = @{ projectId = "60c75ef9-6888-4811-b7fb-2aecea272eb2" } }
  }
}
$app | ConvertTo-Json -Depth 10 | Set-Content "app.json" -Encoding UTF8
Write-Host "  OK" -ForegroundColor Green

# ── Write eas.json ──
Write-Host "[3/6] Writing eas.json..." -ForegroundColor Yellow
@'
{
  "cli": { "version": ">= 0.52.0", "appVersionSource": "local" },
  "build": {
    "preview": {
      "distribution": "internal",
      "node": "20.19.4",
      "android": { "buildType": "apk" }
    }
  },
  "submit": { "production": {} }
}
'@ | Set-Content "eas.json" -Encoding UTF8
Write-Host "  OK" -ForegroundColor Green

# ── Write support files ──
Write-Host "[4/6] Writing metro.config.js, index.js, babel.config.js..." -ForegroundColor Yellow
"const { getDefaultConfig } = require('expo/metro-config'); module.exports = getDefaultConfig(__dirname);" | Set-Content "metro.config.js" -Encoding UTF8
"import { registerRootComponent } from 'expo'; import App from './App'; registerRootComponent(App);" | Set-Content "index.js" -Encoding UTF8
"module.exports = function(api) { api.cache(true); return { presets: ['babel-preset-expo'] }; };" | Set-Content "babel.config.js" -Encoding UTF8
Write-Host "  OK" -ForegroundColor Green

# ── Validate app.json ──
Write-Host "[5/6] Validating app.json..." -ForegroundColor Yellow
try {
  $check = Get-Content "app.json" | ConvertFrom-Json
  Write-Host "  OK — name: $($check.expo.name), jsEngine: $($check.expo.android.jsEngine)" -ForegroundColor Green
} catch {
  Write-Host "  ERROR in app.json: $_" -ForegroundColor Red
  exit 1
}

# ── Clean install ──
Write-Host "[6/6] Clean npm install (this takes 2-3 minutes)..." -ForegroundColor Yellow
if (Test-Path "node_modules") { Remove-Item -Recurse -Force "node_modules"; Write-Host "  Removed old node_modules" -ForegroundColor Gray }
if (Test-Path "package-lock.json") { Remove-Item "package-lock.json"; Write-Host "  Removed old package-lock.json" -ForegroundColor Gray }
npm install
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  SETUP COMPLETE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Now run this command to build:" -ForegroundColor Cyan
Write-Host "  npx eas-cli build --platform android --profile preview" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter to start the build now, or Ctrl+C to build later"
npx eas-cli build --platform android --profile preview
