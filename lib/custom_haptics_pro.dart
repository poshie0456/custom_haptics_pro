import 'dart:typed_data';

import 'custom_haptics_pro_platform_interface.dart';
import 'models/haptic_pattern.dart';

export 'models/haptic_event.dart';
export 'models/haptic_pattern.dart';

/// High-level API for the custom_haptics_pro plugin.
///
/// This plugin provides a simple interface for playing custom haptics on iOS
/// using Apple's Core Haptics framework.
///
/// Example usage:
/// ```dart
/// final haptics = CustomHapticsPro();
///
/// // Check if device supports haptics
/// if (await haptics.supportsHaptics()) {
///   // Play a simple tap
///   await haptics.playTap();
///
///   // Play a custom pattern
///   await haptics.playPattern(HapticPattern.heartbeat());
/// }
/// ```
class CustomHapticsPro {
  CustomHapticsPro._();

  /// Singleton instance.
  static final CustomHapticsPro instance = CustomHapticsPro._();

  /// Backwards-compatible default constructor that returns the singleton.
  factory CustomHapticsPro() => instance;

  /// Check if the device supports haptics.
  ///
  /// Returns `true` if the device supports Core Haptics, `false` otherwise.
  Future<bool> supportsHaptics() =>
      CustomHapticsProPlatform.instance.supportsHaptics();

  /// Get the current platform version.
  Future<String?> getPlatformVersion() =>
      CustomHapticsProPlatform.instance.getPlatformVersion();

  /// Start the haptic engine.
  ///
  /// The engine is automatically started when playing patterns if not already started.
  /// You can optionally call this method to start the engine in advance.
  Future<void> startEngine() =>
      CustomHapticsProPlatform.instance.startEngine();

  /// Stop the haptic engine.
  ///
  /// Call this when you're done playing haptics to conserve battery.
  Future<void> stopEngine() =>
      CustomHapticsProPlatform.instance.stopEngine();

  /// Get the current time from the haptic engine.
  ///
  /// Returns the absolute time in seconds, useful for scheduling events.
  Future<double?> currentTime() =>
      CustomHapticsProPlatform.instance.currentTime();

  // MARK: - Simple Haptic Methods

  /// Play a single tap haptic.
  ///
  /// Parameters:
  /// - [intensity]: The intensity of the haptic (0.0 to 1.0). Default is 1.0.
  /// - [sharpness]: The sharpness of the haptic (0.0 to 1.0). Default is 0.5.
  Future<void> playTap({
    double intensity = 1.0,
    double sharpness = 0.5,
  }) async {
    final pattern = HapticPattern.tap(
      intensity: intensity,
      sharpness: sharpness,
    );
    await playPattern(pattern);
  }

  /// Play a double tap haptic.
  ///
  /// Parameters:
  /// - [intensity]: The intensity of the haptic (0.0 to 1.0). Default is 1.0.
  /// - [sharpness]: The sharpness of the haptic (0.0 to 1.0). Default is 0.5.
  /// - [delay]: The delay between taps in seconds. Default is 0.1.
  Future<void> playDoubleTap({
    double intensity = 1.0,
    double sharpness = 0.5,
    double delay = 0.1,
  }) async {
    final pattern = HapticPattern.doubleTap(
      intensity: intensity,
      sharpness: sharpness,
      delay: delay,
    );
    await playPattern(pattern);
  }

  /// Play a heartbeat haptic pattern.
  ///
  /// Parameters:
  /// - [intensity]: The intensity of the haptic (0.0 to 1.0). Default is 1.0.
  /// - [sharpness]: The sharpness of the haptic (0.0 to 1.0). Default is 0.5.
  Future<void> playHeartbeat({
    double intensity = 1.0,
    double sharpness = 0.5,
  }) async {
    final pattern = HapticPattern.heartbeat(
      intensity: intensity,
      sharpness: sharpness,
    );
    await playPattern(pattern);
  }

  /// Play a continuous vibration haptic.
  ///
  /// Parameters:
  /// - [duration]: The duration of the vibration in seconds.
  /// - [intensity]: The intensity of the haptic (0.0 to 1.0). Default is 1.0.
  /// - [sharpness]: The sharpness of the haptic (0.0 to 1.0). Default is 0.5.
  Future<void> playContinuous({
    required double duration,
    double intensity = 1.0,
    double sharpness = 0.5,
  }) async {
    final pattern = HapticPattern.continuous(
      duration: duration,
      intensity: intensity,
      sharpness: sharpness,
    );
    await playPattern(pattern);
  }

  // MARK: - Custom Pattern Methods

  /// Play a custom haptic pattern.
  ///
  /// Use [HapticPattern] to create custom patterns with multiple events.
  ///
  /// Example:
  /// ```dart
  /// final pattern = HapticPattern(events: [
  ///   HapticEvent.transient(time: 0, intensity: 1.0, sharpness: 0.5),
  ///   HapticEvent.transient(time: 0.1, intensity: 0.8, sharpness: 0.3),
  /// ]);
  /// await haptics.playPattern(pattern);
  /// ```
  Future<void> playPattern(HapticPattern pattern) async {
    await CustomHapticsProPlatform.instance
        .playPatternFromJson(pattern.toJsonString());
  }

  /// Play a pattern from a JSON string.
  ///
  /// The JSON should match Apple's haptic pattern format.
  Future<void> playPatternFromJson(String patternJson) =>
      CustomHapticsProPlatform.instance.playPatternFromJson(patternJson);

  /// Play a pattern from raw data bytes.
  Future<void> playPatternFromData(Uint8List patternData) =>
      CustomHapticsProPlatform.instance.playPatternFromData(patternData);
}
