import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Додано
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/theme/app_colors.dart'; // Імпорт твоїх кольорів
import 'main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Дані для слайдів
  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Контроль витрат',
      description: 'Легко додавайте та редагуйте транзакції. Зручно фіксуйте та переглядайте витрати та надходження.',
      animationAsset: 'assets/computerEconomics.json', 
    ),
    OnboardingData(
      title: 'Аналітика по місяцях',
      description: 'Візуалізуйте свої витрати за допомогою діаграм та графіків за обраний період часу.',
      animationAsset: 'assets/analytics.json', 
    ),
    OnboardingData(
      title: 'Приватність даних',
      description: 'Вся ваша фінансова інформація зберігається локально на телефоні без доступу до інтернету.',
      animationAsset: 'assets/privacy.json', 
    ),
  ];

  Future<void> _finishOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_run', false);

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight, // Використовуємо AppColors
      body: SafeArea(
        child: Column(
          children: [
            // Перегляд слайдів (PageView)
            Expanded(
              flex: 4,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // --- LOTTIE АНІМАЦІЯ ---
                        SizedBox(
                          height: 250,
                          child: Lottie.asset(
                            page.animationAsset,
                            repeat: true, // Анімація повторюється
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Заголовок
                        Text(
                          page.title,
                          style: const TextStyle(
                            fontSize: 28, 
                            fontWeight: FontWeight.bold, 
                            color: AppColors.primary // Використовуємо AppColors
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        
                        // Опис
                        Text(
                          page.description,
                          style: const TextStyle(
                            fontSize: 16, 
                            color: AppColors.black, // Використовуємо AppColors
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // --- ІНДИКАТОРИ СЛАЙДІВ (Dots) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => Container(
                  height: 10,
                  width: _currentPage == index ? 25 : 10,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: _currentPage == index 
                      ? AppColors.primary 
                      : AppColors.grey.withAlpha(122),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // --- ПОСТІЙНА КНОПКА "ПОЧАТИ" (Skip) ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => _finishOnboarding(context),
                  child: const Text('Почати роботу', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Простий клас для зберігання даних слайду
class OnboardingData {
  final String title;
  final String description;
  final String animationAsset;

  OnboardingData({
    required this.title,
    required this.description,
    required this.animationAsset,
  });
}