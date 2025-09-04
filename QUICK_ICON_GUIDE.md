# Quick Icon Creation Guide for HOMMIE

## Fastest Way to Get Beautiful Icon:

### Method 1: Use Favicon Generator (2 minutes)
1. Go to: https://favicon.io/favicon-generator/
2. Text: "H"
3. Background: Rounded, #667eea
4. Font: Inter, Bold
5. Download ZIP
6. Use the android-chrome-512x512.png as icon.png

### Method 2: Use Logo Maker (3 minutes)
1. Go to: https://logo.com/
2. Search "home services"
3. Pick a house icon
4. Change colors to #667eea and #764ba2
5. Download PNG (512x512 or larger)
6. Save as assets/icon/icon.png

### Method 3: Use Canva Quick Create (1 minute)
1. Go to: https://canva.com
2. Create Design → App Icon
3. Search "home" in elements
4. Add house icon
5. Change background to gradient (#667eea to #764ba2)
6. Download as PNG

## After Creating Icon:
```bash
# Save the icon as: assets/icon/icon.png
# Then run these commands:

cd C:\Users\User\HOMMIE
flutter pub run flutter_launcher_icons
flutter build apk --release
```

## Install on Phone:
1. APK will be at: `build\app\outputs\flutter-apk\app-release.apk`
2. Transfer to phone via USB/Email/AirDrop
3. Enable "Install from Unknown Sources" in phone settings
4. Install the APK

## Icon Specifications:
- Size: 1024x1024 pixels (minimum 512x512)
- Format: PNG with transparent background
- Colors: #667eea (primary), #764ba2 (secondary)
- Style: Modern, clean, house/service themed
