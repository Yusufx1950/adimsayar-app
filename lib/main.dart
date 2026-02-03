import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/step_counter_bloc.dart';
import 'repositories/step_repository.dart';
import 'screens/history_screen.dart'; // Yeni ekran import'u
import 'screens/home_screen.dart';
import 'services/pedometer_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<StepRepository>(
          create: (context) => StepRepository(),
        ),
        RepositoryProvider<PedometerService>(
          create: (context) => PedometerService(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<StepCounterBloc>(
            create: (context) => StepCounterBloc(
              context.read<PedometerService>(),
              context.read<StepRepository>(),
            )..add(InitializePedometer()),
          ),
        ],
        child: MaterialApp(
          title: 'Adımsayar',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          // Route tanımlamaları burada
          initialRoute: '/',
          routes: {
            '/': (context) => HomeScreen(),
            '/history': (context) => HistoryScreen(),
          },
          // Bilinmeyen route'lar için hata sayfası (opsiyonel)
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Sayfa Bulunamadı')),
                body: const Center(child: Text('404 - Sayfa bulunamadı')),
              ),
            );
          },
        ),
      ),
    );
  }
}
