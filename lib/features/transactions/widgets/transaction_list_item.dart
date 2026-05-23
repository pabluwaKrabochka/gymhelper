// ФАЙЛ: lib/features/transactions/widgets/transaction_list_item.dart
// (або де він у тебе лежить)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/features/transactions/presentation/cubit/transaction_cubit.dart';
import 'package:gymhelper/features/transactions/presentation/screens/add_transaction_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; 
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart'; 
import '../../../../data/models/category_model.dart';
import '../../../../data/models/transaction_model.dart';

class TransactionListItem extends StatefulWidget {
  final TransactionModel transaction;
  final CategoryModel category;
  final List<CategoryModel> allCategories;
  final bool isIncome;

  const TransactionListItem({
    super.key, 
    required this.transaction, 
    required this.category, 
    required this.allCategories, 
    required this.isIncome
  });

  @override
  State<TransactionListItem> createState() => _TransactionListItemState();
}

class _TransactionListItemState extends State<TransactionListItem> {
  bool _isExpanded = false;

  @override
  void didUpdateWidget(covariant TransactionListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.transaction.id != oldWidget.transaction.id) {
      _isExpanded = false;
    }
  }

  // Вікно підтвердження перед видаленням
  Future<bool> _confirmDeletion(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Підтвердження", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Ви впевнені, що хочете видалити цю транзакцію?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), 
            child: const Text("Скасувати", style: TextStyle(color: AppColors.textSecondary))
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text("Видалити", style: TextStyle(color: AppColors.expense))
          ),
        ],
      ),
    );
    return result ?? false; // Якщо користувач закрив вікно (tap outside), повертаємо false
  }

  @override
  Widget build(BuildContext context) {
    final hasNote = widget.transaction.note != null && widget.transaction.note!.trim().isNotEmpty;
    final formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(widget.transaction.timestamp));
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        // Обертаємо в Container, щоб тінь і рамка були під Slidable, а не над ним
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15), // Зробив тінь ледь помітною і сучасною
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16), // Щоб кнопка видалення не вилазила за кути
          child: Slidable(
            key: ValueKey(widget.transaction.id),
            // СВАЙП ВЛІВО (Кнопка видалення)
            endActionPane: ActionPane(
              motion: const DrawerMotion(), // Анімація "шторки"
              extentRatio: 0.25, // Ширина кнопки (25% екрану)
              // Функція Dismissible (щоб можна було свайпнути до кінця)
              dismissible: DismissiblePane(
                onDismissed: () => context.read<TransactionCubit>().deleteTransaction(widget.transaction.id!),
                confirmDismiss: () => _confirmDeletion(context),
              ),
              children: [
                CustomSlidableAction(
                  onPressed: (context) async {
                    // Якщо користувач просто натиснув на кнопку, а не свайпнув до кінця
                    final shouldDelete = await _confirmDeletion(context);
                    if (shouldDelete && context.mounted) {
                      context.read<TransactionCubit>().deleteTransaction(widget.transaction.id!);
                    }
                  },
                  backgroundColor: AppColors.expense.withAlpha(38), // Світло-червоний фон
                  foregroundColor: AppColors.expense, // Червона іконка
                  padding: EdgeInsets.zero,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline, size: 26),
                      SizedBox(height: 4),
                      Text("Видалити", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            
            // ОСНОВНИЙ ВМІСТ КАРТКИ
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                // Натискання на всю картку відкриває вікно редагування
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<TransactionCubit>(), 
                        child: AddTransactionScreen(categories: widget.allCategories, transactionToEdit: widget.transaction)
                      )
                    )
                  );
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      child: Row(
                        children: [
                          // 1. Іконка категорії (у кружку)
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(
                              color: Color(int.parse(widget.category.colorHex)).withAlpha(38),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              // ВИПРАВЛЕНО: Тепер використовуємо правильний шрифт IconsaxPlusLinear
                              IconData(widget.category.iconCode, fontFamily: 'IconsaxPlusLinear', fontPackage: 'iconsax_plus'), 
                              color: Color(int.parse(widget.category.colorHex)),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // 2. Назва категорії та дата
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.category.name, 
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formattedDate, 
                                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)
                                ),
                              ],
                            ),
                          ),
                          
                          // 3. Сума
                          Text(
                            '${widget.isIncome ? '+' : '-'}${widget.transaction.amount.toStringAsFixed(2)} ${widget.transaction.currency}', 
                            style: TextStyle(
                              color: widget.isIncome ? AppColors.income : AppColors.textPrimary, 
                              fontWeight: FontWeight.w800, // Жирний шрифт для сум
                              fontSize: 16
                            )
                          ),
                          const SizedBox(width: 8),

                          // 4. Стрілочка розгортання (ЯКЩО Є ПРИМІТКА)
                          if (hasNote)
                            GestureDetector(
                              onTap: () => setState(() => _isExpanded = !_isExpanded),
                              // Збільшуємо зону натискання стрілочки
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withAlpha(25),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, 
                                  color: AppColors.textSecondary, 
                                  size: 20
                                ),
                              ),
                            )
                          else
                            // Пусте місце, щоб сума не прилипала до краю, якщо немає стрілочки
                            const SizedBox(width: 28), 
                        ],
                      ),
                    ),
                    
                    // РОЗГОРНУТА ПРИМІТКА
                    AnimatedCrossFade(
                      firstChild: const SizedBox(height: 0, width: double.infinity),
                      secondChild: Container(
                        width: double.infinity, 
                        padding: const EdgeInsets.only(left: 80, right: 16, bottom: 16), 
                        child: Text(
                          widget.transaction.note ?? '', 
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontStyle: FontStyle.italic)
                        )
                      ),
                      crossFadeState: _isExpanded && hasNote ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 250),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}