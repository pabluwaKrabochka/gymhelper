import 'package:flutter/material.dart';
import 'package:gymhelper/features/analytics/ui/analytics_screen.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../../app/theme/app_colors.dart';


class AnalyticsSwitchers extends StatelessWidget {
  final TransactionType transactionType;
  final ChartType chartType;
  final ValueChanged<TransactionType> onTransactionTypeChanged;
  final ValueChanged<ChartType> onChartTypeChanged;

  const AnalyticsSwitchers({
    super.key,
    required this.transactionType,
    required this.chartType,
    required this.onTransactionTypeChanged,
    required this.onChartTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: SegmentedButton<TransactionType>(
            segments: const [
              ButtonSegment(value: TransactionType.expense, label: Text('Витрати')),
              ButtonSegment(value: TransactionType.income, label: Text('Доходи')),
            ],
            selected: {transactionType},
            onSelectionChanged: (val) => onTransactionTypeChanged(val.first),
            style: SegmentedButton.styleFrom(
              backgroundColor: Colors.white,
              selectedBackgroundColor: AppColors.primary.withAlpha(25),
              selectedForegroundColor: AppColors.primary,
              foregroundColor: AppColors.textSecondary,
              side: BorderSide(color: Colors.grey.withAlpha(25)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: SegmentedButton<ChartType>(
            segments: const [
              ButtonSegment(value: ChartType.pie, label: Text('Діаграма'), icon: Icon(IconsaxPlusLinear.chart_21)),
              ButtonSegment(value: ChartType.bar, label: Text('Графік'), icon: Icon(IconsaxPlusLinear.chart_square)),
            ],
            selected: {chartType},
            onSelectionChanged: (val) => onChartTypeChanged(val.first),
            style: SegmentedButton.styleFrom(
              backgroundColor: Colors.white,
              selectedBackgroundColor: AppColors.primary.withAlpha(25),
              selectedForegroundColor: AppColors.primary,
              foregroundColor: AppColors.textSecondary,
              side: BorderSide(color: Colors.grey.withAlpha(25)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }
}