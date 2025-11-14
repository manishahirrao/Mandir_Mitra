# Mandir Mitra - Deployment Guide

## 🚀 Complete Deployment Checklist

### Phase 1: Pre-Deployment Setup

#### 1.1 Supabase Configuration
```bash
# 1. Create Supabase project
# 2. Note down:
#    - Project URL
#    - Anon key
#    - Service role key (keep secret!)
```

#### 1.2 Database Setup
```sql
-- Run all migrations from SUPABASE_MIGRATION_GUIDE.md
-- Verify all tables created
-- Check RLS policies
-- Test with sample data
```

#### 1.3 Storage Buckets
```bash
# Create buckets:
- profile-images (public)
- ritual-images (public)
- review-images (public)
- invoices (private)

# Configure policies for each bucket
```

#### 1.4 Update Configuration
```dart
// lib/config/supabase_config.dart
static const String supabaseUrl = 'https://your-project.supabase.co';
static const String supabaseAnonKey = 'your-anon-key';
```

### Phase 2: App Configuration

#### 2.1 Update App Identity
```yaml
# pubspec.yaml
name: man
description: Mandir Mitra - Your Divine Connection
version: 1.0.0+1
```

```gradle
// android/app/build.gradle
defaultConfig {
    applicationId "com.mandirmitra.app"
    versionCode 1
    versionName "1.0.0"
}
```

#### 2.2 Generate App Icons
```bash
# 1. Place icon at assets/images/app_icon.png (1024x1024)
# 2. Run:
flutter pub run flutter_launcher_icons

# Verify icons generated in:
# - android/app/src/main/res/mipmap-*
```

#### 2.3 Generate Splash Screen
```bash
# 1. Place logo at assets/images/splash_logo.png
# 2. Run:
flutter pub run flutter_native_splash:create

# Verify splash generated
```

#### 2.4 Configure Deep Links
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<!-- Update with your actual domain -->
<data
    android:scheme="https"
    android:host="mandirmitra.app"/>
```

### Phase 3: Build Configuration

#### 3.1 Create Keystore
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# Save password securely!
```

#### 3.2 Configure Signing
```properties
# android/key.properties (DO NOT COMMIT!)
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
```

```gradle
// android/app/build.gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

#### 3.3 Enable ProGuard
```gradle
// android/app/build.gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

### Phase 4: Testing

#### 4.1 Run Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Analyze code
flutter analyze

# Check for issues
flutter doctor -v
```

#### 4.2 Test Release Build
```bash
# Build release APK
flutter build apk --release

# Install on device
adb install build/app/outputs/flutter-apk/app-release.apk

# Test thoroughly:
- All features
- Offline mode
- Deep links
- Payments
- Notifications
```

#### 4.3 Performance Testing
```bash
# Profile performance
flutter run --profile

# Check app size
flutter build apk --analyze-size

# Memory profiling
# Use DevTools
```

### Phase 5: Build for Production

#### 5.1 Clean Build
```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build app bundle (recommended for Play Store)
flutter build appbundle --release

# Or build APK
flutter build apk --release
```

#### 5.2 Verify Build
```bash
# Check build output
ls -lh build/app/outputs/bundle/release/
ls -lh build/app/outputs/flutter-apk/

# Verify signing
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
```

### Phase 6: Play Store Preparation

#### 6.1 Create Play Store Listing
```
App Name: Mandir Mitra
Short Description: Your Divine Connection - Book Hindu rituals and pujas
Full Description: [See PLAY_STORE_DESCRIPTION.md]
Category: Lifestyle
Content Rating: Everyone
```

#### 6.2 Prepare Assets
```
Required:
- App icon (512x512 PNG)
- Feature graphic (1024x500 PNG)
- Screenshots (at least 2, max 8)
  - Phone: 16:9 or 9:16 ratio
  - Tablet: 16:9 or 9:16 ratio (optional)
- Privacy policy URL
- Terms of service URL
```

#### 6.3 Screenshots
```bash
# Capture screenshots on different devices:
- 5.5" phone (1080x1920)
- 6.5" phone (1440x3040)
- 7" tablet (1200x1920)
- 10" tablet (1600x2560)

