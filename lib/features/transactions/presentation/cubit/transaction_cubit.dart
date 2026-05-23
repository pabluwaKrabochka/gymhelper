// ФАЙЛ: lib/features/transactions/presentation/cubit/transaction_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/data/models/category_model.dart';
import 'package:gymhelper/data/services/network/currency_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/transaction_repository.dart';
import '../../../../data/models/transaction_model.dart';
import 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository _repository;

  DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  String mainCurrency = '₴';

  TransactionCubit(this._repository) : super(const TransactionState.initial()) {
    loadData();
  }

  Future<void> loadData() async {
    // Правильна перевірка стану через freezed
    final isLoaded = state.maybeMap(
      loaded: (_) => true,
      orElse: () => false,
    );

    if (!isLoaded) {
      emit(const TransactionState.loading());
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      mainCurrency = prefs.getString('main_currency') ?? '₴';

      final allTransactions = await _repository.getAllTransactions();
      final categories = await _repository.getAllCategories();
      final rates = await CurrencyApiService().getPrivatRates();

      final filteredTransactions = allTransactions.where((t) {
        final date = DateTime.fromMillisecondsSinceEpoch(t.timestamp);
        return date.year == currentDate.year && date.month == currentDate.month;
      }).toList();

      double balance = 0;
      for (var t in filteredTransactions) {
        final category = categories.firstWhere((c) => c.id == t.categoryId);
        double finalAmount = 0;

        if (t.currency == mainCurrency) {
          finalAmount = t.amount;
        } else {
          double amountInUAH = t.amount;
          if (t.currency == '\$') {
            final usdBuyRate = double.parse(rates.firstWhere((r) => r['ccy'] == 'USD')['buy']);
            amountInUAH = t.amount * usdBuyRate;
          } else if (t.currency == '€') {
            final eurBuyRate = double.parse(rates.firstWhere((r) => r['ccy'] == 'EUR')['buy']);
            amountInUAH = t.amount * eurBuyRate;
          }

          finalAmount = amountInUAH;
          if (mainCurrency == '\$') {
            final usdSaleRate = double.parse(rates.firstWhere((r) => r['ccy'] == 'USD')['sale']);
            finalAmount = amountInUAH / usdSaleRate;
          } else if (mainCurrency == '€') {
            final eurSaleRate = double.parse(rates.firstWhere((r) => r['ccy'] == 'EUR')['sale']);
            finalAmount = amountInUAH / eurSaleRate;
          }
        }

        if (category.type == 'income') {
          balance += finalAmount;
        } else {
          balance -= finalAmount;
        }
      }

      emit(TransactionState.loaded(
        transactions: filteredTransactions,
        categories: categories,
        totalBalance: balance,
        date: currentDate, // <--- ПЕРЕДАЄМО ДАТУ В СТАН
        currencyRates: rates,
      ));
    } catch (e) {
      emit(TransactionState.error('Помилка: $e'));
    }
  }

  // Зверни увагу: ніяких emit(loading()) більше немає!
  // Екран буде оновлюватися МИТТЄВО і ПЛАВНО.
  
  Future<void> changeMainCurrency(String newCurrency) async {
    mainCurrency = newCurrency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('main_currency', newCurrency);
    loadData();
  }

  void setMonth(DateTime newDate) {
    currentDate = DateTime(newDate.year, newDate.month, 1);
    loadData();
  }

  void changeMonth(int offset) {
    currentDate = DateTime(currentDate.year, currentDate.month + offset, 1);
    loadData();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _repository.addTransaction(transaction);
      await loadData();
    } catch (e) {
      emit(TransactionState.error('Помилка додавання: $e'));
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await _repository.deleteTransaction(id);
      await loadData();
    } catch (e) {
      emit(TransactionState.error('Помилка видалення: $e'));
    }
  }

  Future<void> addCategory(CategoryModel category) async {
    try {
      await _repository.addCategory(category);
      await loadData();
    } catch (e) {
      emit(TransactionState.error('Помилка додавання: $e'));
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await _repository.updateTransaction(transaction);
      await loadData();
    } catch (e) {
      emit(TransactionState.error('Помилка оновлення: $e'));
    }
  }

  Future<void> updateCategory(CategoryModel category) async {
    try {
      await _repository.updateCategory(category);
      await loadData();
    } catch (e) {
      emit(TransactionState.error('Помилка оновлення: $e'));
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await _repository.deleteCategory(id);
      await loadData();
    } catch (e) {
      emit(TransactionState.error('Помилка видалення: $e'));
    }
  }
}