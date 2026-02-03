import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class PedometerService {
  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream; // ✅ Doğru yazım

  Function(int steps)? onStepCount;
  Function(String status)? onStatusChange;
  Function(String error)? onError;

  Future<bool> requestPermission() async {
    print('🔐 İzin isteniyor...');
    var status = await Permission.activityRecognition.request();
    print('🔐 İzin durumu: ${status.isGranted}');
    return status.isGranted;
  }

  void initialize() {
    print('🚀 PedometerService initialize ediliyor...');

    try {
      _stepCountStream = Pedometer.stepCountStream;
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;

      print('📡 Stream\'ler oluşturuldu, dinlemeye başlanıyor...');

      _stepCountStream?.listen(
        (StepCount event) {
          print('👟 ADIM GELDİ: ${event.steps}');
          onStepCount?.call(event.steps);
        },
        onError: (error) {
          print('❌ Adım sayacı hatası: $error');
          onError?.call('Adım sayacı hatası: $error');
        },
        onDone: () => print('✅ Adım stream\'i tamamlandı'),
      );

      _pedestrianStatusStream?.listen(
        (PedestrianStatus event) {
          // ✅ Doğru yazım
          print('🚶 DURUM GELDİ: ${event.status}');
          onStatusChange?.call(event.status);
        },
        onError: (error) {
          print('❌ Durum hatası: $error');
          onError?.call('Durum hatası: $error');
        },
      );

      print('✅ Initialize tamamlandı');
    } catch (e) {
      print('💥 Initialize hatası: $e');
      onError?.call('Servis başlatma hatası: $e');
    }
  }

  void dispose() {
    print('🛑 Servis kapatılıyor...');
  }
}
