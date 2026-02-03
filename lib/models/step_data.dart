class StepData {
  final int steps;
  final DateTime timestamp;
  final String? source; // 'pedometer', 'accelerometer', 'manual'

  StepData({
    required this.steps,
    required this.timestamp,
    this.source = 'pedometer',
  });

  Map<String, dynamic> toJson() => {
    'steps': steps,
    'timestamp': timestamp.toIso8601String(),
    'source': source,
  };

  factory StepData.fromJson(Map<String, dynamic> json) => StepData(
    steps: json['steps'],
    timestamp: DateTime.parse(json['timestamp']),
    source: json['source'],
  );
}

class DailySteps {
  final DateTime date;
  final int totalSteps;
  final List<StepData> hourlyBreakdown;

  DailySteps({
    required this.date,
    required this.totalSteps,
    this.hourlyBreakdown = const [],
  });
}
