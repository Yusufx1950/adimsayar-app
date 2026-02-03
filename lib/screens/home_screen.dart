import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/step_counter_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: Text('Adımsayar'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: BlocBuilder<StepCounterBloc, StepCounterState>(
        builder: (context, state) {
          if (state is StepCounterLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is StepCounterError) {
            return Center(child: Text('Hata: ${state.message}'));
          }

          if (state is StepCounterActive) {
            return _buildMainContent(context, state.steps);
          }

          return Center(child: Text('Başlatılıyor...'));
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, int steps) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dairesel ilerleme göstergesi
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.deepPurple, Colors.purple.shade300],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_walk, size: 50, color: Colors.white70),
                  SizedBox(height: 10),
                  Text(
                    '$steps',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'ADIM',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white70,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 40),

          // İstatistik kartları
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                icon: Icons.local_fire_department,
                value: '${(steps * 0.04).toStringAsFixed(1)}',
                label: 'kcal',
                color: Colors.orange,
              ),
              _buildStatCard(
                icon: Icons.location_on,
                value: '${(steps * 0.0007).toStringAsFixed(2)}',
                label: 'km',
                color: Colors.green,
              ),
              _buildStatCard(
                icon: Icons.timer,
                value: '${(steps * 0.008).toStringAsFixed(0)}',
                label: 'dakika',
                color: Colors.blue,
              ),
            ],
          ),

          SizedBox(height: 30),

          // Reset butonu
          ElevatedButton.icon(
            onPressed: () {
              context.read<StepCounterBloc>().add(ResetSteps());
            },
            icon: Icon(Icons.refresh),
            label: Text('Sıfırla'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(15),
        width: 100,
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
