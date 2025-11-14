# Vercel Deployment Guide for Flutter Web

## Overview

Vercel is a great platform for deploying Flutter web apps with:
- ✅ Free tier available
- ✅ Automatic deployments from Git
- ✅ Global CDN
- ✅ Custom domains
- ✅ HTTPS by default

## Prerequisites

1. GitHub account with your code pushed
2. Vercel account (free): https://vercel.com/signup

## Method 1: Deploy via Vercel Dashboard (Easiest)

### Step 1: Build Your Flutter Web App

```bash
cd C:\Users\manis\OneDrive\Desktop\startup\man
flutter build web --release
```

This creates optimized web files in `build/web/`

### Step 2: Create Vercel Account

1. Go to https://vercel.com/signup
2. Sign up with GitHub (recommended)
3. Authorize Vercel to access your repositories

### Step 3: Import Your Project

1. Click "Add New..." > "Project"
2. Import your GitHub repository: `manishahirrao/Mandir_Mitra`
3. Vercel will detect it's a Flutter project

### Step 4: Configure Build Settings

**Framework Preset:** Other

**Build Command:**
```bash
if cd flutter; then git pull && cd ..; else git clone https://github.com/flutter/flutter.git; fi && flutter/bin/flutter config --enable-web && flutter/bin/flutter build web --release
```

**Output Directory:**
```
build/web
```

**Install Command:**
```bash
flutter pub get
```

### Step 5: Add Environment Variables (Optional)

If you're using environment variables for Supabase:

1. Go to Project Settings > Environment Variables
2. Add:
   - `SUPABASE_URL`: Your Supabase URL
   - `SUPABASE_ANON_KEY`: Your Supabase anon key

### Step 6: Deploy

1. Click "Deploy"
2. Wait 2-5 minutes for build
3. Your app will be live at: `https://your-project.vercel.app`

## Method 2: Deploy via Vercel CLI

### Install Vercel CLI

```bash
npm install -g vercel
```

### Login to Vercel

```bash
vercel login
```

### Build and Deploy

```bash
cd C:\Users\manis\OneDrive\Desktop\startup\man

# Build Flutter web
flutter build web --release

# Deploy to Vercel
vercel --prod
```

Follow the prompts:
- Set up and deploy? **Y**
- Which scope? Select your account
- Link to existing project? **N**
- Project name? **mandir-mitra**
- Directory? **./build/web**

## Method 3: Automatic Deployments from GitHub

### Step 1: Create vercel.json

Create this file in your project root:

```json
{
  "buildCommand": "flutter pub get && flutter build web --release",
  "outputDirectory": "build/web",
  "framework": null,
  "installCommand": "if cd flutter; then git pull && cd ..; else git clone https://github.com/flutter/flutter.git; fi && flutter/bin/flutter config --enable-web"
}
```

### Step 2: Push to GitHub

```bash
git add vercel.json
git commit -m "Add Vercel configuration"
git push
```

### Step 3: Connect to Vercel

1. Go to https://vercel.com/new
2. Import your GitHub repository
3. Vercel will use the `vercel.json` configuration
4. Click Deploy

### Step 4: Automatic Deployments

Now every time you push to GitHub:
- **main branch** → Production deployment
- **other branches** → Preview deployments

## Configuration Files

### Create vercel.json

```json
{
  "buildCommand": "flutter build web --release",
  "outputDirectory": "build/web",
  "devCommand": "flutter run -d web-server --web-port 3000",
  "framework": null,
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

### Create .vercelignore

```
# Flutter
.dart_tool/
.packages
.pub/
build/
.flutter-plugins
.flutter-plugins-dependencies

# IDE
.idea/
.vscode/
*.iml

# Secrets
android/key.properties
android/upload-keystore.jks
android/app/google-services.json

