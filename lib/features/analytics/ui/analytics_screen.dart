// // ФАЙЛ: lib/features/transactions/presentation/screens/analytics_screen.dart

// import 'dart:io';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gymhelper/features/analytics/widgets/analytics_trend_chart.dart';
// import 'package:gymhelper/features/analytics/widgets/analytics_category_list.dart';
// import 'package:gymhelper/features/analytics/widgets/analytics_empty_state.dart';
// import 'package:gymhelper/features/analytics/widgets/analytics_pie_chart.dart';
// import 'package:gymhelper/features/analytics/widgets/analytics_switcher.dart';
// import 'package:iconsax_plus/iconsax_plus.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:gal/gal.dart';
// import '../../../../app/theme/app_colors.dart';

// enum ChartType { pie, bar }
// enum TransactionType { expense, income }

// class AnalyticsScreen extends StatefulWidget {
//   const AnalyticsScreen({super.key});

//   @override
//   State<AnalyticsScreen> createState() => _AnalyticsScreenState();
// }

// class _AnalyticsScreenState extends State<AnalyticsScreen> {
//   ChartType _chartType = ChartType.pie;
//   TransactionType _transactionType = TransactionType.expense;

//   // Ключ для "фотографування" графіка
//   final GlobalKey _chartBoundaryKey = GlobalKey();

//   double _convertAmount(double amount, String fromCurrency, String toCurrency, List<dynamic>? rates) {
//     if (fromCurrency == toCurrency || rates == null || rates.isEmpty) return amount;
    
//     double amountInUAH = amount;
//     if (fromCurrency == '\$') {
//       amountInUAH = amount * double.parse(rates.firstWhere((r) => r['ccy'] == 'USD')['buy']);
//     } else if (fromCurrency == '€') {
//       amountInUAH = amount * double.parse(rates.firstWhere((r) => r['ccy'] == 'EUR')['buy']);
//     }

//     if (toCurrency == '\$') {
//       return amountInUAH / double.parse(rates.firstWhere((r) => r['ccy'] == 'USD')['sale']);
//     } else if (toCurrency == '€') {
//       return amountInUAH / double.parse(rates.firstWhere((r) => r['ccy'] == 'EUR')['sale']);
//     }
//     return amountInUAH;
//   }

//   // --- ЛОГІКА СТВОРЕННЯ СКРІНШОТУ ---
//   Future<String?> _captureChartImage() async {
//     try {
//       // Знаходимо наш віджет по ключу
//       RenderRepaintBoundary boundary = _chartBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//       // Робимо картинку високої якості (pixelRatio: 3.0)
//       ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//       ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//       Uint8List pngBytes = byteData!.buffer.asUint8List();

//       // Зберігаємо в тимчасову папку
//       final directory = await getTemporaryDirectory();
//       final imagePath = '${directory.path}/budget_analytics.png';
//       File imgFile = File(imagePath);
//       await imgFile.writeAsBytes(pngBytes);
      
//       return imagePath;
//     } catch (e) {
//       debugPrint('Помилка при створенні скріншоту: $e');
//       return null;
//     }
//   }

//   // --- МЕТОД: ПОДІЛИТИСЯ (Telegram, Viber і тд) ---
//   Future<void> _shareChart() async {
//     final imagePath = await _captureChartImage();
//     if (imagePath != null) {
//       final typeText = _transactionType == TransactionType.expense ? 'витрат' : 'доходів';
      
//       // ВИПРАВЛЕНО: Використовуємо новий синтаксис SharePlus 10+
//       await SharePlus.instance.share(
//         ShareParams(
//           files: [XFile(imagePath)],
//           text: 'Моя статистика $typeText за цей місяць 📊',
//         ),
//       );
//     }
//   }

//   // --- МЕТОД: ЗБЕРЕГТИ В ГАЛЕРЕЮ ---
//   Future<void> _saveChartToGallery() async {
//     final imagePath = await _captureChartImage();
//     if (imagePath != null) {
//       try {
//         // Запитуємо дозвіл та зберігаємо
//         final hasAccess = await Gal.hasAccess();
//         if (!hasAccess) await Gal.requestAccess();
        
