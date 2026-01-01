import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:custom_haptics_pro/custom_haptics_pro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Haptics Pro Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HapticsDemo(),
    );
  }
}

class HapticsDemo extends StatefulWidget {
  const HapticsDemo({super.key});

  @override
  State<HapticsDemo> createState() => _HapticsDemoState();
}

class _HapticsDemoState extends State<HapticsDemo> {
  final _haptics = CustomHapticsPro();
  String _platformVersion = 'Unknown';
  bool _supportsHaptics = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _initPlatform();
  }

  Future<void> _initPlatform() async {
    String platformVersion;
    bool supportsHaptics;

    try {
      platformVersion = await _haptics.getPlatformVersion() ?? 'Unknown';
      supportsHaptics = await _haptics.supportsHaptics();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
      supportsHaptics = false;
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _supportsHaptics = supportsHaptics;
      _statusMessage = supportsHaptics
          ? 'Haptics supported!'
          : 'Haptics not supported on this device';
    });
  }

  Future<void> _playHaptic(String name, Future<void> Function() playFunction) async {
    if (!_supportsHaptics) {
      setState(() {
        _statusMessage = 'Haptics not supported on this device';
      });
      return;
    }

    try {
      await playFunction();
      setState(() {
        _statusMessage = 'Played: $name';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Custom Haptics Pro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Platform Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Platform: $_platformVersion',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _supportsHaptics ? Icons.check_circle : Icons.cancel,
                          color: _supportsHaptics ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _supportsHaptics ? 'Haptics Supported' : 'Haptics Not Supported',
                          style: TextStyle(
                            color: _supportsHaptics ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Status Message
            if (_statusMessage.isNotEmpty)
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _statusMessage,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Section: Basic Haptics
            Text(
              'Basic Haptics',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),

            _buildHapticButton(
              'Single Tap',
              'A quick, sharp tap',
              Icons.touch_app,
              () => _playHaptic('Single Tap', () => _haptics.playTap()),
            ),

            _buildHapticButton(
              'Double Tap',
              'Two quick taps in succession',
              Icons.touch_app,
              () => _playHaptic('Double Tap', () => _haptics.playDoubleTap()),
            ),

            _buildHapticButton(
              'Heartbeat',
              'A double-beat pattern like a heartbeat',
              Icons.favorite,
              () => _playHaptic('Heartbeat', () => _haptics.playHeartbeat()),
            ),

            const SizedBox(height: 24),

            // Section: Intensity Variations
            Text(
              'Intensity Variations',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),

            _buildHapticButton(
              'Light Tap',
              'Gentle tap with low intensity',
              Icons.touch_app_outlined,
              () => _playHaptic('Light Tap', () => _haptics.playTap(intensity: 0.3)),
            ),

            _buildHapticButton(
              'Medium Tap',
              'Moderate intensity tap',
              Icons.touch_app,
              () => _playHaptic('Medium Tap', () => _haptics.playTap(intensity: 0.6)),
            ),

            _buildHapticButton(
              'Strong Tap',
              'Powerful tap with full intensity',
              Icons.ads_click,
              () => _playHaptic('Strong Tap', () => _haptics.playTap(intensity: 1.0)),
            ),

            const SizedBox(height: 24),

            // Section: Sharpness Variations
            Text(
              'Sharpness Variations',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),

            _buildHapticButton(
              'Dull Tap',
              'Soft, rounded haptic feeling',
              Icons.blur_circular,
              () => _playHaptic('Dull Tap', () => _haptics.playTap(sharpness: 0.0)),
            ),

            _buildHapticButton(
              'Sharp Tap',
              'Crisp, precise haptic feeling',
              Icons.star,
              () => _playHaptic('Sharp Tap', () => _haptics.playTap(sharpness: 1.0)),
            ),

            const SizedBox(height: 24),

            // Section: Continuous Haptics
            Text(
              'Continuous Haptics',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),

            _buildHapticButton(
              'Short Buzz (0.2s)',
              'Brief continuous vibration',
              Icons.vibration,
              () => _playHaptic('Short Buzz', () => _haptics.playContinuous(duration: 0.2)),
            ),

            _buildHapticButton(
              'Medium Buzz (0.5s)',
              'Medium duration vibration',
              Icons.vibration,
              () => _playHaptic('Medium Buzz', () => _haptics.playContinuous(duration: 0.5)),
            ),

            _buildHapticButton(
              'Long Buzz (1.0s)',
              'Long continuous vibration',
              Icons.vibration,
              () => _playHaptic('Long Buzz', () => _haptics.playContinuous(duration: 1.0)),
            ),

            const SizedBox(height: 24),

            // Section: Custom Patterns
            Text(
              'Custom Patterns',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),

            _buildHapticButton(
              'Triple Tap',
              'Three quick taps in sequence',
              Icons.touch_app,
              () => _playCustomTripleTap(),
            ),

            _buildHapticButton(
              'Escalating',
              'Increasing intensity pattern',
              Icons.trending_up,
              () => _playEscalatingPattern(),
            ),

            _buildHapticButton(
              'SOS Pattern',
              'Three short, three long, three short',
              Icons.sos,
              () => _playSOSPattern(),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHapticButton(
    String title,
    String description,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        onPressed: _supportsHaptics ? onPressed : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
        ),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _playCustomTripleTap() async {
    final pattern = HapticPattern(events: [
      HapticEvent.transient(time: 0, intensity: 1.0, sharpness: 0.5),
      HapticEvent.transient(time: 0.1, intensity: 1.0, sharpness: 0.5),
      HapticEvent.transient(time: 0.2, intensity: 1.0, sharpness: 0.5),
    ]);
    await _playHaptic('Triple Tap', () => _haptics.playPattern(pattern));
  }

  Future<void> _playEscalatingPattern() async {
    final pattern = HapticPattern(events: [
      HapticEvent.transient(time: 0, intensity: 0.3, sharpness: 0.3),
      HapticEvent.transient(time: 0.15, intensity: 0.5, sharpness: 0.5),
      HapticEvent.transient(time: 0.3, intensity: 0.7, sharpness: 0.7),
      HapticEvent.transient(time: 0.45, intensity: 1.0, sharpness: 1.0),
    ]);
    await _playHaptic('Escalating', () => _haptics.playPattern(pattern));
  }

  Future<void> _playSOSPattern() async {
    // SOS: ... --- ...
    final pattern = HapticPattern(events: [
      // Three short
      HapticEvent.transient(time: 0, intensity: 1.0, sharpness: 1.0),
      HapticEvent.transient(time: 0.15, intensity: 1.0, sharpness: 1.0),
      HapticEvent.transient(time: 0.3, intensity: 1.0, sharpness: 1.0),
      // Three long
      HapticEvent.continuous(time: 0.6, duration: 0.2, intensity: 1.0, sharpness: 1.0),
      HapticEvent.continuous(time: 0.95, duration: 0.2, intensity: 1.0, sharpness: 1.0),
      HapticEvent.continuous(time: 1.3, duration: 0.2, intensity: 1.0, sharpness: 1.0),
      // Three short
      HapticEvent.transient(time: 1.7, intensity: 1.0, sharpness: 1.0),
      HapticEvent.transient(time: 1.85, intensity: 1.0, sharpness: 1.0),
      HapticEvent.transient(time: 2.0, intensity: 1.0, sharpness: 1.0),
    ]);
    await _playHaptic('SOS Pattern', () => _haptics.playPattern(pattern));
  }
}
