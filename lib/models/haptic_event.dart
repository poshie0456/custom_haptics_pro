/// Represents a haptic event type (transient or continuous).
enum HapticEventType {
  /// A brief haptic event, like a tap.
  transient,

  /// A sustained haptic event with duration.
  continuous,
}

/// Represents a single haptic event in a pattern.
class HapticEvent {
  /// The type of haptic event.
  final HapticEventType type;

  /// The intensity of the haptic (0.0 to 1.0).
  final double intensity;

  /// The sharpness of the haptic (0.0 to 1.0).
  final double sharpness;

  /// The time at which this event should occur (in seconds).
  final double time;

  /// The duration of the event (only for continuous events).
  final double? duration;

  const HapticEvent({
    required this.type,
    required this.intensity,
    required this.sharpness,
    required this.time,
    this.duration,
  }) : assert(intensity >= 0.0 && intensity <= 1.0),
       assert(sharpness >= 0.0 && sharpness <= 1.0),
       assert(time >= 0.0);

  /// Creates a transient haptic event (like a tap).
  factory HapticEvent.transient({
    required double time,
    double intensity = 1.0,
    double sharpness = 0.5,
  }) {
    return HapticEvent(
      type: HapticEventType.transient,
      intensity: intensity,
      sharpness: sharpness,
      time: time,
    );
  }

  /// Creates a continuous haptic event (with duration).
  factory HapticEvent.continuous({
    required double time,
    required double duration,
    double intensity = 1.0,
    double sharpness = 0.5,
  }) {
    return HapticEvent(
      type: HapticEventType.continuous,
      intensity: intensity,
      sharpness: sharpness,
      time: time,
      duration: duration,
    );
  }

  /// Converts this event to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    final event = <String, dynamic>{
      'EventType': type == HapticEventType.transient
          ? 'HapticTransient'
          : 'HapticContinuous',
      'Time': time,
      'EventParameters': [
        {
          'ParameterID': 'HapticIntensity',
          'ParameterValue': intensity,
        },
        {
          'ParameterID': 'HapticSharpness',
          'ParameterValue': sharpness,
        },
      ],
    };

    if (type == HapticEventType.continuous && duration != null) {
      event['EventDuration'] = duration!;
    }

    return event;
  }
}
