import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../../app/theme/app_colors.dart';

class AnalyticsCategoryList extends StatelessWidget {
  final Map<String, double> totals;
  final Map<String, Color> categoryColors;
  final double totalAmount;
  final String mainCurrency;

  const AnalyticsCategoryList({super.key, required this.totals, required this.categoryColors, required this.totalAmount, required this.mainCurrency});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white, Colors.white.withAlpha(0), Colors.white.withAlpha(0)],
          stops: [0.0, (1.0 - (180 / bounds.height)).clamp(0.0, 1.0), (1.0 - (90 / bounds.height)).clamp(0.0, 1.0), 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 180, left: 16, right: 16), 
        itemCount: totals.length,
        itemBuilder: (context, index) {
          String categoryName = totals.keys.elementAt(index);
          double amount = totals.values.elementAt(index);
          Color color = categoryColors[categoryName]!;
          final percent = (amount / totalAmount) * 100;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: color.withAlpha(40), shape: BoxShape.circle),
                child: Icon(IconsaxPlusLinear.category, color: color),
              ),
              title: Text(categoryName, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              subtitle: Text('${percent.toStringAsFixed(1)}%', style: const TextStyle(color: AppColors.textSecondary)),
              trailing: Text('${amount.toStringAsFixed(2)} $mainCurrency', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
            ),
          );
        },
      ),
    );
  }
}