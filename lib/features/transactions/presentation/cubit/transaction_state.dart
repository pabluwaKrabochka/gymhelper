// ФАЙЛ: lib/features/transactions/presentation/cubit/transaction_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/models/category_model.dart';
import '../../../../data/models/transaction_model.dart';

part 'transaction_state.freezed.dart';

@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState.initial() = _Initial;
  const factory TransactionState.loading() = _Loading;
  
  const factory TransactionState.loaded({
    required List<TransactionModel> transactions,
    required List<CategoryModel> categories,
    required double totalBalance,
    required DateTime date, // <--- ДОДАЛИ ПОЛЕ ДАТИ
    List<dynamic>? currencyRates,
  }) = _Loaded;

  const factory TransactionState.error(String message) = _Error;
}