import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/step_data.dart';
import '../repositories/step_repository.dart';
import '../services/pedometer_service.dart';

// Events
abstract class StepCounterEvent {}

class InitializePedometer extends StepCounterEvent {}

class StepUpdated extends StepCounterEvent {
  final int steps;
  StepUpdated(this.steps);
}

class ResetSteps extends StepCounterEvent {}

// States
abstract class StepCounterState {}

class StepCounterInitial extends StepCounterState {}

class StepCounterLoading extends StepCounterState {}

class StepCounterActive extends StepCounterState {
  final int steps;
  final String status;
  StepCounterActive(this.steps, this.status);
}

class StepCounterError extends StepCounterState {
  final String message;
  StepCounterError(this.message);
}

// BLoC
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
  }

  Future<void> _onInitialize(
    InitializePedometer event,
    Emitter<StepCounterState> emit,
  ) async {
    emit(StepCounterLoading());

    final hasPermission = await _pedometerService.requestPermission();
    if (!hasPermission) {
      emit(StepCounterError('İzin verilmedi'));
      return;
    }

    _baselineSteps = await _repository.getTodaySteps();

    _pedometerService.onStepCount = (steps) {
      add(StepUpdated(steps));
    };

    _pedometerService.onStatusChange = (status) {
      // Durum güncellemelerini işle
    };

    _pedometerService.initialize();
    emit(StepCounterActive(_baselineSteps, 'initialized'));
  }

  void _onStepUpdated(StepUpdated event, Emitter<StepCounterState> emit) {
    _currentSteps = event.steps;
    final displaySteps = _currentSteps > _baselineSteps
        ? _currentSteps - _baselineSteps
        : _currentSteps;

    _repository.saveSteps(
      StepData(steps: displaySteps, timestamp: DateTime.now()),
    );

    emit(StepCounterActive(displaySteps, 'walking'));
  }

  void _onReset(ResetSteps event, Emitter<StepCounterState> emit) {
    _baselineSteps = _currentSteps;
    emit(StepCounterActive(0, 'reset'));
  }
}
