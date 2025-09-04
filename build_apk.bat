@echo off
echo.
echo ================================================
echo           HOMMIE APK BUILD SCRIPT
echo ================================================
echo.

cd "C:\Users\User\HOMMIE"

echo [1/6] Checking Flutter environment...
flutter doctor --android-licenses 2>nul

echo.
echo [2/6] Cleaning previous build and Gradle cache...
flutter clean
cd android
gradlew clean 2>nul
cd ..

echo.
echo [3/6] Cleaning Gradle cache (fixing Java compatibility)...
rmdir /s /q "%USERPROFILE%\.gradle\caches" 2>nul

echo.
echo [4/6] Getting dependencies...
flutter pub get

echo.
echo [5/6] Building release APK...
echo This may take 10-15 minutes on first build (downloading Gradle)...
flutter build apk --release

echo.
echo [6/6] Build complete!
echo.

if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo ✅ SUCCESS! APK created successfully!
    echo.
    echo 📍 APK Location:
    echo    C:\Users\User\HOMMIE\build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo 📱 APK Size:
    for %%I in ("build\app\outputs\flutter-apk\app-release.apk") do echo    %%~zI bytes ^(~%%~zI MB^)
    echo.
    echo 🚀 Ready to install on your phone!
    echo.
    echo Next steps:
    echo 1. Transfer APK to your phone
    echo 2. Enable 'Install from Unknown Sources'
    echo 3. Install the APK
    echo 4. Enjoy HOMMIE! 🏠
) else (
    echo ❌ Build failed! Check the output above for errors.
    echo.
    echo Common solutions:
    echo - Run: flutter doctor
    echo - Check internet connection
    echo - Ensure Android SDK is installed
)

echo.
echo Press any key to exit...
pause >nul
