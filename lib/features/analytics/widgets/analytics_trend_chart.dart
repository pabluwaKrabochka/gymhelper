// ФАЙЛ: lib/features/transactions/presentation/screens/analytics_widgets/analytics_trend_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../../app/theme/app_colors.dart';

class AnalyticsTrendChart extends StatefulWidget {
  final Map<int, Map<String, double>> dailyCategoryTotals;
  final int daysInMonth;
  final Map<String, Color> categoryColors;
  final String mainCurrency;

  const AnalyticsTrendChart({
    super.key, 
    required this.dailyCategoryTotals, 
    required this.daysInMonth, 
    required this.categoryColors,
    required this.mainCurrency,
  });

  @override
  State<AnalyticsTrendChart> createState() => _AnalyticsTrendChartState();
}

class _AnalyticsTrendChartState extends State<AnalyticsTrendChart> {
  bool _isBarChart = true; // Перемикач типу графіка

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Міні-перемикач Стовпчики / Лінія
        Padding(
          padding: const EdgeInsets.only(right: 20, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(IconsaxPlusLinear.chart_square, color: _isBarChart ? AppColors.primary : Colors.grey.withAlpha(150), size: 20),
                      onPressed: () => setState(() => _isBarChart = true),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                    ),
                    IconButton(
                      icon: Icon(Icons.show_chart, color: !_isBarChart ? AppColors.primary : Colors.grey.withAlpha(150), size: 20),
                      onPressed: () => setState(() => _isBarChart = false),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        Container(
          key: const ValueKey('trend_chart'),
          height: 250,
          padding: const EdgeInsets.only(top: 10, right: 20, left: 16),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _isBarChart ? _buildBarChart() : _buildLineChart(),
          ),
        ),
      ],
    );
  }

  // --- СТОВПЧИКОВИЙ ГРАФІК ---
  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        // Налаштування спливаючих підказок (Tooltips)
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.blueGrey.shade800.withAlpha(230),
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toStringAsFixed(0)} ${widget.mainCurrency}\n',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                children: [
                  const TextSpan(text: 'День ', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.normal)),
                  TextSpan(text: '${group.x.toInt()}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              );
            },
          ),
        ),
        gridData: FlGridData(
          show: true, drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withAlpha(25), strokeWidth: 1),
        ),
        titlesData: _buildTitlesData(),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(widget.daysInMonth, (i) {
          int day = i + 1;
          final dayTotals = widget.dailyCategoryTotals[day] ?? {};
          
          List<BarChartRodStackItem> stackItems = [];
          double currentY = 0;
          
          dayTotals.forEach((catName, amount) {
            final color = widget.categoryColors[catName] ?? Colors.grey;
            stackItems.add(BarChartRodStackItem(currentY, currentY + amount, color));
            currentY += amount;
          });

          return BarChartGroupData(
            x: day,
            barRods: [
              BarChartRodData(
                toY: currentY, 
                width: 14, 
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)), 
                rodStackItems: stackItems, 
                color: Colors.transparent, 
              )
            ],
          );
        }),
      ),
    );
  }

  // --- ЛІНІЙНИЙ ГРАФІК (Плавний тренд) ---
  Widget _buildLineChart() {
    List<FlSpot> spots = [];
    
    for (int i = 1; i <= widget.daysInMonth; i++) {
      final dayTotals = widget.dailyCategoryTotals[i] ?? {};
      double totalForDay = 0;
      dayTotals.forEach((_, amount) => totalForDay += amount);
      spots.add(FlSpot(i.toDouble(), totalForDay));
    }

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.blueGrey.shade800.withAlpha(230),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                return LineTooltipItem(
                  '${touchedSpot.y.toStringAsFixed(0)} ${widget.mainCurrency}\n',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  children: [
                    const TextSpan(text: 'День ', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.normal)),
                    TextSpan(text: '${touchedSpot.x.toInt()}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                );
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
          show: true, drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withAlpha(25), strokeWidth: 1),
        ),
        titlesData: _buildTitlesData(),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true, // Плавна лінія Безьє
            color: AppColors.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false), // Ховаємо точки, щоб було чистіше
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withAlpha(40), // Градієнтна заливка знизу
            ),
          ),
        ],
      ),
    );
  }

  // Спільні налаштування осей для обох графіків
  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), 
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 36, 
          getTitlesWidget: (value, meta) {
            bool isShow = value == 1 || value == widget.daysInMonth || (value % 5 == 0 && (widget.daysInMonth - value) > 2);
            if (isShow) {
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  value.toInt().toString(), 
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}