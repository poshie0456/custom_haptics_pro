# API Reference

Complete API documentation for Custom Haptics Pro.

## Table of Contents

- [CustomHapticsPro](#customhapticspro)
- [HapticPattern](#hapticpattern)
- [HapticEvent](#hapticevent)
- [JSON Format](#json-format)
- [Error Handling](#error-handling)

---

## CustomHapticsPro

Main class for playing haptic feedback.

### Constructor

```dart
final haptics = CustomHapticsPro();
```

The class uses a singleton pattern internally, so multiple instances will share the same haptic engine.

---

### Methods

#### `supportsHaptics()`

Check if the current device supports haptic feedback.

```dart
Future<bool> supportsHaptics()
```

**Returns:** `true` if device supports Core Haptics, `false` otherwise

**Example:**
```dart
bool supported = await haptics.supportsHaptics();
if (!supported) {
  print('Haptics not supported on this device');
  return;
}
```

**Important:**
- Always check before playing haptics
- Returns `false` in iOS Simulator
- Returns `false` on older devices without haptic hardware

---

#### `getPlatformVersion()`

Get the iOS platform version.

```dart
Future<String?> getPlatformVersion()
```

**Returns:** iOS version string (e.g., "iOS 17.0")

**Example:**
```dart
String? version = await haptics.getPlatformVersion();
print('Running on $version');
```

---

#### `startEngine()`

Manually start the haptic engine.

```dart
Future<void> startEngine()
```

**Example:**
```dart
await haptics.startEngine();
```

**Notes:**
- Engine starts automatically when playing patterns
- Useful to pre-initialize engine to reduce first-play latency
- Throws error if device doesn't support haptics

---

#### `stopEngine()`

Stop the haptic engine to conserve battery.

```dart
Future<void> stopEngine()
```

**Example:**
```dart
await haptics.stopEngine();
```

**Best Practice:**
- Call when done playing haptics
- Call when app goes to background
- Engine can be restarted automatically when needed

---

#### `currentTime()`

Get the current haptic engine time in seconds.

```dart
Future<double?> currentTime()
```

**Returns:** Current engine time in seconds, or `0.0` if engine not running

**Example:**
```dart
double? time = await haptics.currentTime();
print('Engine time: $time seconds');
```

---

#### `playTap()`

Play a single tap haptic.

```dart
Future<void> playTap({
  double intensity = 1.0,
  double sharpness = 0.5,
})
```

**Parameters:**
- `intensity` (0.0-1.0): Strength of the haptic. Default: `1.0`
- `sharpness` (0.0-1.0): Crispness of the haptic. Default: `0.5`

**Example:**
```dart
// Default tap
await haptics.playTap();

// Light, soft tap
await haptics.playTap(intensity: 0.3, sharpness: 0.2);

// Strong, sharp tap
await haptics.playTap(intensity: 1.0, sharpness: 1.0);
```

---

#### `playDoubleTap()`

Play a double tap haptic pattern.

```dart
Future<void> playDoubleTap({
  double intensity = 1.0,
  double sharpness = 0.5,
  double delay = 0.1,
})
```

**Parameters:**
- `intensity` (0.0-1.0): Strength of each tap. Default: `1.0`
- `sharpness` (0.0-1.0): Crispness of each tap. Default: `0.5`
- `delay` (seconds): Time between taps. Default: `0.1`

**Example:**
```dart
// Default double tap
await haptics.playDoubleTap();

// Quick double tap
await haptics.playDoubleTap(delay: 0.05);

// Slow, soft double tap
await haptics.playDoubleTap(
  intensity: 0.5,
  sharpness: 0.3,
  delay: 0.2,
);
```

---

#### `playHeartbeat()`

Play a heartbeat pattern (lub-dub, lub-dub).

```dart
Future<void> playHeartbeat({
  double intensity = 1.0,
  double sharpness = 0.5,
})
```

**Parameters:**
- `intensity` (0.0-1.0): Strength of the heartbeat. Default: `1.0`
- `sharpness` (0.0-1.0): Crispness of the heartbeat. Default: `0.5`

**Example:**
```dart
// Default heartbeat
await haptics.playHeartbeat();

// Gentle heartbeat
await haptics.playHeartbeat(intensity: 0.4, sharpness: 0.2);
```

**Pattern Details:**
- Two pairs of taps
- Second tap in each pair is 70% intensity
- 0.05s between taps in pair, 0.75s between pairs

---

#### `playContinuous()`

Play a continuous vibration.

```dart
Future<void> playContinuous({
  required double duration,
  double intensity = 1.0,
  double sharpness = 0.5,
})
```

**Parameters:**
- `duration` (seconds): How long the vibration lasts. **Required**
- `intensity` (0.0-1.0): Strength of the vibration. Default: `1.0`
- `sharpness` (0.0-1.0): Texture of the vibration. Default: `0.5`

**Example:**
```dart
// Half-second buzz
await haptics.playContinuous(duration: 0.5);

// Long, gentle rumble
await haptics.playContinuous(
  duration: 2.0,
  intensity: 0.6,
  sharpness: 0.2,
);

// Short, sharp buzz
await haptics.playContinuous(
  duration: 0.1,
  intensity: 1.0,
  sharpness: 1.0,
);
```

---

#### `playPattern()`

Play a custom haptic pattern.

```dart
Future<void> playPattern(HapticPattern pattern)
```

**Parameters:**
- `pattern`: A `HapticPattern` object defining the haptic sequence

**Example:**
```dart
final pattern = HapticPattern(events: [
  HapticEvent.transient(time: 0.0, intensity: 1.0, sharpness: 0.5),
  HapticEvent.transient(time: 0.1, intensity: 0.8, sharpness: 0.3),
  HapticEvent.continuous(time: 0.3, duration: 0.5, intensity: 0.6),
]);

await haptics.playPattern(pattern);
```

---

#### `playPatternFromJson()`

Play a pattern from AHAP JSON string.

```dart
Future<void> playPatternFromJson(String patternJson)
```

**Parameters:**
- `patternJson`: JSON string in Apple's AHAP format

**Example:**
```dart
const json = '''
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

await haptics.playPatternFromJson(json);
```

---

## HapticPattern

Represents a complete haptic pattern with multiple events.

### Constructor

```dart
HapticPattern({required List<HapticEvent> events})
```

**Parameters:**
- `events`: List of `HapticEvent` objects

---

### Factory Constructors

#### `HapticPattern.tap()`

```dart
factory HapticPattern.tap({
  double intensity = 1.0,
  double sharpness = 0.5,
})
```

Creates a single tap pattern.

---

#### `HapticPattern.doubleTap()`

```dart
factory HapticPattern.doubleTap({
  double intensity = 1.0,
  double sharpness = 0.5,
  double delay = 0.1,
})
```

Creates a double tap pattern.

---

#### `HapticPattern.heartbeat()`

```dart
factory HapticPattern.heartbeat({
  double intensity = 1.0,
  double sharpness = 0.5,
})
```

Creates a heartbeat pattern.

---

#### `HapticPattern.continuous()`

```dart
factory HapticPattern.continuous({
  required double duration,
  double intensity = 1.0,
  double sharpness = 0.5,
})
```

Creates a continuous vibration pattern.

---

### Methods

#### `toJsonString()`

Convert pattern to AHAP JSON string.

```dart
String toJsonString()
```

**Example:**
```dart
final pattern = HapticPattern.tap();
String json = pattern.toJsonString();
print(json);
```

---

## HapticEvent

Represents a single haptic event in a pattern.

### Enums

#### `HapticEventType`

```dart
enum HapticEventType {
  transient,   // Brief tap-like haptic
  continuous,  // Sustained haptic with duration
}
```

---

### Factory Constructors

#### `HapticEvent.transient()`

Create a brief, tap-like haptic event.

```dart
factory HapticEvent.transient({
  required double time,
  double intensity = 1.0,
  double sharpness = 0.5,
})
```

**Parameters:**
- `time` (seconds): When the event occurs (relative to pattern start). **Required**
- `intensity` (0.0-1.0): Strength of the haptic. Default: `1.0`
- `sharpness` (0.0-1.0): Crispness of the haptic. Default: `0.5`

**Example:**
```dart
// Tap at start of pattern
final event1 = HapticEvent.transient(time: 0.0);

// Light tap 0.5 seconds in
final event2 = HapticEvent.transient(
  time: 0.5,
  intensity: 0.3,
  sharpness: 0.2,
);
```

---

#### `HapticEvent.continuous()`

Create a sustained haptic event.

```dart
factory HapticEvent.continuous({
  required double time,
  required double duration,
  double intensity = 1.0,
  double sharpness = 0.5,
})
```

**Parameters:**
- `time` (seconds): When the event starts. **Required**
- `duration` (seconds): How long the event lasts. **Required**
- `intensity` (0.0-1.0): Strength of the haptic. Default: `1.0`
- `sharpness` (0.0-1.0): Texture of the haptic. Default: `0.5`

**Example:**
```dart
// Half-second buzz starting immediately
final event1 = HapticEvent.continuous(
  time: 0.0,
  duration: 0.5,
);

// Gentle rumble starting at 1 second
final event2 = HapticEvent.continuous(
  time: 1.0,
  duration: 2.0,
  intensity: 0.4,
  sharpness: 0.1,
);
```

---

## JSON Format

### Structure

```json
{
  "Pattern": [
    {
      "EventType": "HapticTransient" | "HapticContinuous",
      "Time": <number>,
      "EventDuration": <number>,  // Only for Continuous
      "EventParameters": [
        {
          "ParameterID": "HapticIntensity" | "HapticSharpness",
          "ParameterValue": <number>
        }
      ]
    }
  ]
}
```

### Field Reference

| Field | Type | Required | Valid Values | Description |
|-------|------|----------|--------------|-------------|
| `Pattern` | Array | Yes | Array of events | Root array containing all haptic events |
| `EventType` | String | Yes | `"HapticTransient"` or `"HapticContinuous"` | Type of haptic event |
| `Time` | Number | Yes | ≥ 0.0 | When event occurs (seconds) |
| `EventDuration` | Number | For Continuous only | > 0.0 | How long event lasts (seconds) |
| `EventParameters` | Array | Yes | Array of parameters | Event parameters |
| `ParameterID` | String | Yes | `"HapticIntensity"` or `"HapticSharpness"` | Parameter identifier |
| `ParameterValue` | Number | Yes | 0.0 - 1.0 | Parameter value |

### Complete Example

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
      "EventType": "HapticContinuous",
      "Time": 0.2,
      "EventDuration": 0.5,
      "EventParameters": [
        {"ParameterID": "HapticIntensity", "ParameterValue": 0.8},
        {"ParameterID": "HapticSharpness", "ParameterValue": 0.3}
      ]
    }
  ]
}
```

---

## Error Handling

### Common Errors

#### Device Not Supported

```dart
try {
  await haptics.startEngine();
} catch (e) {
  if (e.toString().contains('UNSUPPORTED')) {
    print('Device does not support haptics');
  }
}
```

#### Invalid JSON

```dart
try {
  await haptics.playPatternFromJson(invalidJson);
} catch (e) {
  if (e.toString().contains('INVALID_JSON')) {
    print('JSON pattern is malformed');
  }
}
```

#### Engine Error

```dart
try {
  await haptics.playTap();
} catch (e) {
  if (e.toString().contains('ENGINE_ERROR')) {
    print('Haptic engine failed to start or play');
  }
}
```

### Best Practices

1. **Always check device support:**
   ```dart
   if (await haptics.supportsHaptics()) {
     await haptics.playTap();
   }
   ```

2. **Handle errors gracefully:**
   ```dart
   try {
     await haptics.playPattern(pattern);
   } catch (e) {
     print('Failed to play haptic: $e');
     // Continue without haptics
   }
   ```

3. **Test on real devices:**
   - Simulator doesn't support haptics
   - Always test on physical hardware

---

## Parameter Guidelines

### Intensity (0.0 - 1.0)

| Value | Description | Use Case |
|-------|-------------|----------|
| 0.0 - 0.3 | Light | Subtle feedback, background notifications |
| 0.4 - 0.6 | Medium | Standard UI interactions, confirmations |
| 0.7 - 0.9 | Strong | Important actions, warnings |
| 1.0 | Maximum | Critical alerts, errors |

### Sharpness (0.0 - 1.0)

| Value | Description | Feel |
|-------|-------------|------|
| 0.0 - 0.3 | Dull | Soft, rounded, rumble-like |
| 0.4 - 0.6 | Balanced | General purpose |
| 0.7 - 1.0 | Sharp | Crisp, precise, tap-like |

### Timing

- **Transient taps:** Instant feedback, no duration
- **Continuous buzz:** Minimum ~0.05s for noticeable effect
- **Between events:** 0.05s minimum for distinct haptics
- **Pattern duration:** Keep under 3-5 seconds for best UX

---

## Complete Usage Example

```dart
import 'package:flutter/material.dart';
import 'package:custom_haptics_pro/custom_haptics_pro.dart';

class HapticDemo extends StatefulWidget {
  @override
  _HapticDemoState createState() => _HapticDemoState();
}

class _HapticDemoState extends State<HapticDemo> {
  final haptics = CustomHapticsPro();
  bool isSupported = false;

  @override
  void initState() {
    super.initState();
    _checkSupport();
  }

  Future<void> _checkSupport() async {
    final supported = await haptics.supportsHaptics();
    setState(() {
      isSupported = supported;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isSupported) {
      return Text('Haptics not supported on this device');
    }

    return Column(
      children: [
        ElevatedButton(
          onPressed: () => haptics.playTap(),
          child: Text('Tap'),
        ),
        ElevatedButton(
          onPressed: () => haptics.playDoubleTap(),
          child: Text('Double Tap'),
        ),
        ElevatedButton(
          onPressed: () => haptics.playHeartbeat(),
          child: Text('Heartbeat'),
        ),
        ElevatedButton(
          onPressed: () => haptics.playContinuous(duration: 0.5),
          child: Text('Buzz'),
        ),
      ],
    );
  }
}
```

---

For more examples, see the [example app](example/) or the [README.md](README.md).
