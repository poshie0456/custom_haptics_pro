
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'custom_haptics_pro_platform_interface.dart';

/// An implementation of [CustomHapticsProPlatform] that uses method channels.
class MethodChannelCustomHapticsPro extends CustomHapticsProPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('custom_haptics_pro');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> startEngine() async {
    await methodChannel.invokeMethod('startEngine');
  }

  @override
  Future<void> stopEngine() async {
    await methodChannel.invokeMethod('stopEngine');
  }

  @override
  Future<void> playPatternFromJson(String patternJson) async {
    await methodChannel.invokeMethod('playPatternFromJson', {'json': patternJson});
  }

  @override
  Future<void> playPatternFromData(Uint8List patternData) async {
    await methodChannel.invokeMethod('playPatternFromData', patternData);
  }

  @override
  Future<bool> supportsHaptics() async {
    final result = await methodChannel.invokeMethod<bool>('supportsHaptics');
    return result ?? false;
  }

  @override
  Future<double?> currentTime() async {
    final result = await methodChannel.invokeMethod<double>('currentTime');
    return result;
  }
}
