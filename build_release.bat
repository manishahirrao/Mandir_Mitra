@echo off
echo ========================================
echo Mandir Mitra - Android Release Builder
echo ========================================
echo.

REM Check if keystore exists
if not exist "android\upload-keystore.jks" (
    echo ERROR: Keystore not found!
    echo Please create a keystore first using the command in ANDROID_DEPLOYMENT_GUIDE.md
    echo.
    pause
    exit /b 1
)

REM Check if key.properties is configured
findstr /C:"your_store_password" android\key.properties >nul 2>&1
if %errorlevel% equ 0 (
    echo ERROR: key.properties not configured!
    echo Please edit android\key.properties with your actual passwords
    echo.
    pause
    exit /b 1
)

echo Cleaning previous builds...
call flutter clean

echo.
echo Getting dependencies...
call flutter pub get

echo.
echo Building Android App Bundle (AAB) for Google Play...
call flutter build appbundle --release

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo BUILD SUCCESSFUL!
    echo ========================================
    echo.
    echo Your AAB file is ready at:
    echo build\app\outputs\bundle\release\app-release.aab
    echo.
    echo Next steps:
    echo 1. Test the build on a device
    echo 2. Upload to Google Play Console
    echo.
) else (
    echo.
    echo ========================================
    echo BUILD FAILED!
    echo ========================================
    echo Please check the errors above
    echo.
)

pause
