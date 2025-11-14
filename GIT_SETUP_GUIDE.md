# Git Setup and GitHub Push Guide

## Step 1: Install Git

### Download and Install Git for Windows:
1. Go to https://git-scm.com/download/win
2. Download the installer
3. Run the installer with default settings
4. Restart your terminal/command prompt after installation

### Verify Installation:
```bash
git --version
```

## Step 2: Configure Git (First Time Only)

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Step 3: Prepare Your Repository

### ⚠️ IMPORTANT: Before Pushing to GitHub

**Remove sensitive files from tracking:**

The `.gitignore` file is already configured to exclude:
- ✅ Keystore files (`*.jks`, `key.properties`)
- ✅ Firebase config (`google-services.json`)
- ✅ Build files

**But you should:**

1. **Update Supabase Config** (if you haven't):
   - Edit `lib/config/supabase_config.dart`
   - Replace `YOUR_SUPABASE_URL` and `YOUR_SUPABASE_ANON_KEY`
   - OR use environment variables (recommended for production)

2. **Remove key.properties** (if it exists with real passwords):
   ```bash
   cd C:\Users\manis\OneDrive\Desktop\startup\man
   del android\key.properties
   ```
   Create a template instead:
   ```bash
   echo storePassword=YOUR_PASSWORD > android\key.properties.template
   echo keyPassword=YOUR_PASSWORD >> android\key.properties.template
   echo keyAlias=upload >> android\key.properties.template
   echo storeFile=upload-keystore.jks >> android\key.properties.template
   ```

## Step 4: Initialize Git and Push to GitHub

Open Command Prompt or PowerShell in your project folder:

```bash
cd C:\Users\manis\OneDrive\Desktop\startup\man
```

### Initialize Git Repository:
```bash
git init
```

### Add All Files:
```bash
git add .
```

### Check What Will Be Committed:
```bash
git status
```

**Verify these files are NOT listed:**
- ❌ `android/key.properties`
- ❌ `android/upload-keystore.jks`
- ❌ `android/app/google-services.json`
- ❌ `build/` folder

### Create First Commit:
```bash
git commit -m "Initial commit: Mandir Mitra Flutter app"
```

### Set Main Branch:
```bash
git branch -M main
```

### Add Remote Repository:
```bash
git remote add origin https://github.com/manishahirrao/Mandir_Mitra.git
```

### Push to GitHub:
```bash
git push -u origin main
```

If prompted for credentials:
- Username: `manishahirrao`
- Password: Use a **Personal Access Token** (not your GitHub password)

## Step 5: Create GitHub Personal Access Token

If you don't have a token:

1. Go to https://github.com/settings/tokens
2. Click "Generate new token" > "Generate new token (classic)"
3. Give it a name: "Mandir Mitra Deploy"
4. Select scopes: `repo` (full control)
5. Click "Generate token"
6. **Copy the token** (you won't see it again!)
7. Use this token as your password when pushing

## Alternative: Use GitHub Desktop

If you prefer a GUI:

1. Download GitHub Desktop: https://desktop.github.com/
2. Install and sign in
3. Click "Add" > "Add existing repository"
4. Select your project folder
5. Click "Publish repository"

## Future Updates

After making changes:

```bash
git add .
git commit -m "Description of changes"
git push
```

## Create .gitignore Template Files

For team members who clone the repo, create template files:

### android/key.properties.template
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=upload-keystore.jks
```

### lib/config/supabase_config.template.dart
```dart
// Copy this to supabase_config.dart and add your credentials
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

## Security Checklist Before Pushing

- [ ] Git is installed
- [ ] `.gitignore` is configured
- [ ] `key.properties` is not tracked
- [ ] `upload-keystore.jks` is not tracked
- [ ] `google-services.json` is not tracked
- [ ] Supabase credentials are placeholders or in environment variables
- [ ] No API keys or passwords in code
- [ ] Ran `git status` to verify

## Common Issues

**"git is not recognized"**
- Install Git from https://git-scm.com/download/win
- Restart terminal after installation

**"Permission denied (publickey)"**
- Use HTTPS URL instead of SSH
- Or set up SSH keys: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

**"Repository not found"**
- Make sure the repository exists on GitHub
- Check the URL is correct
- Verify you have access to the repository

**"Failed to push"**
- Use Personal Access Token instead of password
- Check your internet connection
- Try: `git push -f origin main` (only for first push)

## What Gets Pushed to GitHub

✅ **Included:**
- Source code (`.dart` files)
- Assets (images, fonts)
- Configuration files (pubspec.yaml, AndroidManifest.xml)
- Documentation (README.md, guides)
- Build configuration (build.gradle)

❌ **Excluded (via .gitignore):**
- Build outputs (`build/` folder)
- Dependencies (`.dart_tool/`, `.pub/`)
- IDE files (`.idea/`, `*.iml`)
- Keystore files (`*.jks`, `key.properties`)
- Firebase config (`google-services.json`)
- Temporary files

---

**Ready to push?** Install Git, then run the commands in Step 4!
