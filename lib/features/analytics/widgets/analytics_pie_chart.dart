// ФАЙЛ: lib/features/transactions/presentation/screens/analytics_widgets/analytics_pie_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../app/theme/app_colors.dart';

class AnalyticsPieChart extends StatefulWidget {
  final Map<String, double> totals;
  final Map<String, Color> categoryColors;
  final double totalAmount;
  final String mainCurrency;

  const AnalyticsPieChart({
    super.key, 
    required this.totals, 
    required this.categoryColors, 
    required this.totalAmount,
    required this.mainCurrency,
  });

  @override
  State<AnalyticsPieChart> createState() => _AnalyticsPieChartState();
}

class _AnalyticsPieChartState extends State<AnalyticsPieChart> {
  int touchedIndex = -1; // Індекс сектора, на який натиснули

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = [];
    int currentIndex = 0;
    
    // Змінні для відображення в центрі
    String centerTitle = 'Усього';
    String centerAmount = widget.totalAmount.toStringAsFixed(0);
    Color centerColor = AppColors.textPrimary;

    widget.totals.forEach((name, amount) {
      final isTouched = currentIndex == touchedIndex;
      final percent = (amount / widget.totalAmount) * 100;
      final showTitle = percent > 5 || isTouched; 
      
      // Якщо на цей сектор натиснули, оновлюємо текст по центру
      if (isTouched) {
        centerTitle = name;
        centerAmount = '${amount.toStringAsFixed(0)} ${widget.mainCurrency}';
        centerColor = widget.categoryColors[name]!;
      }

      sections.add(
        PieChartSectionData(
          color: widget.categoryColors[name],
          value: amount,
          title: showTitle ? '${percent.toStringAsFixed(0)}%' : '',
          radius: isTouched ? 70.0 : 55.0, // Збільшуємо радіус при натисканні
          titleStyle: TextStyle(
            fontSize: isTouched ? 16 : 14, 
            fontWeight: FontWeight.bold, 
            color: Colors.white,
            shadows: isTouched ? [const Shadow(color: Colors.black26, blurRadius: 4)] : null,
          ),
        ),
      );
      currentIndex++;
    });

    return SizedBox(
      key: const ValueKey('pie_chart'),
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1; // Скидаємо виділення, якщо клік повз
                      return;
                    }
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sections: sections,
              centerSpaceRadius: 75, // Збільшив дірку, щоб влізли дані категорії
              sectionsSpace: 3,
            ),
          ),
          // Текст по центру бублика (Анімований)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Column(
              key: ValueKey(centerTitle), // Ключ для плавної анімації зміни тексту
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  centerTitle, 
                  style: TextStyle(
                    color: touchedIndex == -1 ? AppColors.textSecondary : centerColor, 
                    fontSize: 13,
                    fontWeight: touchedIndex == -1 ? FontWeight.normal : FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  centerAmount, 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.textPrimary),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}