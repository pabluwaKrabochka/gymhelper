import 'package:gymhelper/features/transactions/presentation/cubit/transaction_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/services/storage/database_service.dart';
import '../../features/transactions/domain/transaction_repository.dart';
import '../../features/transactions/data/transaction_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Services
  sl.registerLazySingleton(() => DatabaseService());

  // Repositories
  // Ми кажемо: "Коли хтось попросить TransactionRepository, дай йому TransactionRepositoryImpl"
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl<DatabaseService>()),
  );

 // Blocs / Cubits
  sl.registerFactory(() => TransactionCubit(sl<TransactionRepository>()));
}