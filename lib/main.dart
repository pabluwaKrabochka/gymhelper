import 'package:easy_localization/easy_localization.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/core/theme_cubit.dart';
import 'package:gymhelper/features/profile/data/profile_repository.dart';
import 'package:gymhelper/features/splash_screen.dart';
import 'package:gymhelper/features/profile/screens/profile_setup_screen.dart';
import 'app/di/service_locator.dart' as di;
import 'app/theme/app_theme.dart';
import 'features/tracker/presentation/cubit/tracker_cubit.dart';
import 'core/constants/food_database.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await di.init(); 
  await EasyLocalization.ensureInitialized(); 

  // Ініціалізуємо тему (завантажуємо збережене значення)
  final themeCubit = di.sl<ThemeCubit>();
  await themeCubit.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);


  // --- ЗАВАНТАЖУЄМО БАЗУ ДАНИХ ПРОДУКТІВ ---
  await loadFoodDatabase();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('uk'), Locale('en')],
      path: 'assets', 
      fallbackLocale: const Locale('uk'),
      child: MyApp(themeCubit: themeCubit),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeCubit themeCubit;

  const MyApp({super.key, required this.themeCubit});

  @override
  Widget build(BuildContext context) {
    final hasProfile = di.sl<ProfileRepository>().hasProfile;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<TrackerCubit>()),
        // Передаємо вже ініціалізований кубіт теми
        BlocProvider.value(value: themeCubit), 
      ],
      // Слухаємо ThemeMode
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Gym & Health Tracker',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode, 
            
            builder: (context, child) {
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                behavior: HitTestBehavior.opaque, 
                child: child,
              );
            },
            home: hasProfile ? const SplashScreen() : const ProfileSetupScreen(),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale, 
          );
        },
      ),
    );
  }
}