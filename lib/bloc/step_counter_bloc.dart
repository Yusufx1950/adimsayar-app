import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/step_data.dart';
import '../repositories/step_repository.dart';
import '../services/pedometer_service.dart';

abstract class StepCounterEvent {}

class InitializePedometer extends StepCounterEvent {}

class StepUpdated extends StepCounterEvent {
  final int steps;
  StepUpdated(this.steps);
}

class ResetSteps extends StepCounterEvent {}

abstract class StepCounterState {}

class StepCounterInitial extends StepCounterState {}

class StepCounterLoading extends StepCounterState {}

class StepCounterActive extends StepCounterState {
  final int steps;
  final String status;
  StepCounterActive(this.steps, this.status);

  @override
  String toString() => 'StepCounterActive(steps: $steps, status: $status)';
}

class StepCounterError extends StepCounterState {
  final String message;
  StepCounterError(this.message);
}

class StepCounterBloc extends Bloc<StepCounterEvent, StepCounterState> {
  final PedometerService _pedometerService;
  final StepRepository _repository;
  int _baselineSteps = 0;
  int _currentSteps = 0;

  StepCounterBloc(this._pedometerService, this._repository)
    : super(StepCounterInitial()) {
    on<InitializePedometer>(_onInitialize);
    on<StepUpdated>(_onStepUpdated);
    on<ResetSteps>(_onReset);

    print('🏗️ StepCounterBloc oluşturuldu');
  }

  Future<void> _onInitialize(
    InitializePedometer event,
    Emitter<StepCounterState> emit,
  ) async {
    print('🎬 InitializePedometer event\'i işleniyor...');
    emit(StepCounterLoading());
    print('📊 State: Loading');

    final hasPermission = await _pedometerService.requestPermission();
    print('🔑 İzin sonucu: $hasPermission');

    if (!hasPermission) {
      print('⛔ İzin reddedildi');
      emit(StepCounterError('Aktivite izni verilmedi'));
      return;
    }

    _baselineSteps = await _repository.getTodaySteps();
    print('📊 Baseline adımlar: $_baselineSteps');

    _pedometerService.onStepCount = (steps) {
      print('📥 Bloc\'a adım verisi geldi: $steps');
      add(StepUpdated(steps));
    };

    _pedometerService.onStatusChange = (status) {
      print('📥 Bloc\'a durum geldi: $status');
    };

    _pedometerService.onError = (error) {
      print('📥 Bloc\'a hata geldi: $error');
      emit(StepCounterError(error));
    };

    _pedometerService.initialize();

    // İlk state'i baseline ile göster
    emit(StepCounterActive(_baselineSteps, 'initialized'));
    print('📊 İlk state gönderildi: $_baselineSteps adım');
  }

  void _onStepUpdated(StepUpdated event, Emitter<StepCounterState> emit) {
    print('🔄 StepUpdated işleniyor: ${event.steps}');
    _currentSteps = event.steps;

    // Telefon restart edilirse steps sıfırlanır, o yüzden max al
    final displaySteps = _currentSteps > _baselineSteps
        ? _currentSteps - _baselineSteps
        : _currentSteps;

    print('📝 Kaydedilen adımlar: $displaySteps');

    _repository.saveSteps(
      StepData(steps: displaySteps, timestamp: DateTime.now()),
    );

    emit(StepCounterActive(displaySteps, 'walking'));
    print('📊 Yeni state: $displaySteps adım');
  }

  void _onReset(ResetSteps event, Emitter<StepCounterState> emit) {
    _baselineSteps = _currentSteps;
    emit(StepCounterActive(0, 'reset'));
    print('🔄 Sıfırlandı');
  }
}