//         await Gal.putImage(imagePath);
        
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Row(
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.white),
//                   SizedBox(width: 8),
//                   Text('Графік збережено в Галерею!'),
//                 ],
//               ),
//               backgroundColor: AppColors.primary,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             ),
//           );
//         }
//       } catch (e) {
//         debugPrint('Помилка збереження в галерею: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: const Text('Аналітика', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         // ДОДАЛИ КНОПКИ ЕКСПОРТУ
//         actions: [
//           IconButton(
//             icon: const Icon(IconsaxPlusLinear.document_download, color: AppColors.textSecondary),
//             tooltip: 'Зберегти',
//             onPressed: _saveChartToGallery,
//           ),
//           IconButton(
//             icon: const Icon(IconsaxPlusLinear.export_1, color: AppColors.primary),
//             tooltip: 'Поділитися',
//             onPressed: _shareChart,
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: BlocBuilder<TransactionCubit, TransactionState>(
//         builder: (context, state) {
//           return state.maybeWhen(
//            loaded: (transactions, categories, totalBalance, date, currencyRates) {
//              final cubit = context.read<TransactionCubit>();
//              final currentDate = cubit.currentDate;
//              final mainCurrency = cubit.mainCurrency;

//              final targetType = _transactionType == TransactionType.expense ? 'expense' : 'income';
//              final filteredTransactions = transactions.where((t) {
//                final category = categories.firstWhere((c) => c.id == t.categoryId);
//                return category.type == targetType;
//              }).toList();

//              Map<String, double> totals = {};
//              Map<String, Color> categoryColors = {};
//              double totalAmount = 0;
//              Map<int, Map<String, double>> dailyCategoryTotals = {}; 

//              for (var t in filteredTransactions) {
//                final category = categories.firstWhere((c) => c.id == t.categoryId);
//                double convertedAmount = _convertAmount(t.amount, t.currency, mainCurrency, currencyRates);

//                totals[category.name] = (totals[category.name] ?? 0) + convertedAmount;
//                categoryColors[category.name] = Color(int.parse(category.colorHex));
//                totalAmount += convertedAmount;

//                final day = DateTime.fromMillisecondsSinceEpoch(t.timestamp).day;
//                if (dailyCategoryTotals[day] == null) dailyCategoryTotals[day] = {};
//                dailyCategoryTotals[day]![category.name] = (dailyCategoryTotals[day]![category.name] ?? 0) + convertedAmount;
//              }

//              var sortedTotals = totals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
//              Map<String, double> sortedTotalsMap = Map.fromEntries(sortedTotals);
//              final daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;

//              return Column(
//                children: [
//                  AnalyticsDatePicker(cubit: cubit, date: currentDate),
//                  Padding(
//                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
//                    child: AnalyticsSwitchers(
//                      chartType: _chartType,
//                      transactionType: _transactionType,
//                      onChartTypeChanged: (val) => setState(() => _chartType = val),
//                      onTransactionTypeChanged: (val) => setState(() => _transactionType = val),
//                    ),
//                  ),
//                  Expanded(
//                    child: filteredTransactions.isEmpty
//                        ? AnalyticsEmptyState(isExpense: _transactionType == TransactionType.expense)
//                        : Column(
//                            children: [
//                              const SizedBox(height: 16),
                             
//                              // --- REPAINT BOUNDARY ---
//                              // Огортаємо лише графік, щоб на збереженій картинці був білий фон і сам графік
//                              RepaintBoundary(
//                                key: _chartBoundaryKey,
//                                child: Container(
//                                  color: AppColors.background, // Важливо: фон для картинки, щоб не була прозорою
//                                  padding: const EdgeInsets.symmetric(vertical: 16),
//                                  child: Column(
//                                    children: [
//                                      // Додаємо заголовок на збережену картинку
//                                      Text(
//                                       _transactionType == TransactionType.expense ? 'Витрати за місяць' : 'Доходи за місяць',
//                                       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
//                                      ),
//                                      const SizedBox(height: 16),
//                                      AnimatedSwitcher(
//                                        duration: const Duration(milliseconds: 400),
//                                        child: _chartType == ChartType.pie
//                                            ? AnalyticsPieChart(totals: sortedTotalsMap, categoryColors: categoryColors, totalAmount: totalAmount, mainCurrency: mainCurrency)
//                                            : AnalyticsTrendChart(dailyCategoryTotals: dailyCategoryTotals, daysInMonth: daysInMonth, categoryColors: categoryColors, mainCurrency: mainCurrency),
//                                      ),
//                                    ],
//                                  ),
//                                ),
//                              ),

//                              const SizedBox(height: 12),
//                              Expanded(
//                                child: AnalyticsCategoryList(
//                                  totals: sortedTotalsMap, 
//                                  categoryColors: categoryColors, 
//                                  totalAmount: totalAmount, 
//                                  mainCurrency: mainCurrency
//                                ),
//                              ),
//                            ],
//                          ),
//                  ),
//                ],
//              );
//            },
//            orElse: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
//           );
//         },
//       ),
//     );
//   }
// }