# Troubleshooting Guide

Common issues and solutions for Custom Haptics Pro.

## Table of Contents

- [No Haptic Feedback](#no-haptic-feedback)
- [Testing Issues](#testing-issues)
- [Build Errors](#build-errors)
- [Runtime Errors](#runtime-errors)
- [Performance Issues](#performance-issues)
- [Publishing Issues](#publishing-issues)

---

## No Haptic Feedback

### Issue: Haptics don't work at all

**Symptoms:**
- Calling `playTap()` or other methods does nothing
- No vibration or feedback felt

**Solutions:**

#### 1. Check if using iOS Simulator
❌ **Simulator does NOT support haptics**

```dart
// This will work in code but produce no haptic feedback in Simulator
await haptics.playTap();  // Silent in Simulator
```

✅ **Solution:** Test on a real iOS device (iPhone, iPad)

#### 2. Check device support

```dart
bool supported = await haptics.supportsHaptics();
if (!supported) {
  print('This device does not support haptics');
}
```

**Devices without haptic support:**
- Old iPhones (iPhone 6 and earlier)
- Some iPads (older models)
- iOS Simulator (always returns false)

#### 3. Check iOS version

Requires iOS 13.0 or later. Check with:

```dart
String? version = await haptics.getPlatformVersion();
print(version);  // Should be iOS 13.0+
```

#### 4. Check device settings

On the physical device:
1. Go to Settings → Sounds & Haptics
2. Ensure "System Haptics" is enabled
3. Check that device is not in silent mode (for some haptic types)

---

## Testing Issues

### Issue: Can't test haptics during development

**Problem:** iOS Simulator doesn't support haptics

**Solutions:**

#### Option 1: Use a real device (Recommended)
```bash
# Connect iPhone/iPad via cable or WiFi
flutter run --release
```

#### Option 2: Add debug logging
```dart
Future<void> testHaptic() async {
  print('Testing haptic support...');
  bool supported = await haptics.supportsHaptics();
  print('Supported: $supported');

  if (supported) {
    print('Playing tap...');
    await haptics.playTap();
    print('Tap completed');
  }
}
```

#### Option 3: Mock for development
```dart
class HapticWrapper {
  final haptics = CustomHapticsPro();

  Future<void> playTap() async {
    if (await haptics.supportsHaptics()) {
      await haptics.playTap();
    } else {
      debugPrint('Haptic would play here');
    }
  }
}
```

---

## Build Errors

### Issue: "Module 'custom_haptics_pro' not found"

**Solution:**

```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
flutter build ios
```

### Issue: "Undefined symbol: OBJC_CLASS$_CHHapticEngine"

**Cause:** iOS deployment target is too low

**Solution:**

In `ios/Podfile`, ensure minimum iOS version is 13.0:

```ruby
platform :ios, '13.0'
```

Then:
```bash
cd ios
pod install
```

### Issue: Swift version errors

**Solution:**

Ensure you're using Swift 5+. In Xcode:
1. Open `ios/Runner.xcworkspace`
2. Select Runner project
3. Build Settings → Swift Language Version → Swift 5

---

## Runtime Errors

### Error: "Device does not support haptics"

**Message:**
```
PlatformException (UNSUPPORTED, Device does not support haptics, null, null)
```

**Cause:** Device doesn't have haptic hardware or iOS is too old

**Solution:**
```dart
// Always check before playing
try {
  if (await haptics.supportsHaptics()) {
    await haptics.playTap();
  } else {
    // Provide alternative feedback
    print('Haptics not available');
  }
} catch (e) {
  print('Haptic error: $e');
}
```

---

### Error: "Failed to start haptic engine"

**Message:**
```
PlatformException (ENGINE_ERROR, Failed to start haptic engine: ..., null, null)
```

**Possible Causes:**
1. Low battery mode enabled
2. Device overheating
3. System resources exhausted
4. Background app restrictions

**Solution:**
```dart
try {
  await haptics.startEngine();
} catch (e) {
  print('Engine failed to start: $e');
  // Continue without haptics
  showSnackBar('Haptic feedback unavailable');
}
```

**User Actions:**
- Disable Low Power Mode
- Let device cool down
- Restart the app
- Restart the device

---

### Error: "Invalid pattern JSON format"

**Message:**
```
PlatformException (INVALID_JSON, Invalid pattern JSON format, null, null)
```

**Cause:** Malformed JSON passed to `playPatternFromJson()`

**Solution:**

Check your JSON format:

✅ **Correct:**
```dart
const validJson = '''
{
  "Pattern": [
    {
      "EventType": "HapticTransient",
      "Time": 0.0,
      "EventParameters": [
        {"ParameterID": "HapticIntensity", "ParameterValue": 1.0},
        {"ParameterID": "HapticSharpness", "ParameterValue": 0.5}
      ]
    }
  ]
}
''';
```

❌ **Incorrect:**
```dart
const invalidJson = '''
{
  "Pattern": [
    {
      "EventType": "HapticTransient",
      "Time": 0.0
      // Missing EventParameters!
    }
  ]
}
''';
```

**Validation:**
```dart
try {
  await haptics.playPatternFromJson(jsonString);
} catch (e) {
  print('Invalid JSON: $e');
  // Use programmatic pattern instead
  await haptics.playTap();
}
```

---

### Error: "Playback error"

**Message:**
```
PlatformException (PLAYBACK_ERROR, Failed to play haptic pattern: ..., null, null)
```

**Possible Causes:**
1. Pattern is too complex
2. Invalid parameter values
3. Engine not ready
4. System interruption

**Solution:**

1. **Verify parameter ranges:**
```dart
// Ensure values are 0.0 to 1.0
final event = HapticEvent.transient(
  time: 0.0,
  intensity: 0.5.clamp(0.0, 1.0),  // Safe
  sharpness: 0.5.clamp(0.0, 1.0),  // Safe
);
```

2. **Simplify pattern:**
```dart
// Instead of complex pattern, use simple one
try {
  await haptics.playPattern(complexPattern);
} catch (e) {
  // Fallback to simple tap
  await haptics.playTap();
}
```

3. **Ensure engine is ready:**
```dart
await haptics.startEngine();
await Future.delayed(Duration(milliseconds: 100));
await haptics.playPattern(pattern);
```

---

## Performance Issues

### Issue: Haptics feel delayed or laggy

**Causes:**
- Engine not pre-initialized
- Heavy UI operations blocking thread
- Pattern too complex

**Solutions:**

#### 1. Pre-start the engine
```dart
@override
void initState() {
  super.initState();
  _initHaptics();
}

Future<void> _initHaptics() async {
  if (await haptics.supportsHaptics()) {
    await haptics.startEngine();
  }
}
```

#### 2. Use async/await properly
```dart
// ❌ Don't block UI
void onButtonPress() {
  haptics.playTap().then((_) {
    // This delays UI feedback
  });
}

// ✅ Fire and forget for immediate feedback
void onButtonPress() {
  haptics.playTap();  // Don't await
  // Continue with UI updates
}
```

#### 3. Simplify patterns
```dart
// ❌ Too complex
final complex = HapticPattern(events: List.generate(
  100,
  (i) => HapticEvent.transient(time: i * 0.01),
));

// ✅ Simpler is better
final simple = HapticPattern.doubleTap();
```

---

### Issue: Battery draining quickly

**Cause:** Haptic engine running continuously

**Solution:**

```dart
class HapticManager {
  final haptics = CustomHapticsPro();

  // Stop engine when app goes to background
  void onAppPaused() {
    haptics.stopEngine();
  }

  // Stop after haptic sequence
  Future<void> playSequence() async {
    await haptics.playHeartbeat();
    await haptics.stopEngine();  // Save battery
  }
}
```

**With AppLifecycleState:**
```dart
class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final haptics = CustomHapticsPro();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    haptics.stopEngine();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      haptics.stopEngine();
    }
  }
}
```

---

## Publishing Issues

### Issue: `flutter pub publish` fails with analysis errors

**Error:**
```
Package has 5 warnings.
```

**Solution:**

```bash
# View all warnings
flutter analyze

# Fix warnings in code
# Then try again
flutter pub publish --dry-run
```

---

### Issue: "Package name already exists"

**Solution:** Choose a different unique name

```yaml
# In pubspec.yaml
name: my_custom_haptics_pro  # Make it unique
```

---

### Issue: "Description too short/long"

**Requirement:** 60-180 characters

**Solution:**

```yaml
# ❌ Too short (30 chars)
description: Custom haptic plugin

# ✅ Just right (120 chars)
description: A Flutter plugin for creating custom haptic feedback patterns on iOS using Apple's Core Haptics framework.
```

---

### Issue: Missing LICENSE file

**Error:**
```
Package must have a LICENSE file
```

**Solution:**

Create `LICENSE` file with MIT License:

```
MIT License

Copyright (c) 2024 Your Name

Permission is hereby granted, free of charge, to any person obtaining a copy...
```

---

## Debug Checklist

When haptics aren't working, check:

- [ ] Using a real iOS device (not Simulator)
- [ ] iOS version is 13.0 or higher
- [ ] Device supports haptics (`supportsHaptics()` returns true)
- [ ] System Haptics enabled in device Settings
- [ ] Low Power Mode is disabled
- [ ] App has proper permissions (none required, but check Settings → Privacy)
- [ ] Flutter version is up to date (`flutter upgrade`)
- [ ] Dependencies are installed (`flutter pub get`)
- [ ] iOS pods are installed (`cd ios && pod install`)
- [ ] Clean build (`flutter clean && flutter pub get`)

---

## Getting Help

If you're still experiencing issues:

1. **Check the Example App**
   ```bash
   cd example
   flutter run --release  # On real device
   ```
   If the example works, the issue is in your implementation.

2. **Enable Debug Logging**
   ```dart
   try {
     print('About to play haptic');
     await haptics.playTap();
     print('Haptic played successfully');
   } catch (e, stack) {
     print('Error: $e');
     print('Stack: $stack');
   }
   ```

3. **Check GitHub Issues**
   - Visit the [issue tracker](https://github.com/yourusername/custom_haptics_pro/issues)
   - Search for similar issues
   - Create a new issue with:
     - Device model and iOS version
     - Flutter version (`flutter --version`)
     - Code snippet that reproduces the issue
     - Error messages

4. **Review Documentation**
   - [README.md](README.md)
   - [API Reference](API_REFERENCE.md)
   - [Apple Core Haptics Docs](https://developer.apple.com/documentation/corehaptics)

---

## Common Misconceptions

### ❌ "Haptics work in iOS Simulator"
**Reality:** Simulator NEVER supports haptics. Always test on real devices.

### ❌ "All iPhones support haptics"
**Reality:** Only iPhone 7 and newer have Taptic Engine. Older devices return `supportsHaptics() = false`.

### ❌ "Haptics work on Android"
**Reality:** This plugin is iOS-only. Android requires a different implementation.

### ❌ "I can feel haptics with sound off"
**Reality:** Some haptics are affected by silent mode, but most should work regardless. Test with sound on and off.

### ❌ "More intensity = better UX"
**Reality:** Subtle haptics (0.3-0.6 intensity) often feel better than maximum intensity. Test with real users.

---

## Still Need Help?

Create a GitHub issue with:

```markdown
**Device & Environment:**
- Device: iPhone 13
- iOS Version: 17.0
- Flutter Version: 3.x.x
- Plugin Version: 0.0.1

**Issue:**
[Describe what's happening]

**Expected:**
[What should happen]

**Code:**
```dart
// Minimal code that reproduces the issue
final haptics = CustomHapticsPro();
await haptics.playTap();
```

**Error Message:**
```
[Paste any error messages]
```
```

We're here to help! 🎉
