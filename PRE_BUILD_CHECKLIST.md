# Pre-Build Checklist ✓

Before building your release APK/AAB, make sure these are configured:

## 🔐 1. Supabase Configuration

**File:** `lib/config/supabase_config.dart`

Replace these placeholders with your actual Supabase credentials:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

Get these from:
1. Go to https://supabase.com/dashboard
2. Select your project
3. Go to Settings > API
4. Copy:
   - Project URL → `supabaseUrl`
   - Project API keys (anon/public) → `supabaseAnonKey`

## 🔑 2. Keystore Setup

- [ ] Keystore created at `android/upload-keystore.jks`
- [ ] Passwords updated in `android/key.properties`
- [ ] Passwords backed up securely

## 📱 3. App Information

Verify in `pubspec.yaml`:
```yaml
name: man
description: Mandir Mitra - Your Divine Connection
version: 1.0.0+1
```

Verify in `android/app/build.gradle`:
```gradle
applicationId "com.mandirmitra.app"
minSdk 21
targetSdk 34
```

## 🎨 4. App Assets

Check these files exist:
- [ ] `assets/images/app_icon.png` (512x512)
- [ ] `assets/images/app_icon_foreground.png`
- [ ] `assets/images/splash_logo.png`

If missing, add placeholder images or update `pubspec.yaml`.

## 🌐 5. Deep Links (Optional)

If you have a domain, update in `AndroidManifest.xml`:
```xml
<data
    android:scheme="https"
    android:host="mandirmitra.app"/>
```

Replace `mandirmitra.app` with your actual domain.

## 📝 6. App Permissions

Review permissions in `android/app/src/main/AndroidManifest.xml`:
- Internet ✓
- Camera (for QR scanning)
- Location (if needed)
- Storage (for offline features)

Remove any unused permissions.

## 🔒 7. Security

- [ ] Remove any test/debug code
- [ ] Remove console.log or print statements
- [ ] Verify API keys are not hardcoded
- [ ] Check `.gitignore` includes keystore files

## 🧪 8. Testing

Before building release:
```bash
# Test in debug mode
flutter run

# Test in release mode
flutter run --release
```

## ✅ Ready to Build?

Once all items are checked:

```bash
# Build AAB for Play Store
flutter build appbundle --release

# Or use the script
build_release.bat
```

## 🚨 Common Issues

**Build fails with Supabase error:**
- Update Supabase credentials in `supabase_config.dart`

**Signing error:**
- Check keystore exists
- Verify passwords in `key.properties`

**Missing assets:**
- Run `flutter pub get`
- Check asset paths in `pubspec.yaml`

**ProGuard issues:**
- Check `android/app/proguard-rules.pro`
- Add keep rules if needed

---

**Next:** See `QUICK_BUILD_INSTRUCTIONS.md` to build your app!
