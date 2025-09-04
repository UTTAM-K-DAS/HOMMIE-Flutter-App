@echo off
echo ============================================
echo    🚀 EMERGENCY APK BUILDER FOR PHONE 📱
echo ============================================
echo.

cd "C:\Users\User\HOMMIE"

echo [1] Force killing any Java/Gradle processes...
taskkill /f /im java.exe >nul 2>&1
taskkill /f /im gradle.exe >nul 2>&1

echo [2] Using ORIGINAL stable configuration...
echo    - Gradle 6.7.1 (pre-installed)
echo    - AGP 4.1.0 (stable)
echo    - Kotlin 1.3.50 (compatible)

echo [3] Complete cache destruction...
powershell -Command "Remove-Item -Path '$env:USERPROFILE\.gradle' -Recurse -Force -ErrorAction SilentlyContinue"
flutter clean

echo [4] Emergency build with minimal config...
flutter pub get
flutter build apk --debug --target-platform android-arm64 --split-per-abi

echo [5] Checking for APK...
if exist "build\app\outputs\flutter-apk\app-arm64-v8a-debug.apk" (
    echo ✅ ARM64 APK CREATED!
    echo Location: build\app\outputs\flutter-apk\app-arm64-v8a-debug.apk
) else if exist "build\app\outputs\flutter-apk\app-debug.apk" (
    echo ✅ DEBUG APK CREATED!
    echo Location: build\app\outputs\flutter-apk\app-debug.apk
) else (
    echo ❌ Still failing. Trying fat APK...
    flutter build apk --debug --no-split-per-abi
    if exist "build\app\outputs\flutter-apk\app-debug.apk" (
        echo ✅ FAT APK CREATED!
        echo Location: build\app\outputs\flutter-apk\app-debug.apk
    ) else (
        echo 🆘 EMERGENCY SOLUTION NEEDED
        echo.
        echo Quick alternatives:
        echo 1. Use Android Studio: Build → Build APK
        echo 2. Online builder: https://codemagic.io
        echo 3. Use WSL/Linux subsystem
    )
)

echo.
echo 📱 TRANSFER TO PHONE:
echo 1. Copy APK to phone storage
echo 2. Enable 'Unknown Sources' in settings
echo 3. Install APK
echo 4. Enjoy HOMMIE!

pause
