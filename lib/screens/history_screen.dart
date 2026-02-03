import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adım Geçmişi')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Son 7 Gün', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 20),
            Container(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 15000,
                  barGroups: [
                    _buildBarGroup(0, 8500, 'Pzt'),
                    _buildBarGroup(1, 12000, 'Sal'),
                    _buildBarGroup(2, 6000, 'Çar'),
                    _buildBarGroup(3, 15000, 'Per'),
                    _buildBarGroup(4, 9000, 'Cum'),
                    _buildBarGroup(5, 11000, 'Cmt'),
                    _buildBarGroup(6, 4000, 'Paz'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, String label) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.deepPurple,
          width: 20,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }
}
