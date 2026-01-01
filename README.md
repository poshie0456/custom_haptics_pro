# Custom Haptics Pro

[![pub package](https://img.shields.io/pub/v/custom_haptics_pro.svg)](https://pub.dev/packages/custom_haptics_pro)
[![GitHub](https://img.shields.io/github/stars/poshie0456/custom_haptics_pro?style=social)](https://github.com/poshie0456/custom_haptics_pro)

A Flutter plugin for creating custom haptic feedback patterns on iOS using Apple's Core Haptics framework.

## Features

- Simple, easy-to-use API for custom haptics
- Pre-built haptic patterns (tap, double tap, heartbeat, etc.)
- Support for custom haptic patterns with full control
- Intensity and sharpness adjustments
- Both transient (tap) and continuous (vibration) haptics
- Automatic haptic engine management
- Direct JSON pattern support compatible with Apple's AHAP format

## Platform Support

- ✅ iOS 13.0+
- ✅ iPadOS 13.0+
- ✅ Mac Catalyst 13.0+

Note: This plugin uses Apple's Core Haptics framework, which is only available on iOS and related platforms. Documentation found here https://developer.apple.com/documentation/corehaptics/chhapticengine

## ⚠️ Important Limitations

### Testing Requirements
- **MUST use a real iOS device** - Haptic feedback does NOT work in the iOS Simulator
- The Simulator will not produce any vibrations or haptic feedback
- Always test on physical hardware (iPhone, iPad, or Mac with haptic support)

### Device Support
- Not all iOS devices support haptic feedback
- Older devices may return `false` from `supportsHaptics()`
- Always check device support before playing haptics:
  ```dart
  if (await haptics.supportsHaptics()) {
    await haptics.playTap();
  }
  ```

### Platform Limitations
- iOS/iPadOS only - no Android support
- Requires iOS 13.0 or later
- Some devices (older iPhones/iPads) may have limited or no haptic capabilities

## 📚 Documentation

- **[Quick Start Guide](QUICK_START.md)** - Get started in 5 minutes
- **[API Reference](API_REFERENCE.md)** - Complete API documentation
- **[Troubleshooting](TROUBLESHOOTING.md)** - Common issues and solutions
- **[Publishing Guide](PUBLISHING.md)** - How to publish to pub.dev and GitHub
- **[Pre-Publish Checklist](PRE_PUBLISH_CHECKLIST.md)** - Ensure you're ready to publish

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  custom_haptics_pro: ^0.0.1
```

## Usage

### Check Haptics Support

```dart
import 'package:custom_haptics_pro/custom_haptics_pro.dart';

final haptics = CustomHapticsPro();

// Check if device supports haptics
bool supported = await haptics.supportsHaptics();
```

### Simple Haptics

```dart
// Play a single tap
await haptics.playTap();

// Play a double tap
await haptics.playDoubleTap();

// Play a heartbeat pattern
await haptics.playHeartbeat();

// Play a continuous vibration
await haptics.playContinuous(duration: 0.5);
```

### Customizing Intensity and Sharpness

```dart
// Light tap
await haptics.playTap(intensity: 0.3, sharpness: 0.2);

// Strong sharp tap
await haptics.playTap(intensity: 1.0, sharpness: 1.0);

// Dull continuous vibration
await haptics.playContinuous(
  duration: 1.0,
  intensity: 0.6,
  sharpness: 0.0,
);
```

### Custom Patterns

Create your own haptic patterns:

```dart
import 'package:custom_haptics_pro/custom_haptics_pro.dart';

// Create a custom pattern with multiple events
final pattern = HapticPattern(events: [
  HapticEvent.transient(
    time: 0,
    intensity: 1.0,
    sharpness: 0.5,
  ),
  HapticEvent.transient(
    time: 0.1,
    intensity: 0.8,
    sharpness: 0.3,
  ),
  HapticEvent.continuous(
    time: 0.3,
    duration: 0.5,
    intensity: 0.6,
    sharpness: 0.2,
  ),
]);

// Play the pattern
await haptics.playPattern(pattern);
```

### Engine Management

The haptic engine is automatically started when needed, but you can manage it manually:

```dart
// Start the engine
await haptics.startEngine();

// Play haptics...

// Stop the engine to save battery
await haptics.stopEngine();
```

## API Reference

### CustomHapticsPro

Main class for playing haptics.

#### Methods

- `supportsHaptics()` - Check if device supports haptics
- `getPlatformVersion()` - Get the platform version
- `startEngine()` - Manually start the haptic engine
- `stopEngine()` - Manually stop the haptic engine
- `currentTime()` - Get current engine time
- `playTap({intensity, sharpness})` - Play a single tap
- `playDoubleTap({intensity, sharpness, delay})` - Play a double tap
- `playHeartbeat({intensity, sharpness})` - Play a heartbeat pattern
- `playContinuous({duration, intensity, sharpness})` - Play continuous vibration
- `playPattern(HapticPattern pattern)` - Play a custom pattern

### HapticPattern

Represents a complete haptic pattern with multiple events.

#### Factory Constructors

- `HapticPattern.tap({intensity, sharpness})` - Single tap pattern
- `HapticPattern.doubleTap({intensity, sharpness, delay})` - Double tap pattern
- `HapticPattern.heartbeat({intensity, sharpness})` - Heartbeat pattern
- `HapticPattern.continuous({duration, intensity, sharpness})` - Continuous pattern

#### Custom Constructor

```dart
HapticPattern({required List<HapticEvent> events})
```

### HapticEvent

Represents a single haptic event.

#### Factory Constructors

- `HapticEvent.transient({time, intensity, sharpness})` - Brief tap-like haptic
- `HapticEvent.continuous({time, duration, intensity, sharpness})` - Sustained haptic

#### Parameters

- `time` - When the event occurs (in seconds)
- `intensity` - Strength of the haptic (0.0 to 1.0)
- `sharpness` - Crispness of the haptic (0.0 to 1.0)
- `duration` - Length of continuous events (in seconds)

## Example

See the [example](example) directory for a complete demo app showing all features.

## Understanding Haptic Parameters

### Intensity (0.0 to 1.0)

Controls the strength of the haptic feedback:
- `0.0` - No feedback
- `0.3` - Light, subtle feedback
- `0.6` - Medium feedback
- `1.0` - Strong, powerful feedback

### Sharpness (0.0 to 1.0)

Controls the feel/texture of the haptic:
- `0.0` - Dull, soft, rounded feeling
- `0.5` - Balanced
- `1.0` - Sharp, crisp, precise feeling

### Event Types

- **Transient**: Brief, tap-like haptic (like a drum hit)
- **Continuous**: Sustained haptic with duration (like a buzz)

## Advanced: JSON Pattern Format

Custom Haptics Pro supports Apple's AHAP (Apple Haptic and Audio Pattern) JSON format. You can create patterns programmatically or load them from JSON files.

### JSON Structure

```json
{
  "Pattern": [
    {
      "EventType": "HapticTransient",
      "Time": 0.0,
      "EventParameters": [
        {
          "ParameterID": "HapticIntensity",
          "ParameterValue": 1.0
        },
        {
          "ParameterID": "HapticSharpness",
          "ParameterValue": 0.5
        }
      ]
    },
    {
      "EventType": "HapticContinuous",
      "Time": 0.2,
      "EventDuration": 0.5,
      "EventParameters": [
        {
          "ParameterID": "HapticIntensity",
          "ParameterValue": 0.8
        },
        {
          "ParameterID": "HapticSharpness",
          "ParameterValue": 0.3
        }
      ]
    }
  ]
}
```

### JSON Field Reference

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `Pattern` | Array | Yes | Root array containing all haptic events |
| `EventType` | String | Yes | Either `"HapticTransient"` or `"HapticContinuous"` |
| `Time` | Number | Yes | When the event occurs (in seconds, relative to pattern start) |
| `EventDuration` | Number | Only for Continuous | How long the continuous haptic lasts (in seconds) |
| `EventParameters` | Array | Yes | Array of parameter objects |
| `ParameterID` | String | Yes | Either `"HapticIntensity"` or `"HapticSharpness"` |
| `ParameterValue` | Number | Yes | Value between 0.0 and 1.0 |

### Using JSON Patterns in Code

```dart
// Option 1: Use HapticPattern classes (recommended)
final pattern = HapticPattern(events: [
  HapticEvent.transient(time: 0, intensity: 1.0, sharpness: 0.5),
  HapticEvent.continuous(time: 0.2, duration: 0.5, intensity: 0.8, sharpness: 0.3),
]);
await haptics.playPattern(pattern);

// Option 2: Load from JSON string
const jsonPattern = '''
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
await haptics.playPatternFromJson(jsonPattern);

// Option 3: Load from .ahap file
final jsonString = await rootBundle.loadString('assets/haptics/custom_pattern.ahap');
await haptics.playPatternFromJson(jsonString);
```

### Example JSON Patterns

**Simple Tap:**
```json
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
```

**Double Tap:**
```json
{
  "Pattern": [
    {
      "EventType": "HapticTransient",
      "Time": 0.0,
      "EventParameters": [
        {"ParameterID": "HapticIntensity", "ParameterValue": 1.0},
        {"ParameterID": "HapticSharpness", "ParameterValue": 0.5}
      ]
    },
    {
      "EventType": "HapticTransient",
      "Time": 0.1,
      "EventParameters": [
        {"ParameterID": "HapticIntensity", "ParameterValue": 1.0},
        {"ParameterID": "HapticSharpness", "ParameterValue": 0.5}
      ]
    }
  ]
}
```

**Buzz Pattern:**
```json
{
  "Pattern": [
    {
      "EventType": "HapticContinuous",
      "Time": 0.0,
      "EventDuration": 0.5,
      "EventParameters": [
        {"ParameterID": "HapticIntensity", "ParameterValue": 0.8},
        {"ParameterID": "HapticSharpness", "ParameterValue": 0.2}
      ]
    }
  ]
}
```

## Core Haptics Documentation

This plugin is built on Apple's Core Haptics framework. For more information:
- [Apple Core Haptics Documentation](https://developer.apple.com/documentation/corehaptics)
- [Playing a Single Tap Haptic](https://developer.apple.com/documentation/corehaptics/playing-a-single-tap-haptic-pattern)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Publishing

Want to publish your own fork or contribute? See the [PUBLISHING.md](PUBLISHING.md) guide for detailed instructions on how to publish to pub.dev and GitHub.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
