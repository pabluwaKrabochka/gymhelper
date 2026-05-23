import '../../../../../data/models/category_model.dart';
import '../../../../../data/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(int id);
  Future<List<CategoryModel>> getAllCategories();
  
  // ДОДАЙ ЦІ ДВА РЯДКИ:
  Future<void> addCategory(CategoryModel category);
  Future<void> deleteCategory(int id);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> updateCategory(CategoryModel category);
}