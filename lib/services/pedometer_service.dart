import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class PedometerService {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  Function(int steps)? onStepCount;
  Function(String status)? onStatusChange;
  Function(String error)? onError;

  Future<bool> requestPermission() async {
    var status = await Permission.activityRecognition.request();
    return status.isGranted;
  }

  void initialize() {
    _stepCountStream = Pedometer.stepCountStream;
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;

    _stepCountStream.listen(
      (event) => onStepCount?.call(event.steps),
      onError: (error) => onError?.call('Adım sayacı hatası: $error'),
    );

    _pedestrianStatusStream.listen(
      (event) => onStatusChange?.call(event.status),
      onError: (error) => onError?.call('Durum hatası: $error'),
    );
  }
}
