@echo off
echo.
echo ================================================
echo     HOMMIE APK BUILD - JAVA/GRADLE FIX
echo ================================================
echo.

cd "C:\Users\User\HOMMIE"

echo [1/8] Checking Java version...
java -version
echo.

echo [2/8] Checking Flutter doctor...
flutter doctor --android-licenses
echo.

echo [3/8] Removing old Gradle cache...
powershell -Command "Remove-Item -Path '$env:USERPROFILE\.gradle' -Recurse -Force -ErrorAction SilentlyContinue"
echo Gradle cache cleared.
echo.

echo [4/8] Cleaning Flutter build...
flutter clean
echo.

echo [5/8] Removing Android build cache...
if exist "android\build" rmdir /s /q "android\build"
if exist "android\app\build" rmdir /s /q "android\app\build"
echo.

echo [6/8] Getting dependencies...
flutter pub get
echo.

echo [7/8] Trying debug build first...
echo This will download Gradle 8.5 (compatible with Java 21)...
flutter build apk --debug --verbose

echo.
echo [8/8] Build attempt completed!
echo.

if exist "build\app\outputs\flutter-apk\app-debug.apk" (
    echo ✅ SUCCESS! Debug APK created!
    echo.
    echo 📍 APK Location:
    echo    C:\Users\User\HOMMIE\build\app\outputs\flutter-apk\app-debug.apk
    echo.
    echo 📱 APK Size:
    for %%I in ("build\app\outputs\flutter-apk\app-debug.apk") do echo    %%~zI bytes
    echo.
    echo 🚀 Ready to install on your phone!
    echo.
    echo Would you like to try building RELEASE version now? (Y/N)
    set /p choice=
    if /i "%choice%"=="y" (
        echo.
        echo Building release APK...
        flutter build apk --release
        if exist "build\app\outputs\flutter-apk\app-release.apk" (
            echo ✅ Release APK also created successfully!
        )
    )
) else (
    echo ❌ Build still failed. Possible solutions:
    echo.
    echo 1. Install Java 17 instead of Java 21:
    echo    - Download from: https://adoptium.net/temurin/releases/
    echo    - Set JAVA_HOME to Java 17 path
    echo.
    echo 2. Use Android Studio's embedded JDK:
    echo    - Open Android Studio
    echo    - Go to File → Project Structure → SDK Location
    echo    - Set Gradle JDK to Android Studio's JDK
    echo.
    echo 3. Try Codemagic online build:
    echo    - Visit: https://codemagic.io/
    echo    - Connect your GitHub repo
    echo    - Build APK online
)

echo.
echo Press any key to exit...
pause >nul
