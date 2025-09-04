# Flutter APK Build Fix Script
# Addresses Java 21 compatibility with Flutter Gradle plugin

Write-Host "=== Flutter APK Build Fix Script ===" -ForegroundColor Green

# Step 1: Check current Java version
Write-Host "`nStep 1: Checking Java version..." -ForegroundColor Yellow
try {
    & "$env:JAVA_HOME\bin\java.exe" -version
} catch {
    Write-Host "Java not found at JAVA_HOME. Trying system Java..." -ForegroundColor Red
    java -version
}

# Step 2: Update Gradle wrapper to support Java 21
Write-Host "`nStep 2: Updating Gradle wrapper to 8.7..." -ForegroundColor Yellow
$gradleProps = "android\gradle\wrapper\gradle-wrapper.properties"
if (Test-Path $gradleProps) {
    (Get-Content $gradleProps) -replace "distributionUrl=.*", "distributionUrl=https\://services.gradle.org/distributions/gradle-8.7-all.zip" | Set-Content $gradleProps
    Write-Host "✓ Gradle wrapper updated to 8.7" -ForegroundColor Green
} else {
    Write-Host "✗ Gradle properties file not found!" -ForegroundColor Red
}

# Step 3: Update Android Gradle Plugin in settings.gradle (not build.gradle)
Write-Host "`nStep 3: Updating Android Gradle Plugin to 8.3.2..." -ForegroundColor Yellow
$settingsGradle = "android\settings.gradle"
if (Test-Path $settingsGradle) {
    $content = Get-Content $settingsGradle -Raw
    $content = $content -replace 'id "com.android.application" version ".*"', 'id "com.android.application" version "8.3.2"'
    $content = $content -replace 'id "com.google.gms.google-services" version ".*"', 'id "com.google.gms.google-services" version "4.4.0"'
    Set-Content $settingsGradle -Value $content
    Write-Host "✓ AGP updated to 8.3.2 in settings.gradle" -ForegroundColor Green
} else {
    Write-Host "✗ Settings.gradle file not found!" -ForegroundColor Red
}

# Step 4: Update compileSdkVersion to 34 for compatibility
Write-Host "`nStep 4: Updating compileSdkVersion to 34..." -ForegroundColor Yellow
$appBuildGradle = "android\app\build.gradle"
if (Test-Path $appBuildGradle) {
    $content = Get-Content $appBuildGradle -Raw
    $content = $content -replace "compileSdkVersion \d+", "compileSdkVersion 34"
    Set-Content $appBuildGradle -Value $content
    Write-Host "✓ CompileSdkVersion updated to 34" -ForegroundColor Green
} else {
    Write-Host "✗ App build.gradle file not found!" -ForegroundColor Red
}

# Step 5: Clean all caches
Write-Host "`nStep 5: Cleaning caches..." -ForegroundColor Yellow
Write-Host "Cleaning Flutter cache..."
flutter clean

Write-Host "Cleaning Gradle cache..."
if (Test-Path "$env:USERPROFILE\.gradle\caches") {
    Remove-Item -Recurse -Force "$env:USERPROFILE\.gradle\caches" -ErrorAction SilentlyContinue
    Write-Host "✓ Gradle cache cleared" -ForegroundColor Green
} else {
    Write-Host "- No Gradle cache to clear" -ForegroundColor Yellow
}

# Step 6: Get Flutter dependencies
Write-Host "`nStep 6: Getting Flutter dependencies..." -ForegroundColor Yellow
flutter pub get

# Step 7: Attempt build
Write-Host "`nStep 7: Building APK..." -ForegroundColor Yellow
Write-Host "This may take several minutes for first build..." -ForegroundColor Cyan

$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
flutter build apk --debug

Write-Host "`n=== Build Complete ===" -ForegroundColor Green
