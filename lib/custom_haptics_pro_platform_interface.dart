import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'custom_haptics_pro_method_channel.dart';

abstract class CustomHapticsProPlatform extends PlatformInterface {
  /// Constructs a CustomHapticsProPlatform.
  CustomHapticsProPlatform() : super(token: _token);

  static final Object _token = Object();

  static CustomHapticsProPlatform _instance = MethodChannelCustomHapticsPro();

  /// The default instance of [CustomHapticsProPlatform] to use.
  ///
  /// Defaults to [MethodChannelCustomHapticsPro].
  static CustomHapticsProPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CustomHapticsProPlatform] when
  /// they register themselves.
  static set instance(CustomHapticsProPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  Future<void> startEngine() {
    throw UnimplementedError('startEngine() has not been implemented.');
  }

  Future<void> stopEngine() {
    throw UnimplementedError('stopEngine() has not been implemented.');
  }

  Future<void> playPatternFromJson(String patternJson) {
    throw UnimplementedError('playPatternFromJson() has not been implemented.');
  }

  Future<void> playPatternFromData(Uint8List patternData) {
    throw UnimplementedError('playPatternFromData() has not been implemented.');
  }

  Future<bool> supportsHaptics() {
    throw UnimplementedError('supportsHaptics() has not been implemented.');
  }

  Future<double?> currentTime() {
    throw UnimplementedError('currentTime() has not been implemented.');
  }
}
