# Quick Git Commands Reference

## First Time Setup (Do Once)

```bash
# Install Git first from: https://git-scm.com/download/win

# Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Navigate to project
cd C:\Users\manis\OneDrive\Desktop\startup\man

# Initialize repository
git init

# Add all files
git add .

# First commit
git commit -m "Initial commit: Mandir Mitra app"

# Set main branch
git branch -M main

# Add remote
git remote add origin https://github.com/manishahirrao/Mandir_Mitra.git

# Push to GitHub
git push -u origin main
```

## Daily Git Workflow

```bash
# Check status
git status

# Add changes
git add .

# Commit changes
git commit -m "Description of what you changed"

# Push to GitHub
git push
```

## Useful Commands

```bash
# See what changed
git diff

# See commit history
git log --oneline

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Discard all local changes
git reset --hard

# Pull latest from GitHub
git pull

# Create new branch
git checkout -b feature-name

# Switch branches
git checkout main
```

## Before First Push - Security Check

```bash
# Check what will be committed
git status

# Make sure these are NOT listed:
# ❌ android/key.properties
# ❌ android/upload-keystore.jks  
# ❌ android/app/google-services.json
```

## GitHub Authentication

When pushing, use:
- **Username:** manishahirrao
- **Password:** Your Personal Access Token (not GitHub password)

Get token from: https://github.com/settings/tokens

---

**Need help?** See `GIT_SETUP_GUIDE.md` for detailed instructions.
