import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/di/service_locator.dart' as di;
import 'app/theme/app_theme.dart';
import 'features/transactions/presentation/screens/main_screen.dart';
import 'features/transactions/presentation/screens/onboarding_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); 

final prefs = await SharedPreferences.getInstance();
await prefs.setString('user_currency', '₴'); // Ставимо UAH за замовчуванням
 final isFirstRun = prefs.getBool('is_first_run') ?? true;

  runApp(MyApp(isFirstRun: isFirstRun));
}

class MyApp extends StatelessWidget {
  final bool isFirstRun; // Додана змінна

  const MyApp({super.key, required this.isFirstRun}); // Оновлено конструктор

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Manager',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      
      // РОБИМО ПЕРЕВІРКУ: якщо перший запуск - показуємо Onboarding, якщо ні - MainScreen
      home: isFirstRun ? const OnboardingScreen() : const MainScreen(),
      
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
    );
  }
}