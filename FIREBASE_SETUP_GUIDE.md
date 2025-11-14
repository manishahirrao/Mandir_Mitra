# Firebase Setup Guide for Android

## Your Android Package Name

When Firebase asks for the Android package name, use:

```
com.mandirmitra.app
```

## Step-by-Step Firebase Setup

### 1. Add Android App to Firebase Console

1. Go to https://console.firebase.google.com
2. Select your project (or create new one)
3. Click "Add app" and select Android
4. Enter package name: **`com.mandirmitra.app`**
5. App nickname (optional): `Mandir Mitra`
6. Debug signing certificate SHA-1 (optional - skip for now)
7. Click "Register app"

### 2. Download google-services.json

1. Firebase will generate `google-services.json`
2. Download it
3. Place it in: `android/app/google-services.json`

**Important:** This file must be in the `android/app/` folder!

### 3. Add Firebase SDK

#### Update `android/settings.gradle.kts`

Add the Google services plugin:

```kotlin
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
    id("com.google.gms.google-services") version "4.4.0" apply false  // Add this line
}
```

#### Update `android/app/build.gradle`

At the top, after other plugins:

```gradle
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    id "com.google.gms.google-services"  // Add this line
}
```

### 4. Add Firebase Dependencies (if needed)

If you need Firebase services, add to `pubspec.yaml`:

```yaml
dependencies:
  # Firebase
  firebase_core: ^2.24.0
  firebase_auth: ^4.15.0
  firebase_messaging: ^14.7.0  # For push notifications
  firebase_analytics: ^10.7.0  # For analytics
```

Then run:
```bash
flutter pub get
```

### 5. Initialize Firebase in Your App

If using Firebase (not just for deployment), update `lib/main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Your existing Supabase initialization
  await SupabaseConfig.initialize();
  
  runApp(const MandirMitraApp());
}
```

### 6. Get SHA-1 Certificate (For Firebase Auth)

If you need Firebase Authentication or Dynamic Links:

#### Debug SHA-1:
```bash
cd android
./gradlew signingReport
```

Look for the SHA-1 under "Task :app:signingReport" > "Variant: debug"

#### Release SHA-1:
```bash
keytool -list -v -keystore android/upload-keystore.jks -alias upload
```

Add these SHA-1 fingerprints to Firebase Console:
- Project Settings > Your apps > Add fingerprint

## Quick Reference

**Package Name:** `com.mandirmitra.app`

**File Location:** `android/app/google-services.json`

**App Name:** Mandir Mitra

## Verification

After setup, build and run:

```bash
flutter clean
flutter pub get
flutter run
```

Check logs for:
```
Firebase initialization successful
```

## Troubleshooting

**"google-services.json not found"**
- Ensure file is in `android/app/` folder
- File name must be exactly `google-services.json`

**"Package name mismatch"**
- Verify package name in Firebase matches `com.mandirmitra.app`
- Check `android/app/build.gradle` applicationId

**Build fails after adding Firebase**
- Run `flutter clean`
- Delete `android/.gradle` folder
- Run `flutter pub get`
- Rebuild

**Firebase not initializing**
- Check `google-services.json` is in correct location
- Verify plugin is added to `build.gradle`
- Check internet connection

## What Firebase Services Can You Use?

With this setup, you can use:
- ✅ Firebase Cloud Messaging (Push Notifications)
- ✅ Firebase Analytics
- ✅ Firebase Crashlytics
- ✅ Firebase Dynamic Links
- ✅ Firebase Remote Config
- ✅ Firebase Authentication (if needed alongside Supabase)

## Note About Supabase

You're currently using Supabase for backend. Firebase setup is optional and only needed if you want:
- Push notifications via FCM
- Analytics
- Crashlytics
- Dynamic links

You can continue using Supabase for auth and database!

---

**Next:** After Firebase setup, continue with building your APK using `QUICK_BUILD_INSTRUCTIONS.md`
