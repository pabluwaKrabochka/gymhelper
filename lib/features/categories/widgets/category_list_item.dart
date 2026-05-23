import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/features/categories/widgets/add_category_form.dart';
import 'package:gymhelper/features/transactions/presentation/cubit/transaction_cubit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../data/models/category_model.dart';


class CategoryListItem extends StatelessWidget {
  final CategoryModel category;

  const CategoryListItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(9),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Slidable(
            key: Key(category.id.toString()),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.25,
              children: [
                CustomSlidableAction(
                  onPressed: (ctx) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text('Видалити категорію?', style: TextStyle(fontWeight: FontWeight.bold)),
                        content: const Text('Увага: це видалить усі транзакції, які належать до цієї категорії!'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Скасувати', style: TextStyle(color: AppColors.textSecondary))),
                          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Видалити', style: TextStyle(color: AppColors.expense))),
                        ],
                      ),
                    );
                    if (confirm == true && context.mounted) {
                      context.read<TransactionCubit>().deleteCategory(category.id!);
                    }
                  },
                  backgroundColor: AppColors.expense.withAlpha(40),
                  foregroundColor: AppColors.expense,
                  padding: EdgeInsets.zero,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(IconsaxPlusLinear.trash, size: 26),
                      SizedBox(height: 4),
                      Text("Видалити", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => AddCategoryForm.show(context, category),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Color(int.parse(category.colorHex)).withAlpha(40),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          IconData(category.iconCode, fontFamily: 'IconsaxPlusLinear', fontPackage: 'iconsax_plus'), 
                          color: Color(int.parse(category.colorHex)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                            const SizedBox(height: 4),
                            Text(category.type == 'income' ? 'Дохід' : 'Витрата', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(IconsaxPlusLinear.edit_2, color: AppColors.textSecondary, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}