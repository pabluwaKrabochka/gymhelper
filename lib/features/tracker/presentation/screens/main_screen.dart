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
    const GameScreen(), 
    const ProfileScreen(), 
  ];

  // Допоміжна функція для визначення розміру екрану
  bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600;

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;

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
              // На планшеті трохи відсуваємо кнопку від правого краю та низу
              padding: EdgeInsets.only(right: tablet ? 16.0 : 0.0, bottom: tablet ? 16.0 : 0.0), 
              child: Container(
                width: tablet ? 70 : 56, // Збільшуємо FAB на планшеті
                height: tablet ? 70 : 56,
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
                  child: Icon(IconsaxPlusLinear.add, size: tablet ? 32 : 28, color: Colors.white),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Центруємо острівець
            children: [
              Container(
                // На планшеті ширина фіксована (макс 600), на телефоні - на весь екран з відступами
                width: tablet ? 600 : screenWidth - 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(tablet ? 40 : 30),
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withAlpha(38), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(tablet ? 40 : 30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      height: tablet ? 85 : 70, // Панель трохи вища на планшеті
                      padding: EdgeInsets.symmetric(horizontal: tablet ? 20 : 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(191), 
                        borderRadius: BorderRadius.circular(tablet ? 40 : 30),
                        border: Border.all(color: Colors.white.withAlpha(127), width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(0, IconsaxPlusLinear.home, IconsaxPlusBold.home, 'navbar.diary'.tr(), tablet),
                          _buildNavItem(1, IconsaxPlusLinear.chart, IconsaxPlusBold.chart, 'navbar.analytics'.tr(), tablet),
                          _buildNavItem(2, Icons.sports_esports_outlined, Icons.sports_esports_rounded, 'navbar.game'.tr(), tablet),
                          _buildNavItem(3, IconsaxPlusLinear.profile, IconsaxPlusBold.profile, 'navbar.profile'.tr(), tablet),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label, bool tablet) {
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
        padding: EdgeInsets.symmetric(
          horizontal: tablet ? 16 : 12, 
          vertical: tablet ? 14 : 10
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withAlpha(38) : Colors.transparent,
          borderRadius: BorderRadius.circular(tablet ? 25 : 20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: tablet ? 28 : 24, // Іконки більші на планшеті
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              child: SizedBox(
                width: isSelected ? null : 0,
                child: Padding(
                  padding: EdgeInsets.only(left: isSelected ? (tablet ? 8.0 : 6.0) : 0.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      label,
                      key: ValueKey<String>(label),
                      maxLines: 1,
                      softWrap: false, 
                      style: TextStyle(
                        color: AppColors.primary, 
                        fontWeight: FontWeight.bold, 
                        fontSize: tablet ? 16 : 13 // Шрифт більший на планшеті
                      ), 
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