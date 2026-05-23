import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../app/theme/app_colors.dart';

class AnalyticsEmptyState extends StatelessWidget {
  final bool isExpense;

  const AnalyticsEmptyState({super.key, required this.isExpense});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/emptyStateDiagram.json', repeat: true, frameRate: FrameRate(30), height: 180),
          const SizedBox(height: 16),
          Text(
            isExpense ? 'Немає витрат для аналізу' : 'Немає доходів для аналізу',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}