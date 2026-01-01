# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2024-01-01

### Added
- ✨ Initial release of Custom Haptics Pro
- 🎯 Simple API with pre-built haptic patterns:
  - `playTap()` - Single tap haptic
  - `playDoubleTap()` - Double tap haptic
  - `playHeartbeat()` - Heartbeat pattern
  - `playContinuous()` - Continuous vibration
- 🔧 Custom pattern creation using `HapticPattern` and `HapticEvent` classes
- 📊 Full intensity (0.0-1.0) and sharpness (0.0-1.0) control
- ⚡ Support for transient (tap-like) and continuous (sustained) haptic events
- 🔄 Automatic haptic engine management with manual control options
- 📱 iOS 13.0+ support using Apple's Core Haptics framework
- 📄 JSON/AHAP format support for loading custom patterns
- 🎨 Comprehensive example app demonstrating all features
- 📚 Full documentation with API reference and usage examples
- ✅ Device capability checking with `supportsHaptics()`

### Platform Support
- iOS 13.0+
- iPadOS 13.0+
- Mac Catalyst 13.0+

### Known Limitations
- Requires real iOS device for testing (does not work in Simulator)
- iOS/iPadOS only (no Android support)
- Some older devices may have limited or no haptic capabilities