# Use Flutter DevTools or device screenshots
```

### Phase 7: Submission

#### 7.1 Create Release
```
1. Go to Play Console
2. Create new release
3. Upload app bundle
4. Fill release notes
5. Review and rollout
```

#### 7.2 Release Notes Template
```
Version 1.0.0

What's New:
✨ Browse 100+ Hindu rituals and pujas
📅 Book rituals at temples nationwide
💳 Secure payment options
📦 Real-time order tracking
⭐ Reviews and ratings
🎁 Loyalty rewards program
📺 Live streaming of your puja
💝 Wishlist feature
🌐 Offline mode
🔍 Smart search

We're excited to bring you this first release!
```

#### 7.3 Submit for Review
```
1. Complete all required fields
2. Set pricing (Free)
3. Select countries
4. Submit for review
5. Wait for approval (typically 1-3 days)
```

### Phase 8: Post-Deployment

#### 8.1 Monitor
```
- Check crash reports
- Monitor user reviews
- Track analytics
- Watch performance metrics
```

#### 8.2 Setup Monitoring
```dart
// Add crash reporting (e.g., Sentry, Firebase Crashlytics)
// Add analytics (e.g., Google Analytics, Mixpanel)
// Add performance monitoring
```

#### 8.3 Prepare for Updates
```
- Plan v1.1.0 features
- Collect user feedback
- Fix reported bugs
- Optimize performance
```

## 🔧 Environment-Specific Configuration

### Development
```dart
// lib/config/env.dart
class Environment {
  static const String supabaseUrl = 'https://dev-project.supabase.co';
  static const String supabaseKey = 'dev-anon-key';
  static const bool isProduction = false;
}
```

### Staging
```dart
class Environment {
  static const String supabaseUrl = 'https://staging-project.supabase.co';
  static const String supabaseKey = 'staging-anon-key';
  static const bool isProduction = false;
}
```

### Production
```dart
class Environment {
  static const String supabaseUrl = 'https://prod-project.supabase.co';
  static const String supabaseKey = 'prod-anon-key';
  static const bool isProduction = true;
}
```

## 📊 Deployment Checklist

### Pre-Deployment
- [ ] Supabase project created
- [ ] Database migrated
- [ ] Storage buckets configured
- [ ] RLS policies set
- [ ] App configuration updated
- [ ] Icons generated
- [ ] Splash screen created
- [ ] Deep links configured
- [ ] Keystore created
- [ ] Signing configured
- [ ] ProGuard enabled

### Testing
- [ ] All features tested
- [ ] Offline mode tested
- [ ] Deep links tested
- [ ] Payments tested
- [ ] Performance tested
- [ ] Security reviewed
- [ ] Release build tested
- [ ] Multiple devices tested

### Play Store
- [ ] Listing created
- [ ] Assets prepared
- [ ] Screenshots captured
- [ ] Privacy policy published
- [ ] Terms of service published
- [ ] App bundle built
- [ ] Release notes written
- [ ] Submitted for review

### Post-Deployment
- [ ] Monitoring setup
- [ ] Analytics configured
- [ ] Crash reporting enabled
- [ ] User feedback collected
- [ ] Performance monitored
- [ ] Updates planned

## 🚨 Troubleshooting

### Build Fails
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk --release
```

### Signing Issues
```bash
# Verify keystore
keytool -list -v -keystore ~/upload-keystore.jks

# Check signing config
cat android/key.properties
```

### Upload Fails
```bash
# Check bundle size (max 150MB)
ls -lh build/app/outputs/bundle/release/app-release.aab

# Verify signing
jarsigner -verify build/app/outputs/bundle/release/app-release.aab
```

## 📞 Support

For deployment issues:
1. Check Flutter documentation
2. Review Play Console help
3. Check Supabase docs
4. Contact support team

---

**Deployment Status**: Ready ✅
**Last Updated**: November 14, 2024
**Next Review**: After first release
