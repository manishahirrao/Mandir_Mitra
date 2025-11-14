# Vercel Quick Start - 5 Minutes to Deploy! 🚀

## Option 1: Deploy Without Git (Fastest)

### Step 1: Build Your App
```bash
cd C:\Users\manis\OneDrive\Desktop\startup\man
flutter build web --release
```

### Step 2: Install Vercel CLI
```bash
npm install -g vercel
```

### Step 3: Deploy
```bash
cd build/web
vercel --prod
```

Done! Your app is live! 🎉

---

## Option 2: Deploy from GitHub (Recommended)

### Step 1: Push to GitHub

First, install Git: https://git-scm.com/download/win

Then:
```bash
cd C:\Users\manis\OneDrive\Desktop\startup\man

git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/manishahirrao/Mandir_Mitra.git
git push -u origin main
```

### Step 2: Connect to Vercel

1. Go to https://vercel.com/signup
2. Sign up with GitHub
3. Click "Add New..." > "Project"
4. Select `manishahirrao/Mandir_Mitra`
5. Click "Deploy"

That's it! Auto-deploys on every push! 🎉

---

## Your URLs

After deployment:
- **Live App:** `https://mandir-mitra.vercel.app`
- **Dashboard:** `https://vercel.com/dashboard`

---

## What's Already Configured

✅ `vercel.json` - Build configuration
✅ `.vercelignore` - Files to exclude
✅ Routing setup for Flutter web
✅ Security headers
✅ Asset caching

---

## Troubleshooting

**"flutter: command not found" on Vercel**

Update `vercel.json` build command to:
```json
{
  "buildCommand": "if cd flutter; then git pull && cd ..; else git clone https://github.com/flutter/flutter.git; fi && flutter/bin/flutter config --enable-web && flutter/bin/flutter build web --release"
}
```

**White screen after deploy**

Check browser console for errors. Usually Supabase credentials need updating.

**Build takes too long**

First build takes 5-10 minutes (Flutter installation). Subsequent builds are faster (2-3 minutes).

---

## Next Steps After Deploy

1. **Add Custom Domain**
   - Vercel Dashboard > Domains > Add
   - Enter: `mandirmitra.com`

2. **Update Supabase Credentials**
   - Edit `lib/config/supabase_config.dart`
   - Replace placeholders with real values

3. **Enable Analytics**
   - Vercel Dashboard > Analytics > Enable

4. **Set Up Environment Variables**
   - Vercel Dashboard > Settings > Environment Variables
   - Add `SUPABASE_URL` and `SUPABASE_ANON_KEY`

---

**Need detailed instructions?** See `VERCEL_DEPLOYMENT_GUIDE.md`
