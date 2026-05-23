import 'package:flutter/material.dart';
import 'package:gymhelper/features/transactions/presentation/cubit/transaction_cubit.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../../app/theme/app_colors.dart';

class AnalyticsDatePicker extends StatelessWidget {
  final TransactionCubit cubit;
  final DateTime date;

  const AnalyticsDatePicker({super.key, required this.cubit, required this.date});

  @override
  Widget build(BuildContext context) {
    const months = ['Січень', 'Лютий', 'Березень', 'Квітень', 'Травень', 'Червень', 'Липень', 'Серпень', 'Вересень', 'Жовтень', 'Листопад', 'Грудень'];
    final monthName = months[date.month - 1];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(IconsaxPlusLinear.arrow_left_2, size: 24, color: AppColors.textSecondary), 
            onPressed: () => cubit.changeMonth(-1),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                initialDatePickerMode: DatePickerMode.year,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: AppColors.primary, 
                        onPrimary: Colors.white, 
                        onSurface: AppColors.textPrimary,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null && context.mounted) cubit.setMonth(picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Icon(IconsaxPlusLinear.calendar_1, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    '$monthName ${date.year}', 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(IconsaxPlusLinear.arrow_right_2, size: 24, color: AppColors.textSecondary), 
            onPressed: () => cubit.changeMonth(1),
          ),
        ],
      ),
    );
  }
}