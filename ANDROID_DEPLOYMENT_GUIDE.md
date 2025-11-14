# Android Deployment Guide for Google Play Console

## Prerequisites
- Google Play Console account ($25 one-time fee)
- Java Development Kit (JDK) installed

## Step 1: Create Keystore (One-time setup)

### Option A: Using Command Line (Recommended)
Open Command Prompt or PowerShell and run:

```bash
cd C:\Users\manis\OneDrive\Desktop\startup\man
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

You'll be prompted for:
- Keystore password (remember this!)
- Key password (can be same as keystore password)
- Your name
- Organization unit
- Organization name
- City/Locality
- State/Province
- Country code (e.g., IN for India)

**IMPORTANT:** Save these passwords securely! You'll need them for all future updates.

### Option B: Using Android Studio
1. Open Android Studio
2. Build > Generate Signed Bundle/APK
3. Follow the wizard to create a new keystore

## Step 2: Configure Key Properties

Edit `android/key.properties` file with your actual passwords:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=../upload-keystore.jks
```

**SECURITY:** Add `key.properties` to `.gitignore` to keep passwords safe!

## Step 3: Build Release AAB (Android App Bundle)

### For Google Play Store (Recommended):
```bash
cd C:\Users\manis\OneDrive\Desktop\startup\man
flutter build appbundle --release
```

The AAB file will be at:
`build/app/outputs/bundle/release/app-release.aab`

### For Direct Distribution (APK):
```bash
flutter build apk --release
```

The APK file will be at:
`build/app/outputs/flutter-apk/app-release.apk`

## Step 4: Test the Release Build

Before uploading, test the release build:

```bash
# Install on connected device
flutter install --release
```

Or manually install the APK on your device.

## Step 5: Upload to Google Play Console

1. Go to https://play.google.com/console
2. Create a new app or select existing app
3. Complete the app details:
   - App name: Mandir Mitra
   - Default language
   - App category: Lifestyle
   - Privacy policy URL (required)

4. Go to "Production" > "Create new release"
5. Upload the `app-release.aab` file
6. Fill in release notes
7. Review and rollout

## Step 6: Complete Store Listing

Required information:
- App icon (512x512 PNG)
- Feature graphic (1024x500 PNG)
- Screenshots (at least 2, up to 8)
- Short description (80 chars max)
- Full description (4000 chars max)
- Privacy policy URL
- Content rating questionnaire
- Target audience

## App Information

**Package Name:** com.mandirmitra.app
**Version:** 1.0.0+1
**Min SDK:** 21 (Android 5.0)
**Target SDK:** 34 (Android 14)

## Troubleshooting

### If keytool is not found:
1. Find your Java installation:
   - Usually at: `C:\Program Files\Java\jdk-XX\bin`
   - Or: `C:\Program Files\Android\Android Studio\jbr\bin`

2. Add to PATH or use full path:
```bash
"C:\Program Files\Java\jdk-17\bin\keytool.exe" -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### Build fails:
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build appbundle --release
```

### Signing errors:
- Verify `key.properties` has correct passwords
- Ensure `upload-keystore.jks` exists in the `android` folder
- Check file paths are correct

## Future Updates

For app updates:
1. Update version in `pubspec.yaml`:
   ```yaml
   version: 1.0.1+2  # Format: versionName+versionCode
   ```

2. Build new AAB:
   ```bash
   flutter build appbundle --release
   ```

3. Upload to Play Console as new release

## Security Checklist

- [ ] `upload-keystore.jks` backed up securely
- [ ] Passwords stored in password manager
- [ ] `key.properties` added to `.gitignore`
- [ ] Never commit keystore or passwords to Git
- [ ] Keep keystore safe - losing it means you can't update your app!

## Next Steps

1. Create keystore using the command above
2. Update `key.properties` with your passwords
3. Build the AAB: `flutter build appbundle --release`
4. Test the release build
5. Upload to Google Play Console

---

**Need Help?**
- Google Play Console Help: https://support.google.com/googleplay/android-developer
- Flutter Deployment Docs: https://docs.flutter.dev/deployment/android
