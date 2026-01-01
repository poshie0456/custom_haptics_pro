import 'dart:convert';
import 'haptic_event.dart';

/// Represents a complete haptic pattern with multiple events.
class HapticPattern {
  /// The list of haptic events in this pattern.
  final List<HapticEvent> events;

  const HapticPattern({required this.events});

  /// Creates a single tap haptic pattern.
  factory HapticPattern.tap({
    double intensity = 1.0,
    double sharpness = 0.5,
  }) {
    return HapticPattern(
      events: [
        HapticEvent.transient(
          time: 0,
          intensity: intensity,
          sharpness: sharpness,
        ),
      ],
    );
  }

  /// Creates a double tap haptic pattern.
  factory HapticPattern.doubleTap({
    double intensity = 1.0,
    double sharpness = 0.5,
    double delay = 0.1,
  }) {
    return HapticPattern(
      events: [
        HapticEvent.transient(
          time: 0,
          intensity: intensity,
          sharpness: sharpness,
        ),
        HapticEvent.transient(
          time: delay,
          intensity: intensity,
          sharpness: sharpness,
        ),
      ],
    );
  }

  /// Creates a heartbeat haptic pattern.
  factory HapticPattern.heartbeat({
    double intensity = 1.0,
    double sharpness = 0.5,
  }) {
    return HapticPattern(
      events: [
        HapticEvent.transient(time: 0, intensity: intensity, sharpness: sharpness),
        HapticEvent.transient(time: 0.05, intensity: intensity * 0.7, sharpness: sharpness),
        HapticEvent.transient(time: 0.8, intensity: intensity, sharpness: sharpness),
        HapticEvent.transient(time: 0.85, intensity: intensity * 0.7, sharpness: sharpness),
      ],
    );
  }

  /// Creates a continuous vibration pattern.
  factory HapticPattern.continuous({
    required double duration,
    double intensity = 1.0,
    double sharpness = 0.5,
  }) {
    return HapticPattern(
      events: [
        HapticEvent.continuous(
          time: 0,
          duration: duration,
          intensity: intensity,
          sharpness: sharpness,
        ),
      ],
    );
  }

  /// Converts this pattern to a JSON string for the platform channel.
  String toJsonString() {
    final patternMap = {
      'Pattern': events.map((e) => e.toJson()).toList(),
    };
    return jsonEncode(patternMap);
  }

  /// Converts this pattern to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'Pattern': events.map((e) => e.toJson()).toList(),
    };
  }
}
