// ФАЙЛ: lib/features/transactions/presentation/screens/home_screen.dart

import 'dart:ui' as ui; // <--- ДОДАНО ДЛЯ ЕФЕКТУ СКЛА
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/home_constants.dart';
import '../cubit/transaction_cubit.dart';
import '../cubit/transaction_state.dart';
import '../../widgets/carousel_widget.dart';
import '../../widgets/transaction_list_item.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGroupTitle(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate == today) return 'Сьогодні';
    if (checkDate == yesterday) return 'Вчора';
    return DateFormat('d MMMM yyyy', 'uk_UA').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Мій бюджет', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
            error: (message) => Center(child: Text(message, style: const TextStyle(color: AppColors.expense))),
            loaded: (transactions, categories, totalBalance, date, currencyRates) {
              final sortedList = List.from(transactions)..sort((a, b) => b.timestamp.compareTo(a.timestamp));
              final monthName = HomeConstants.months[date.month - 1];

              return Column(
                children: [
                  _buildMonthPicker(context, monthName, date),
                  const SizedBox(height: 12),
                  
                  _buildBalanceCard(context, totalBalance),
                  const SizedBox(height: 16),
                  
                  PromoCarousel(currencyRates: currencyRates),
                  const SizedBox(height: 8),
                  
               Expanded(
                    child: sortedList.isEmpty
                        ? _buildEmptyState()
                        // ДОДАЄМО ShaderMask ДЛЯ ПЛАВНОГО ЗНИКНЕННЯ
                       // ДОДАЄМО ShaderMask ДЛЯ ПЛАВНОГО ЗНИКНЕННЯ
                        : ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white,
                                  Colors.white,
                                  Colors.white.withAlpha(0), // Стає повністю прозорим
                                  Colors.white.withAlpha(0), // Залишається прозорим до самого низу екрана
                                ],
                                stops: [
                                  0.0,
                                  (1.0 - (180 / bounds.height)).clamp(0.0, 1.0), // Починає зникати над кнопкою "Додати"
                                  (1.0 - (90 / bounds.height)).clamp(0.0, 1.0),  // 100% зникає перед самим навбаром
                                  1.0,
                                ],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 190), 
                              itemCount: sortedList.length,
// ... далі твій код ListView.builder ...
                              itemBuilder: (context, index) {
                                final transaction = sortedList[index];
                                final category = categories.firstWhere((c) => c.id == transaction.categoryId);
                                final currentGroupTitle = _getGroupTitle(transaction.timestamp);
                                bool showHeader = index == 0 || _getGroupTitle(sortedList[index - 1].timestamp) != currentGroupTitle;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (showHeader)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                                        child: Text(
                                          currentGroupTitle, 
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary, fontSize: 14)
                                        ),
                                      ),
                                    TransactionListItem(
                                      key: ValueKey(transaction.id),
                                      transaction: transaction,
                                      category: category,
                                      allCategories: categories,
                                      isIncome: category.type == 'income',
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: _buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Щоб кнопка завжди була справа
    );
  }

  Widget _buildMonthPicker(BuildContext context, String monthName, DateTime currentDate) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(IconsaxPlusLinear.arrow_left_2, size: 24, color: AppColors.textSecondary), 
            onPressed: () => context.read<TransactionCubit>().changeMonth(-1)
          ),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context, 
                initialDate: currentDate, 
                firstDate: DateTime(2020), 
                lastDate: DateTime(2100),
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
              if (selectedDate != null && context.mounted) {
                context.read<TransactionCubit>().setMonth(selectedDate);
              }
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
                    '$monthName ${currentDate.year}', 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(IconsaxPlusLinear.arrow_right_2, size: 24, color: AppColors.textSecondary), 
            onPressed: () => context.read<TransactionCubit>().changeMonth(1)
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, double totalBalance) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withAlpha(191)],
          begin: Alignment.topLeft, 
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(76), 
            blurRadius: 20, 
            offset: const Offset(0, 8)
          )
        ],
      ),
      child: Column(
        children: [
          const Text('Загальний баланс за місяць', style: TextStyle(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                totalBalance.toStringAsFixed(2), 
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: PopupMenuButton<String>(
                  initialValue: context.read<TransactionCubit>().mainCurrency,
                  onSelected: (newValue) => context.read<TransactionCubit>().changeMainCurrency(newValue),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: '₴', child: Text('₴ - Гривня', style: TextStyle(fontWeight: FontWeight.bold))),
                    PopupMenuItem(value: '\$', child: Text('\$ - Долар', style: TextStyle(fontWeight: FontWeight.bold))),
                    PopupMenuItem(value: '€', child: Text('€ - Євро', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      children: [
                        Text(
                          context.read<TransactionCubit>().mainCurrency, 
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
                        ),
                        const SizedBox(width: 4),
                        const Icon(IconsaxPlusLinear.arrow_down_1, size: 16, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// // --- ПРОСТИЙ ПОРОЖНІЙ СТАН ---
  Widget _buildEmptyState() {
    return Align(
      alignment: const Alignment(0, -0.8), // Значення -1 це верх, 0 це центр, 1 це низ. -0.4 підніме його трохи вище центру
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/emptyState.json', height: 140),
          const SizedBox(height: 16),
          const Text('Транзакцій ще немає', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
  
  Widget _buildFAB(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 110.0, right: 16.0), // Відступ від навбару та краю
          child: ClipOval( // Кругла форма для ефекту скла
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
              child: Container(
                width: 60, // Фіксований розмір круглої кнопки
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(200), 
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withAlpha(70), width: 1.5), 
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withAlpha(76), blurRadius: 15, offset: const Offset(0, 8)),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      state.maybeWhen(
                        loaded: (_, categories, __, ___, ____) => Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (_) => BlocProvider.value(value: context.read<TransactionCubit>(), child: AddTransactionScreen(categories: categories)))
                        ),
                        orElse: () {},
                      );
                    },
                    customBorder: const CircleBorder(),
                    splashColor: Colors.white.withAlpha(50),
                    child: const Center(
                      child: Icon(IconsaxPlusLinear.add, color: Colors.white, size: 30), // Більша іконка
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}