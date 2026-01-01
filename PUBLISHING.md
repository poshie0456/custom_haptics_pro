# Publishing Guide

This guide covers how to publish the Custom Haptics Pro plugin to both pub.dev and GitHub.

## Prerequisites

Before publishing, ensure you have:

- [x] A Google account (for pub.dev)
- [x] A GitHub account
- [x] Git installed on your machine
- [x] Flutter SDK installed
- [x] Write access to your package directory

## Part 1: Publishing to GitHub

### Step 1: Create a GitHub Repository

1. Go to [GitHub](https://github.com) and sign in
2. Click the `+` icon in the top-right corner
3. Select "New repository"
4. Configure your repository:
   - **Repository name**: `custom_haptics_pro` (or your preferred name)
   - **Description**: "A Flutter plugin for creating custom haptic feedback patterns on iOS using Apple's Core Haptics framework"
   - **Visibility**: Choose Public (required for pub.dev)
   - **DO NOT** initialize with README, .gitignore, or license (we already have these)
5. Click "Create repository"

### Step 2: Initialize Local Git Repository

Open terminal in your package directory and run:

```bash
cd /path/to/custom_haptics_pro

# Initialize git if not already done
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Custom Haptics Pro plugin"
```

### Step 3: Link to GitHub and Push

Replace `YOUR_USERNAME` with your GitHub username:

```bash
# Add remote repository
git remote add origin https://github.com/YOUR_USERNAME/custom_haptics_pro.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### Step 4: Create a Release Tag

It's best practice to tag your releases:

```bash
# Create a tag for version 0.0.1
git tag -a v0.0.1 -m "Release version 0.0.1"

# Push the tag to GitHub
git push origin v0.0.1
```

### Step 5: Create a GitHub Release (Optional but Recommended)

1. Go to your repository on GitHub
2. Click on "Releases" (right sidebar)
3. Click "Create a new release"
4. Select the tag you just created (`v0.0.1`)
5. Title: `v0.0.1 - Initial Release`
6. Description: Add release notes (features, changes, etc.)
7. Click "Publish release"

## Part 2: Publishing to pub.dev

### Step 1: Verify Package Structure

Ensure your package has the required files:

```bash
custom_haptics_pro/
├── lib/
│   ├── custom_haptics_pro.dart
│   └── ...
├── ios/
│   └── ...
├── example/
│   └── ...
├── CHANGELOG.md
├── LICENSE
├── pubspec.yaml
└── README.md
```

### Step 2: Update pubspec.yaml

Make sure your `pubspec.yaml` is properly configured:

```yaml
name: custom_haptics_pro
description: A Flutter plugin for creating custom haptic feedback patterns on iOS using Apple's Core Haptics framework.
version: 0.0.1
homepage: https://github.com/YOUR_USERNAME/custom_haptics_pro
repository: https://github.com/YOUR_USERNAME/custom_haptics_pro
issue_tracker: https://github.com/YOUR_USERNAME/custom_haptics_pro/issues

environment:
  sdk: '>=3.1.0 <4.0.0'
  flutter: ">=3.3.0"

# ... rest of your pubspec.yaml
```

**Important fields:**
- `name`: Must be unique on pub.dev
- `description`: 60-180 characters describing your package
- `version`: Follow [semantic versioning](https://semver.org/)
- `homepage`: Link to your GitHub repository
- `repository`: Same as homepage for GitHub projects
- `issue_tracker`: Where users report issues

### Step 3: Update CHANGELOG.md

Ensure your `CHANGELOG.md` is up to date:

```markdown
## 0.0.1

* Initial release
* Support for custom haptic patterns
* Pre-built patterns (tap, double tap, heartbeat)
* JSON/AHAP format support
* iOS 13.0+ support
```

### Step 4: Validate Your Package

Run the following commands to validate your package:

```bash
# Analyze your code for issues
flutter pub publish --dry-run
```

This will:
- Check your package structure
- Validate pubspec.yaml
- Check for any warnings or errors
- Show you what will be published

**Fix any warnings or errors before proceeding.**

### Step 5: Publish to pub.dev

```bash
# Publish your package
flutter pub publish
```

You'll be prompted to:
1. Confirm the package upload
2. Grant pub.dev access to your Google account (first time only)
3. Authorize the publication

**Note:** Once published, you **cannot delete** a package version. You can only publish newer versions.

### Step 6: Verify Publication

1. Go to https://pub.dev/packages/custom_haptics_pro
2. Check that all information is correct
3. Verify documentation is rendering properly
4. Test the example code

## Part 3: Post-Publication Checklist

### Update README with Installation Instructions

Make sure your README shows the correct installation:

```yaml
dependencies:
  custom_haptics_pro: ^0.0.1
```

### Add pub.dev Badge to README

Add this to the top of your README.md:

```markdown
[![pub package](https://img.shields.io/pub/v/custom_haptics_pro.svg)](https://pub.dev/packages/custom_haptics_pro)
[![GitHub](https://img.shields.io/github/stars/YOUR_USERNAME/custom_haptics_pro?style=social)](https://github.com/YOUR_USERNAME/custom_haptics_pro)
```

### Monitor Your Package

- Check the pub.dev package page for any issues
- Monitor GitHub issues
- Respond to user questions and feedback

## Part 4: Publishing Updates

When you have new features or bug fixes:

### Step 1: Update Version

Update the version in `pubspec.yaml` following semantic versioning:
- **Patch** (0.0.X): Bug fixes, minor changes
- **Minor** (0.X.0): New features, backward compatible
- **Major** (X.0.0): Breaking changes

```yaml
version: 0.0.2  # or 0.1.0, or 1.0.0
```

### Step 2: Update CHANGELOG.md

```markdown
## 0.0.2

* Fixed bug in haptic engine initialization
* Improved error handling
* Updated documentation

## 0.0.1

* Initial release
```

### Step 3: Commit and Tag

```bash
git add .
git commit -m "Version 0.0.2: Bug fixes and improvements"
git tag -a v0.0.2 -m "Release version 0.0.2"
git push origin main
git push origin v0.0.2
```

### Step 4: Publish Update

```bash
flutter pub publish --dry-run  # Validate first
flutter pub publish            # Publish the update
```

## Troubleshooting

### Common Issues

**Issue:** "Package name already exists"
- **Solution:** Choose a different, unique package name

**Issue:** "Version already exists"
- **Solution:** Increment the version number in pubspec.yaml

**Issue:** "Analysis errors found"
- **Solution:** Run `flutter analyze` and fix all errors/warnings

**Issue:** "Missing required fields in pubspec.yaml"
- **Solution:** Ensure all required fields (name, description, version) are present

**Issue:** "Authentication failed"
- **Solution:** Run `flutter pub logout` then `flutter pub publish` again

### Getting Help

- [pub.dev Publishing Guide](https://dart.dev/tools/pub/publishing)
- [Flutter Package Development](https://docs.flutter.dev/development/packages-and-plugins/developing-packages)
- [Semantic Versioning](https://semver.org/)

## Best Practices

1. **Test thoroughly** before publishing
2. **Write clear documentation** in README.md
3. **Include examples** showing how to use your package
4. **Respond to issues** on GitHub
5. **Keep dependencies up to date**
6. **Follow semantic versioning**
7. **Write meaningful commit messages**
8. **Add tests** to ensure reliability
9. **Document breaking changes** clearly
10. **Keep CHANGELOG.md updated**

## Package Naming Conventions

- Use lowercase with underscores (snake_case)
- Be descriptive but concise
- Avoid using "flutter_" prefix (not required)
- Check availability on pub.dev before choosing

## License

Make sure you have a LICENSE file. MIT License is common for open source:

```
MIT License

Copyright (c) 2024 [Your Name]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

---

**You're all set!** Your package is now available for the Flutter community to use. 🎉
