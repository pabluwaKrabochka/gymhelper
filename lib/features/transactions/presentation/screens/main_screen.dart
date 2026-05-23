// ФАЙЛ: lib/features/transactions/presentation/screens/main_screen.dart

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/di/service_locator.dart';
import 'package:gymhelper/features/categories/ui/categories_screen.dart';
import '../cubit/transaction_cubit.dart';
import 'home_screen.dart';
import '../../../analytics/ui/analytics_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AnalyticsScreen(),
    const CategoriesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TransactionCubit>()..loadData(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true, 
        body: _screens[_currentIndex],
        
        // LIQUID GLASS NAVBAR
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tabWidth = constraints.maxWidth / _screens.length;

                return Container(
                  height: 76, 
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(178), // Замість withOpacity(0.7)
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 20, offset: const Offset(0, 10)), // 0.08
                      BoxShadow(color: Colors.white.withAlpha(153), blurRadius: 1, spreadRadius: 1, offset: const Offset(0, -1)), // 0.6
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutBack, 
                            left: _currentIndex * tabWidth,
                            top: 0,
                            bottom: 0,
                            width: tabWidth,
                            child: Container(
                              margin: const EdgeInsets.all(8), 
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(38), // 0.15
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                          ),
                          
                          Row(
                            children: [
                              _buildNavItem(0, 'Транзакції', IconsaxPlusLinear.wallet_1, tabWidth),
                              _buildNavItem(1, 'Аналітика', IconsaxPlusLinear.chart_2, tabWidth),
                              _buildNavItem(2, 'Категорії', IconsaxPlusLinear.category, tabWidth),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon, double width) {
    final isActive = _currentIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isActive ? 1.0 : 0.6, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 400),
                scale: isActive ? 1.15 : 1.0, 
                curve: Curves.easeOutBack,
                child: Icon(
                  icon,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  size: 26,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}