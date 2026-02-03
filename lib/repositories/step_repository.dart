import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/step_data.dart';

class StepRepository {
  static const String _keyPrefix = 'steps_';

  Future<void> saveSteps(StepData data) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix${_formatDate(data.timestamp)}';

    List<String> existing = prefs.getStringList(key) ?? [];
    existing.add(jsonEncode(data.toJson()));

    await prefs.setStringList(key, existing);
  }

  Future<int> getTodaySteps() async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix${_formatDate(DateTime.now())}';

    List<String> data = prefs.getStringList(key) ?? [];
    if (data.isEmpty) return 0;

    // En yüksek adım sayısını al (sistem yeniden başlatıldığında sıfırlanır)
    final steps = data
        .map((e) => StepData.fromJson(jsonDecode(e)))
        .map((e) => e.steps)
        .reduce(max);
    return steps;
  }

  String _formatDate(DateTime date) => '${date.year}-${date.month}-${date.day}';
}
