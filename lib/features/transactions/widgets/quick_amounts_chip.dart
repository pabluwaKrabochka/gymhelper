import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../../app/theme/app_colors.dart';

class QuickAmountChips extends StatelessWidget {
  final List<double> amounts;
  final ValueChanged<double> onAmountTapped;

  const QuickAmountChips({super.key, required this.amounts, required this.onAmountTapped});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: amounts.map((amount) {
        final String label = amount >= 1000 ? '${(amount / 1000).toStringAsFixed(0)}k' : amount.toStringAsFixed(0);
        return InkWell(
          onTap: () => onAmountTapped(amount),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withAlpha(50)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(IconsaxPlusLinear.add, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(label, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}