# Git
.git/
.gitignore
```

## Custom Domain Setup

### Add Custom Domain

1. Go to Project Settings > Domains
2. Click "Add"
3. Enter your domain: `mandirmitra.com`
4. Follow DNS configuration instructions

### DNS Configuration

Add these records to your domain:

**For root domain (mandirmitra.com):**
```
Type: A
Name: @
Value: 76.76.21.21
```

**For www subdomain:**
```
Type: CNAME
Name: www
Value: cname.vercel-dns.com
```

## Environment Variables

### Add Supabase Credentials

1. Go to Project Settings > Environment Variables
2. Add these variables:

```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

### Update Your Code

If using environment variables, update `lib/config/supabase_config.dart`:

```dart
class SupabaseConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'YOUR_SUPABASE_URL',
  );
  
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'YOUR_SUPABASE_ANON_KEY',
  );
  
  // ... rest of the code
}
```

Then build with:
```bash
flutter build web --release --dart-define=SUPABASE_URL=your-url --dart-define=SUPABASE_ANON_KEY=your-key
```

## Optimization Tips

### 1. Enable CanvasKit for Better Performance

```bash
flutter build web --release --web-renderer canvaskit
```

### 2. Reduce Bundle Size

In `pubspec.yaml`, remove unused dependencies.

### 3. Add Loading Screen

Create `web/index.html` with a loading indicator.

### 4. Enable PWA Features

Update `web/manifest.json` for Progressive Web App features.

## Troubleshooting

### Build Fails on Vercel

**Issue:** Flutter not found

**Solution:** Use the full build command:
```bash
if cd flutter; then git pull && cd ..; else git clone https://github.com/flutter/flutter.git; fi && flutter/bin/flutter config --enable-web && flutter/bin/flutter build web --release
```

### White Screen After Deploy

**Issue:** Routing not working

**Solution:** Add rewrites in `vercel.json`:
```json
{
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

### Assets Not Loading

**Issue:** Incorrect base href

**Solution:** Build with correct base:
```bash
flutter build web --release --base-href /
```

### CORS Errors with Supabase

**Issue:** Cross-origin requests blocked

**Solution:** Configure Supabase CORS settings:
1. Go to Supabase Dashboard
2. Settings > API
3. Add your Vercel domain to allowed origins

## Deployment Checklist

- [ ] Flutter web build works locally
- [ ] Supabase credentials configured
- [ ] GitHub repository is public or Vercel has access
- [ ] `vercel.json` created (optional but recommended)
- [ ] `.vercelignore` created
- [ ] Sensitive files in `.gitignore`
- [ ] Test build: `flutter build web --release`
- [ ] Push to GitHub
- [ ] Import project to Vercel
- [ ] Configure build settings
- [ ] Deploy and test

## Monitoring and Analytics

### View Deployment Logs

1. Go to Vercel Dashboard
2. Select your project
3. Click on a deployment
4. View build logs and runtime logs

### Add Analytics

Vercel provides built-in analytics:
1. Go to Project Settings > Analytics
2. Enable Vercel Analytics
3. Add to your Flutter app (optional)

## Cost

**Free Tier Includes:**
- Unlimited deployments
- 100 GB bandwidth/month
- Automatic HTTPS
- Preview deployments
- Custom domains

**Pro Tier ($20/month):**
- 1 TB bandwidth
- Advanced analytics
- Password protection
- More team features

## Quick Deploy Commands

```bash
# Build locally
flutter build web --release

# Deploy to Vercel (one-time)
vercel --prod

# Or push to GitHub for automatic deployment
git add .
git commit -m "Deploy to Vercel"
git push
```

## Your Deployment URLs

After deployment, you'll get:
- **Production:** `https://mandir-mitra.vercel.app`
- **Preview:** `https://mandir-mitra-git-branch.vercel.app`
- **Custom:** `https://mandirmitra.com` (if configured)

---

**Ready to deploy?** Follow Method 1 for the easiest deployment!

## Next Steps

1. Build your Flutter web app
2. Push code to GitHub
3. Sign up for Vercel
4. Import your repository
5. Deploy!

Your app will be live in minutes! 🚀
