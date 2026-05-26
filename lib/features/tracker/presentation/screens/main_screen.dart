import 'dart:ui'; 
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymhelper/features/analytics/ui/analytics_screen.dart';
import 'package:gymhelper/features/minigame/screens/game_screen.dart';
import 'package:gymhelper/features/tracker/presentation/screens/profile_screen.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'home_screen.dart';
import 'add_meal_screen.dart';
import '../../../../core/constants/color_constants.dart';

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
    const GameScreen(), // ДОДАЛИ ГРУ СЮДИ (індекс 2)
    const ProfileScreen(), // ПРОФІЛЬ ТЕПЕР ТУТ (індекс 3)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true, 
      
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Container(
          key: ValueKey<int>(_currentIndex),
          child: _screens[_currentIndex],
        ),
      ),

      floatingActionButton: _currentIndex == 0
          ? Padding(
              padding: const EdgeInsets.only(bottom: 0.0), 
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.premiumGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withAlpha(102), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddMealScreen()),
                    );
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: const Icon(IconsaxPlusLinear.add, size: 28, color: Colors.white),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(color: AppColors.primary.withAlpha(38), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(191), 
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withAlpha(127), width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, IconsaxPlusLinear.home, IconsaxPlusBold.home, 'navbar.diary'.tr()),
                    _buildNavItem(1, IconsaxPlusLinear.chart, IconsaxPlusBold.chart, 'navbar.analytics'.tr()),
                    // 4 КНОПКА: ГРА
                    _buildNavItem(2, Icons.sports_esports_outlined, Icons.sports_esports_rounded, 'navbar.game'.tr()),
                    _buildNavItem(3, IconsaxPlusLinear.profile, IconsaxPlusBold.profile, 'navbar.profile'.tr()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350), 
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Зменшив horizontal padding для 4 кнопок
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withAlpha(38) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24, // Трохи зменшив іконку, щоб 4 кнопки красиво влізли
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              child: SizedBox(
                width: isSelected ? null : 0,
                child: Padding(
                  padding: EdgeInsets.only(left: isSelected ? 6.0 : 0.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      label,
                      key: ValueKey<String>(label),
                      maxLines: 1,
                      softWrap: false, 
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13), // Трохи зменшив шрифт
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}