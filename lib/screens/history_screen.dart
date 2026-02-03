import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int touchedIndex = -1;

  // Örnek veri - gerçek uygulamada repository'den gelecek
  final List<DailySteps> weeklyData = [
    DailySteps(day: 'Pzt', steps: 8500, date: '24 Şub'),
    DailySteps(day: 'Sal', steps: 12000, date: '25 Şub'),
    DailySteps(day: 'Çar', steps: 6000, date: '26 Şub'),
    DailySteps(day: 'Per', steps: 15000, date: '27 Şub'),
    DailySteps(day: 'Cum', steps: 9000, date: '28 Şub'),
    DailySteps(day: 'Cmt', steps: 11000, date: '1 Mar'),
    DailySteps(day: 'Paz', steps: 4000, date: '2 Mar'),
  ];

  int get maxSteps =>
      weeklyData.map((e) => e.steps).reduce((a, b) => a > b ? a : b);
  int get totalSteps => weeklyData.fold(0, (sum, item) => sum + item.steps);
  double get averageSteps => totalSteps / weeklyData.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const Text(
                            'Geçmiş',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Son 7 Gün',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$totalSteps adım',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // İstatistik Kartları
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.trending_up,
                      title: 'Ortalama',
                      value: '${averageSteps.toStringAsFixed(0)}',
                      subtitle: 'adım/gün',
                      gradient: const [Color(0xFFff6b6b), Color(0xFFee5a6f)],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.emoji_events,
                      title: 'En Yüksek',
                      value: '$maxSteps',
                      subtitle: 'adım',
                      gradient: const [Color(0xFFf093fb), Color(0xFFf5576c)],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Grafik Başlığı
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Haftalık Grafik',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF667eea).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.circle, size: 8, color: Color(0xFF667eea)),
                        SizedBox(width: 6),
                        Text(
                          'Bu Hafta',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bar Chart
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              height: 320,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxSteps.toDouble() * 1.2,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: const Color(0xFF2d3436),
                            tooltipRoundedRadius: 12,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${weeklyData[groupIndex].steps}\n',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'adım',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          touchCallback:
                              (FlTouchEvent event, barTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      barTouchResponse == null ||
                                      barTouchResponse.spot == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = barTouchResponse
                                      .spot!
                                      .touchedBarGroupIndex;
                                });
                              },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index < 0 || index >= weeklyData.length) {
                                  return const SizedBox();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Column(
                                    children: [
                                      Text(
                                        weeklyData[index].day,
                                        style: TextStyle(
                                          color: touchedIndex == index
                                              ? const Color(0xFF667eea)
                                              : Colors.white70,
                                          fontWeight: touchedIndex == index
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        weeklyData[index].date,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.4),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: maxSteps / 5,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.white.withOpacity(0.05),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        barGroups: List.generate(
                          weeklyData.length,
                          (index) => _buildBarGroup(
                            index,
                            weeklyData[index].steps.toDouble(),
                            touchedIndex == index,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Günlük Detay Listesi
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Günlük Detaylar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Tümünü Gör',
                      style: TextStyle(color: Color(0xFF667eea)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final data = weeklyData[index];
              final isToday = index == weeklyData.length - 1;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: isToday
                      ? const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        )
                      : LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.05),
                            Colors.white.withOpacity(0.02),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isToday
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white10,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isToday
                            ? Colors.white.withOpacity(0.2)
                            : const Color(0xFF667eea).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          data.day,
                          style: TextStyle(
                            color: isToday
                                ? Colors.white
                                : const Color(0xFF667eea),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data.steps} adım',
                            style: TextStyle(
                              color: isToday ? Colors.white : Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${data.date} • ${(data.steps * 0.04).toStringAsFixed(0)} kcal',
                            style: TextStyle(
                              color: isToday
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isToday
                                ? Colors.white.withOpacity(0.2)
                                : (data.steps >= 10000
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.orange.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            data.steps >= 10000 ? '✓ Tamamlandı' : 'Devam',
                            style: TextStyle(
                              color: isToday
                                  ? Colors.white
                                  : (data.steps >= 10000
                                        ? Colors.green
                                        : Colors.orange),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(data.steps / 10000 * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: isToday ? Colors.white70 : Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }, childCount: weeklyData.length),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 30)),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, bool isTouched) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: LinearGradient(
            colors: isTouched
                ? [const Color(0xFF00d2ff), const Color(0xFF3a7bd5)]
                : [const Color(0xFF667eea), const Color(0xFF764ba2)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: isTouched ? 24 : 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxSteps.toDouble() * 1.2,
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ],
    );
  }
}

class DailySteps {
  final String day;
  final int steps;
  final String date;

  DailySteps({required this.day, required this.steps, required this.date});
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final List<Color> gradient;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
