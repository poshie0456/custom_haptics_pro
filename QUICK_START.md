# Quick Start Guide

Get started with Custom Haptics Pro in 5 minutes!

## ⚠️ Before You Start

**IMPORTANT: This plugin requires a real iOS device for testing!**

- ❌ Does NOT work in iOS Simulator
- ✅ MUST use physical iPhone/iPad with iOS 13.0+
- ✅ Test on real hardware to feel haptic feedback

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  custom_haptics_pro: ^0.0.1
```

Run:
```bash
flutter pub get
```

## Basic Usage

### 1. Import the package

```dart
import 'package:custom_haptics_pro/custom_haptics_pro.dart';
```

### 2. Create an instance

```dart
final haptics = CustomHapticsPro();
```

### 3. Check device support (optional but recommended)

```dart
bool supported = await haptics.supportsHaptics();
if (!supported) {
  print('This device does not support haptics');
  return;
}
```

### 4. Play haptics!

```dart
// Simple tap
await haptics.playTap();

// Double tap
await haptics.playDoubleTap();

// Heartbeat pattern
await haptics.playHeartbeat();

// Continuous vibration for 0.5 seconds
await haptics.playContinuous(duration: 0.5);
```

## Customization

All methods support intensity and sharpness customization:

```dart
// Light, soft tap
await haptics.playTap(intensity: 0.3, sharpness: 0.2);

// Strong, sharp tap
await haptics.playTap(intensity: 1.0, sharpness: 1.0);
```

## Custom Patterns

Create your own unique haptic patterns:

```dart
final pattern = HapticPattern(events: [
  HapticEvent.transient(time: 0, intensity: 1.0, sharpness: 0.5),
  HapticEvent.transient(time: 0.1, intensity: 0.7, sharpness: 0.3),
  HapticEvent.continuous(time: 0.3, duration: 0.5, intensity: 0.6),
]);

await haptics.playPattern(pattern);
```

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:custom_haptics_pro/custom_haptics_pro.dart';

class HapticButton extends StatelessWidget {
  final haptics = CustomHapticsPro();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Play a tap haptic when button is pressed
        await haptics.playTap();
      },
      child: Text('Tap Me!'),
    );
  }
}
```

## Next Steps

- See [README.md](README.md) for full API documentation
- Check out the [example app](example) for more patterns
- Learn about haptic parameters in the [Understanding Haptic Parameters](README.md#understanding-haptic-parameters) section

## Tips

1. **Testing**: ALWAYS use a real iOS device - simulator doesn't support haptics
2. **Device Check**: Always call `supportsHaptics()` before playing patterns
3. **Battery**: Stop the engine when done: `await haptics.stopEngine()`
4. **Intensity**: Start with 0.5-0.7 for most use cases
5. **Sharpness**: Use 0.5 as default, adjust based on your needs

## Limitations to Remember

- ⚠️ **Real device required** - iOS Simulator will not produce any haptics
- ⚠️ **iOS only** - No Android support (uses Apple's Core Haptics framework)
- ⚠️ **iOS 13.0+** - Older iOS versions not supported
- ⚠️ **Device specific** - Not all iOS devices have haptic capabilities

Happy haptic coding!
