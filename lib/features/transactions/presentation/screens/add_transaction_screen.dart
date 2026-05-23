import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/features/transactions/widgets/amount_input_widget.dart';
import 'package:gymhelper/features/transactions/widgets/category_picker.dart';
import 'package:gymhelper/features/transactions/widgets/quick_amounts_chip.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/theme/app_colors.dart'; 
import '../../../../data/models/category_model.dart';
import '../../../../data/models/transaction_model.dart';
import '../cubit/transaction_cubit.dart';


class AddTransactionScreen extends StatefulWidget {
  final List<CategoryModel> categories;
  final TransactionModel? transactionToEdit;

  const AddTransactionScreen({
    super.key,
    required this.categories,
    this.transactionToEdit,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;
  
  CategoryModel? _selectedCategory;
  bool _hasCategoryError = false; 

  final Map<String, String> _currencyData = {
    '₴': 'Гривня',
    '\$': 'Долар',
    '€': 'Євро',
  };
  late String _selectedCurrency;

  final List<double> _quickAmounts = [5, 10, 25, 50, 100, 1000, 10000, 100000];

  @override
  void initState() {
    super.initState();
    _loadDefaultCurrency();
    final t = widget.transactionToEdit;
    _amountController = TextEditingController(text: t != null ? t.amount.toString() : '');
    _noteController = TextEditingController(text: t?.note ?? '');
    _selectedCurrency = t?.currency ?? '₴';

    if (t != null) {
      _selectedCategory = widget.categories.firstWhere((c) => c.id == t.categoryId);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadDefaultCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCurrency = widget.transactionToEdit?.currency ?? prefs.getString('user_currency') ?? '₴';
    });
  }

  void _addAmount(double value) {
    double current = double.tryParse(_amountController.text) ?? 0;
    setState(() {
      _amountController.text = (current + value).toStringAsFixed(0);
    });
  }

  void _saveTransaction() {
    setState(() {
      _hasCategoryError = _selectedCategory == null;
    });

    if (_formKey.currentState!.validate() && !_hasCategoryError) {
      final isEditing = widget.transactionToEdit != null;

      final transaction = TransactionModel(
        id: isEditing ? widget.transactionToEdit!.id : null,
        amount: double.parse(_amountController.text),
        timestamp: isEditing ? widget.transactionToEdit!.timestamp : DateTime.now().millisecondsSinceEpoch,
        categoryId: _selectedCategory!.id!,
        currency: _selectedCurrency,
        note: _noteController.text.isEmpty ? null : _noteController.text,
      );

      if (isEditing) {
        context.read<TransactionCubit>().updateTransaction(transaction);
      } else {
        context.read<TransactionCubit>().addTransaction(transaction);
      }

      Navigator.pop(context);
    } else if (_hasCategoryError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Будь ласка, оберіть категорію', style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.expense,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // Загальний стиль для текстових полів (наприклад, для Нотаток)
  InputDecoration _noteInputDecoration() {
    return InputDecoration(
      hintText: 'Примітка (необов\'язково)',
      hintStyle: const TextStyle(color: AppColors.textSecondary),
      prefixIcon: const Icon(IconsaxPlusLinear.note_text, color: AppColors.textSecondary),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.withAlpha(25), width: 1)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.transactionToEdit == null ? 'Нова транзакція' : 'Редагувати'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), 
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                const Text("Сума транзакції", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                const SizedBox(height: 12),

                // 1. Віджет Суми та Валюти
                AmountAndCurrencyInput(
                  amountController: _amountController,
                  selectedCurrency: _selectedCurrency,
                  currencyData: _currencyData,
                  onCurrencyChanged: (val) => setState(() => _selectedCurrency = val),
                  onClearAmount: () => setState(() => _amountController.clear()),
                ),
                
                const SizedBox(height: 20),

                // 2. Віджет Швидких Сум
                QuickAmountChips(
                  amounts: _quickAmounts,
                  onAmountTapped: _addAmount,
                ),
                
                const SizedBox(height: 32),
                const Text("Деталі", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                const SizedBox(height: 12),

                // 3. Віджет Вибору Категорії
                CategoryDropdownPicker(
                  selectedCategory: _selectedCategory,
                  categories: widget.categories,
                  hasError: _hasCategoryError,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                      _hasCategoryError = false;
                    });
                  },
                ),
                
                const SizedBox(height: 16),

                // Введення примітки
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: TextFormField(
                    controller: _noteController,
                    decoration: _noteInputDecoration(),
                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  ),
                ),
                
                const SizedBox(height: 40),

                // Кнопка Зберегти
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: _saveTransaction,
                    child: const Text('ЗБЕРЕГТИ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  ),
                ),
                const SizedBox(height: 40), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}