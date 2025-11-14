# Quick Build Instructions for Google Play

## 🚀 Fast Track (3 Steps)

### Step 1: Create Keystore (One-time only)

Open Command Prompt in the `man` folder and run:

```bash
keytool -genkey -v -keystore android\upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**If keytool is not found**, try:
```bash
"C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore android\upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Enter a password when prompted (remember it!).

### Step 2: Update Key Properties

Edit `android\key.properties` and replace with your actual passwords:

```properties
storePassword=YOUR_PASSWORD_HERE
keyPassword=YOUR_PASSWORD_HERE
keyAlias=upload
storeFile=upload-keystore.jks
```

### Step 3: Build!

**Option A - Use the script:**
```bash
build_release.bat
```

**Option B - Manual command:**
```bash
flutter build appbundle --release
```

## 📦 Output Location

Your AAB file will be at:
```
build\app\outputs\bundle\release\app-release.aab
```

## ✅ What to Upload

Upload the **app-release.aab** file to Google Play Console.

## 📱 Test Before Upload

```bash
flutter build apk --release
flutter install --release
```

## 🆘 Troubleshooting

**"keytool not found"**
- Install Java JDK or use Android Studio's keytool (see path above)

**"Keystore not found"**
- Make sure you created the keystore in Step 1
- Check it exists at `android\upload-keystore.jks`

**"Wrong password"**
- Verify passwords in `android\key.properties` match what you entered

**Build fails**
```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

## 📋 Checklist

- [ ] Keystore created
- [ ] key.properties updated with passwords
- [ ] AAB built successfully
- [ ] Tested on device
- [ ] Ready to upload to Play Console

---

For detailed instructions, see **ANDROID_DEPLOYMENT_GUIDE.md**
