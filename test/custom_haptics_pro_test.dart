import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:custom_haptics_pro/custom_haptics_pro.dart';
import 'package:custom_haptics_pro/custom_haptics_pro_platform_interface.dart';
import 'package:custom_haptics_pro/custom_haptics_pro_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCustomHapticsProPlatform
    with MockPlatformInterfaceMixin
    implements CustomHapticsProPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> startEngine() => Future.value();

  @override
  Future<void> stopEngine() => Future.value();

  @override
  Future<void> playPatternFromJson(String patternJson) => Future.value();

  @override
  Future<void> playPatternFromData(Uint8List patternData) => Future.value();

  @override
  Future<bool> supportsHaptics() => Future.value(true);

  @override
  Future<double?> currentTime() => Future.value(0.0);
}

void main() {
  final CustomHapticsProPlatform initialPlatform = CustomHapticsProPlatform.instance;

  test('$MethodChannelCustomHapticsPro is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCustomHapticsPro>());
  });

  test('getPlatformVersion', () async {
    CustomHapticsPro customHapticsProPlugin = CustomHapticsPro();
    MockCustomHapticsProPlatform fakePlatform = MockCustomHapticsProPlatform();
    CustomHapticsProPlatform.instance = fakePlatform;

    expect(await customHapticsProPlugin.getPlatformVersion(), '42');
  });

  test('supportsHaptics', () async {
    CustomHapticsPro customHapticsProPlugin = CustomHapticsPro();
    MockCustomHapticsProPlatform fakePlatform = MockCustomHapticsProPlatform();
    CustomHapticsProPlatform.instance = fakePlatform;

    expect(await customHapticsProPlugin.supportsHaptics(), true);
  });

  test('playTap creates correct pattern', () async {
    final pattern = HapticPattern.tap(intensity: 0.8, sharpness: 0.6);
    expect(pattern.events.length, 1);
    expect(pattern.events[0].type, HapticEventType.transient);
    expect(pattern.events[0].intensity, 0.8);
    expect(pattern.events[0].sharpness, 0.6);
  });

  test('playDoubleTap creates correct pattern', () async {
    final pattern = HapticPattern.doubleTap(intensity: 1.0, sharpness: 0.5);
    expect(pattern.events.length, 2);
    expect(pattern.events[0].type, HapticEventType.transient);
    expect(pattern.events[1].type, HapticEventType.transient);
  });

  test('custom pattern JSON serialization', () async {
    final pattern = HapticPattern(events: [
      HapticEvent.transient(time: 0, intensity: 1.0, sharpness: 0.5),
      HapticEvent.continuous(time: 0.5, duration: 0.3, intensity: 0.8, sharpness: 0.4),
    ]);

    final json = pattern.toJsonString();
    expect(json.contains('HapticTransient'), true);
    expect(json.contains('HapticContinuous'), true);
    expect(json.contains('HapticIntensity'), true);
    expect(json.contains('HapticSharpness'), true);
  });
}
