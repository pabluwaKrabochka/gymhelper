import 'package:get_it/get_it.dart';
import 'package:gymhelper/core/theme_cubit.dart';
import 'package:gymhelper/data/repositories/theme_repository.dart';
import 'package:gymhelper/data/services/storage/theme_local_storage.dart';
import 'package:gymhelper/domain/usecases/theme_usecases.dart';
import 'package:gymhelper/features/profile/data/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/services/storage/database_service.dart';
import '../../features/tracker/data/tracker_repository_impl.dart';
import '../../features/tracker/domain/tracker_repository.dart';
import '../../features/tracker/presentation/cubit/tracker_cubit.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // Асинхронна ініціалізація SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Services
  sl.registerLazySingleton<DatabaseService>(() => DatabaseService());

  // Repositories
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepository(sl()));
  sl.registerLazySingleton<TrackerRepository>(() => TrackerRepositoryImpl(sl()));

  // Cubits (додамо сюди ProfileRepository пізніше)
  sl.registerFactory(() => TrackerCubit(sl(), sl())); // Оновимо Cubit на наступному кроці

  // --- ТЕМА (CLEAN ARCHITECTURE) ---
  sl.registerLazySingleton<ThemeLocalStorage>(() => ThemeLocalStorage());
  
  sl.registerLazySingleton<ThemeRepository>(
    () => ThemeRepository(sl()),
  );
  
  sl.registerLazySingleton<LoadThemeUseCase>(
    () => LoadThemeUseCase(sl()),
  );
  
  sl.registerLazySingleton<SaveThemeUseCase>(
    () => SaveThemeUseCase(sl()),
  );
  
  sl.registerFactory<ThemeCubit>(
    () => ThemeCubit(loadTheme: sl(), saveTheme: sl()),
  );
}