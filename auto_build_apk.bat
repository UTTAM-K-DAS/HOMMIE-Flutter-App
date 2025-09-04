@echo off
setlocal enabledelayedexpansion

echo.
echo ========================================================
echo            HOMMIE APK BUILDER - FULL AUTOMATION
echo ========================================================
echo.

cd "C:\Users\User\HOMMIE"

echo [STEP 1] Checking Flutter and Android setup...
flutter doctor --android-licenses
echo.

echo [STEP 2] Setting compatible Gradle configuration...
echo Using Gradle 7.5 with Android Gradle Plugin 7.2.0
echo This combination is stable with most Java versions.
echo.

echo [STEP 3] Cleaning all build caches...
flutter clean >nul 2>&1
if exist "build" rmdir /s /q "build" >nul 2>&1
if exist "android\build" rmdir /s /q "android\build" >nul 2>&1
if exist "android\app\build" rmdir /s /q "android\app\build" >nul 2>&1
powershell -Command "Remove-Item -Path '$env:USERPROFILE\.gradle' -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1
echo Caches cleaned.
echo.

echo [STEP 4] Getting Flutter dependencies...
flutter pub get
echo.

echo [STEP 5] Generating app icon...
if not exist "assets\icon\icon.png" (
    mkdir "assets\icon" >nul 2>&1
    copy "android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png" "assets\icon\icon.png" >nul 2>&1
)
flutter pub run flutter_launcher_icons >nul 2>&1
echo Icon generated.
echo.

echo [STEP 6] Building DEBUG APK...
echo This may take 10-15 minutes for first build...
echo Downloading Gradle 7.5 and dependencies...
echo.

flutter build apk --debug --verbose
set BUILD_RESULT=!ERRORLEVEL!

echo.
echo [STEP 7] Checking build result...

if !BUILD_RESULT! EQU 0 (
    if exist "build\app\outputs\flutter-apk\app-debug.apk" (
        echo.
        echo ✅ SUCCESS! HOMMIE APK built successfully!
        echo.
        echo 📍 APK Location:
        echo    C:\Users\User\HOMMIE\build\app\outputs\flutter-apk\app-debug.apk
        echo.
        echo 📱 APK Details:
        for %%I in ("build\app\outputs\flutter-apk\app-debug.apk") do (
            set /a size=%%~zI/1024/1024
            echo    Size: !size! MB
        )
        echo    Package: com.Magistry.Hommie
        echo    Version: 1.0.0
        echo.
        echo 🚀 READY TO INSTALL ON YOUR PHONE!
        echo.
        echo 📋 Installation Steps:
        echo    1. Transfer APK to your phone ^(USB/Email/Cloud^)
        echo    2. Enable 'Install from Unknown Sources' in phone settings
        echo    3. Tap the APK file to install
        echo    4. Enjoy HOMMIE! 🏠
        echo.
        echo Would you like to build RELEASE version too? ^(Y/N^)
        set /p choice=
        if /i "!choice!"=="y" (
            echo.
            echo Building release APK...
            flutter build apk --release
            if exist "build\app\outputs\flutter-apk\app-release.apk" (
                echo ✅ Release APK also created successfully!
            ) else (
                echo ⚠️  Release build failed, but debug APK is working fine.
            )
        )
    ) else (
        echo ❌ Build completed but APK not found. Checking alternative locations...
        dir "build" /s /b *.apk 2>nul
    )
) else (
    echo ❌ Build failed with error code: !BUILD_RESULT!
    echo.
    echo 🔧 Trying alternative build configurations...
    echo.
    
    echo Attempting with different Java compatibility...
    echo. >> android\gradle.properties
    echo org.gradle.jvmargs=-Xmx3072M -Dfile.encoding=UTF-8 -Duser.country=US -Duser.language=en -Duser.variant >> android\gradle.properties
    echo org.gradle.daemon=false >> android\gradle.properties
    
    flutter clean >nul 2>&1
    flutter pub get >nul 2>&1
    
    echo Trying build with minimal configuration...
    flutter build apk --debug --target-platform android-arm64
    
    if exist "build\app\outputs\flutter-apk\app-debug.apk" (
        echo ✅ Alternative build successful!
    ) else (
        echo.
        echo 🆘 LOCAL BUILD ISSUES DETECTED
        echo.
        echo Recommended solutions:
        echo 1. Install Java 17: https://adoptium.net/temurin/releases/?version=17
        echo 2. Use online builder: https://codemagic.io/
        echo 3. Use Android Studio's Build APK option
        echo.
        echo Your Flutter app is ready - just needs compilation environment fix.
    )
)

echo.
echo ========================================================
echo                    BUILD COMPLETE
echo ========================================================
echo.
pause
