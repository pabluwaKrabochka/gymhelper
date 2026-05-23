import 'package:flutter/material.dart';
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
    const Center(child: Text('Екран Аналітики (в розробці)')), 
    const ProfileScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_currentIndex],
      
      // Акуратна градієнтна кнопка ТІЛЬКИ на головному екрані
      floatingActionButton: _currentIndex == 0 
          ? Container(
              decoration: BoxDecoration(
                gradient: AppColors.premiumGradient, // Наш фірмовий градієнт
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(102),
                    blurRadius: 12,
                    offset: const Offset(0, 4), // Легка тінь вниз
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddMealScreen()),
                  );
                },
                backgroundColor: Colors.transparent, // Прозорий фон, щоб працював градієнт
                elevation: 0, // Тінь вже є у Container
                child: const Icon(IconsaxPlusLinear.add, size: 28, color: Colors.white),
              ),
            )
          : null,
      
      // Стандартне розташування праворуч внизу
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
      // Адаптований під дизайн навбар
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withAlpha(38), // Легкий колір виділеної вкладки
        elevation: 8, 
        destinations: const [
          NavigationDestination(
            icon: Icon(IconsaxPlusLinear.home, color: AppColors.textSecondary),
            selectedIcon: Icon(IconsaxPlusBold.home, color: AppColors.primary),
            label: 'Щоденник',
          ),
          NavigationDestination(
            icon: Icon(IconsaxPlusLinear.chart, color: AppColors.textSecondary),
            selectedIcon: Icon(IconsaxPlusBold.chart, color: AppColors.primary),
            label: 'Аналітика',
          ),
          NavigationDestination(
            icon: Icon(IconsaxPlusLinear.profile, color: AppColors.textSecondary),
            selectedIcon: Icon(IconsaxPlusBold.profile, color: AppColors.primary),
            label: 'Профіль',
          ),
        ],
      ),
    );
  }
}