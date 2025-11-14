# Update Vercel Configuration

## Issue
Vercel build failed because Flutter is not installed on Vercel servers.

## Solution
Updated `vercel.json` with a build command that installs Flutter first.

## Push the Fix to GitHub

Run these commands to update your deployment:

```bash
cd C:\Users\manis\OneDrive\Desktop\startup\man

# Add the updated file
git add vercel.json

# Commit the change
git commit -m "Fix: Install Flutter on Vercel build"

# Push to GitHub
git push
```

## What This Does

The new build command:
1. Clones Flutter SDK (first time only)
2. Enables web support
3. Builds your app for web

## Vercel Will Automatically

- Detect the push
- S