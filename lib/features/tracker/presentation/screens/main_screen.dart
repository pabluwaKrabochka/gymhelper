import 'package:flutter/material.dart';
import 'package:gymhelper/features/tracker/presentation/screens/profile_screen.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'home_screen.dart';
import 'add_meal_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text('Екран Аналітики (в розробці)')), // Заглушка
    const ProfileScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      
      // 1. Недефолтна, розширена та красива кнопка
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMealScreen()),
          );
        },
        elevation: 4, // Легка тінь
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
           child: const Icon(IconsaxPlusLinear.add),
      ),
      
      // 2. Розташування "centerFloat" змушує кнопку плавати НАД меню, а не врізатись у нього
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
      // 3. Сучасний адаптивний навбар замість старого BottomNavigationBar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 3, // Легке відділення від фону екрану
        destinations: const [
          NavigationDestination(
            icon: Icon(IconsaxPlusLinear.home),
            selectedIcon: Icon(IconsaxPlusBold.home),
            label: 'Щоденник',
          ),
          NavigationDestination(
            icon: Icon(IconsaxPlusLinear.chart),
            selectedIcon: Icon(IconsaxPlusBold.chart),
            label: 'Аналітика',
          ),
          NavigationDestination(
            icon: Icon(IconsaxPlusLinear.profile),
            selectedIcon: Icon(IconsaxPlusBold.profile),
            label: 'Профіль',
          ),
        ],
      ),
    );
  }
}