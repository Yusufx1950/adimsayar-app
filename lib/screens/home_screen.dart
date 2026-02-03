import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/step_counter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF667eea),
              const Color(0xFF764ba2),
              const Color(0xFFf093fb).withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<StepCounterBloc, StepCounterState>(
            builder: (context, state) {
              if (state is StepCounterLoading) {
                return const _LoadingView();
              }

              if (state is StepCounterError) {
                return _ErrorView(message: state.message);
              }

              if (state is StepCounterActive) {
                return _MainContent(steps: state.steps, status: state.status);
              }

              return const _LoadingView();
            },
          ),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
          SizedBox(height: 20),
          Text(
            'Sensör Hazırlanıyor...',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.white70),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<StepCounterBloc>().add(InitializePedometer());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF667eea),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  final int steps;
  final String status;

  const _MainContent({required this.steps, required this.status});

  @override
  Widget build(BuildContext context) {
    final double progress = (steps / 10000).clamp(0.0, 1.0);
    final bool goalReached = steps >= 10000;

    return CustomScrollView(
      slivers: [
        // Modern App Bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Günaydın! 👋',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getGreeting(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _GlassmorphicButton(
                      icon: Icons.history,
                      onTap: () => Navigator.pushNamed(context, '/history'),
                    ),
                    const SizedBox(width: 12),
                    _GlassmorphicButton(
                      icon: Icons.settings,
                      onTap: () => Navigator.pushNamed(context, '/settings'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Ana Adım Sayacı
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Dış halka - animasyonlu
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: progress),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return SizedBox(
                        width: 280,
                        height: 280,
                        child: CircularProgressIndicator(
                          value: value,
                          strokeWidth: 12,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            goalReached
                                ? const Color(0xFF00d2ff)
                                : const Color(0xFFffecd2),
                          ),
                        ),
                      );
                    },
                  ),

                  // Glassmorphic daire
                  Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Durum ikonu
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            goalReached
                                ? Icons.emoji_events
                                : Icons.directions_walk,
                            key: ValueKey(goalReached),
                            size: 40,
                            color: goalReached
                                ? const Color(0xFFffd700)
                                : Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Adım sayısı
                        TweenAnimationBuilder<int>(
                          tween: IntTween(begin: 0, end: steps),
                          duration: const Duration(milliseconds: 1000),
                          builder: (context, value, child) {
                            return Text(
                              '$value',
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1,
                              ),
                            );
                          },
                        ),

                        const Text(
                          'adım',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            letterSpacing: 2,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Hedef bilgisi
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: goalReached
                                ? const Color(0xFF00d2ff).withOpacity(0.3)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            goalReached
                                ? '🎉 Hedef Tamamlandı!'
                                : '${(progress * 100).toInt()}% tamamlandı',
                            style: TextStyle(
                              color: goalReached
                                  ? const Color(0xFF00d2ff)
                                  : Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // İstatistik Kartları
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_fire_department,
                    value: '${(steps * 0.04).toStringAsFixed(0)}',
                    label: 'Kalori',
                    color: const Color(0xFFff6b6b),
                    gradient: const [Color(0xFFffecd2), Color(0xFFfcb69f)],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.location_on,
                    value: '${(steps * 0.0007).toStringAsFixed(2)}',
                    label: 'Kilometre',
                    color: const Color(0xFF4ecdc4),
                    gradient: const [Color(0xFFa8edea), Color(0xFFfed6e3)],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.timer,
                    value: '${(steps * 0.008).toStringAsFixed(0)}',
                    label: 'Dakika',
                    color: const Color(0xFF667eea),
                    gradient: const [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Motivasyon Kartı
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: goalReached
                      ? [const Color(0xFF11998e), const Color(0xFF38ef7d)]
                      : [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                        ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: goalReached
                      ? Colors.white.withOpacity(0.3)
                      : Colors.white24,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    goalReached ? Icons.emoji_events : Icons.info_outline,
                    color: goalReached ? Colors.white : Colors.white70,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goalReached ? 'Tebrikler!' : 'Günlük Hedef',
                          style: TextStyle(
                            color: goalReached ? Colors.white : Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          goalReached
                              ? 'Bugünkü 10,000 adım hedefini başardın!'
                              : '10,000 adım hedefine ${10000 - steps} adım kaldı.',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Sıfırla Butonu
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                _showResetDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Colors.white24),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh),
                  SizedBox(width: 8),
                  Text(
                    'Sayacı Sıfırla',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SliverPadding(padding: EdgeInsets.only(bottom: 30)),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Sabah Yürüyüşü';
    if (hour < 17) return 'Öğleden Sonra';
    if (hour < 21) return 'Akşam Yürüyüşü';
    return 'Gece Yürüyüşü';
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2d3436),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Sayacı Sıfırla?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Adım sayacını sıfırlamak istediğinize emin misiniz?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<StepCounterBloc>().add(ResetSteps());
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sıfırla'),
          ),
        ],
      ),
    );
  }
}

class _GlassmorphicButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassmorphicButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.white.withOpacity(0.05),
            ],
          ),
          border: Border.all(color: Colors.white24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
          ],
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final List<Color> gradient;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
