import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gymhelper/features/profile/data/profile_repository.dart';
import 'package:gymhelper/features/tracker/presentation/screens/profile_setup_screen.dart';
import 'app/di/service_locator.dart' as di;
import 'app/theme/app_theme.dart';
import 'features/tracker/presentation/cubit/tracker_cubit.dart';
import 'features/tracker/presentation/screens/main_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Перевіряємо, чи є вже створений профіль
    final hasProfile = di.sl<ProfileRepository>().hasProfile;

    return BlocProvider(
      create: (context) => di.sl<TrackerCubit>(),
      child: MaterialApp(
        title: 'Gym & Health Tracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        // Якщо профіль є - йдемо в додаток, якщо ні - на екран створення
        home: hasProfile ? const MainScreen() : const ProfileSetupScreen(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('uk', 'UA'),
          Locale('en', 'US'),
        ],
        locale: const Locale('uk', 'UA'),
      ),
    );
  }
}