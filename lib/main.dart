import 'package:easy_localization/easy_localization.dart'; // Додано імпорт
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/features/profile/data/profile_repository.dart';
import 'package:gymhelper/features/splash_screen.dart';
import 'package:gymhelper/features/tracker/presentation/screens/profile_setup_screen.dart';
import 'app/di/service_locator.dart' as di;
import 'app/theme/app_theme.dart';
import 'features/tracker/presentation/cubit/tracker_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Ініціалізуємо залежності (GetIt)
  await di.init(); 
  
  // 2. Ініціалізуємо пакет локалізації
  await EasyLocalization.ensureInitialized(); 

  // 3. Обгортаємо додаток у провайдер мов
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('uk'), Locale('en')],
      path: 'assets', // Шлях до папки з JSON файлами
      fallbackLocale: const Locale('uk'), // Мова за замовчуванням
      child: const MyApp(),
    ),
  );
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
        
        // --- ГЛОБАЛЬНИЙ UNFOCUS КЛАВІАТУРИ ---
        builder: (context, child) {
          return GestureDetector(
            onTap: () {
              // Ця команда знімає фокус з будь-якого активного текстового поля
              FocusManager.instance.primaryFocus?.unfocus();
            },
            behavior: HitTestBehavior.opaque, // Працює навіть якщо натиснути на порожній фон
            child: child,
          );
        },
        // ------------------------------------

        home: hasProfile ? const SplashScreen() : const ProfileSetupScreen(),
        debugShowCheckedModeBanner: false,
        
        // --- ПІДКЛЮЧЕННЯ EASY LOCALIZATION ДО FLUTTER ---
        // Ці три рядки автоматично кажуть Flutter, яку мову використовувати
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale, 
      ),
    );
  }
}