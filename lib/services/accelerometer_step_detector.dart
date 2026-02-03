import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerStepDetector {
  StreamSubscription<AccelerometerEvent>? _subscription;
  int _stepCount = 0;
  DateTime? _lastStepTime;

  // Adım algılama threshold'u
  final double threshold = 11.0;
  final Duration minStepInterval = Duration(milliseconds: 250);

  void startListening(Function(int) onStep) {
    _subscription = accelerometerEventStream().listen((event) {
      double magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (magnitude > threshold) {
        final now = DateTime.now();

        if (_lastStepTime == null ||
            now.difference(_lastStepTime!) > minStepInterval) {
          _stepCount++;
          _lastStepTime = now;
          onStep(_stepCount);
        }
      }
    });
  }

  void stop() => _subscription?.cancel();
}
