# HOMMIE App Icon Setup Instructions

## Step 1: Create Beautiful App Icon

### Option 1: Use Online Icon Generator (Recommended)
1. Visit: https://icon.kitchen/
2. Choose "Text" mode
3. Enter "H" or "HOMMIE"
4. Select colors:
   - Background: #667eea (Blue)
   - Text: #ffffff (White)
5. Add house/home symbol
6. Download as 1024x1024 PNG
7. Save as: `assets/icon/icon.png`

### Option 2: Use Canva
1. Visit: https://www.canva.com/create/app-icons/
2. Search "home services" templates
3. Customize with HOMMIE colors (#667eea, #764ba2)
4. Download as PNG (1024x1024)
5. Save as: `assets/icon/icon.png`

### Option 3: Use the HTML Generator
1. Open: `assets/icon/icon_generator.html` in browser
2. Take screenshot of the icon (512x512 or larger)
3. Save as: `assets/icon/icon.png`

## Step 2: Generate App Icons
```bash
cd C:\Users\User\HOMMIE
flutter pub run flutter_launcher_icons
```

## Step 3: Build APK for Phone
```bash
# Clean build
flutter clean
flutter pub get

# Build release APK
flutter build apk --release

# APK location: build/app/outputs/flutter-apk/app-release.apk
```

## Current Icon Configuration
- Path: assets/icon/icon.png
- Android: Enabled
- iOS: Enabled
- Minimum SDK: 21

## Colors Used
- Primary: #667eea (Blue gradient start)
- Secondary: #764ba2 (Purple gradient end)
- Accent: #ffffff (White)
- Tools: #fbbf24 (Gold), #34d399 (Green)
