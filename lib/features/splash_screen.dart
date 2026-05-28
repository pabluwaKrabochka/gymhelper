import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; 
import 'package:gymhelper/features/tracker/presentation/screens/main_screen.dart';
import '../../core/constants/color_constants.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Трохи збільшили час для максимальної плавності
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500), 
    );

    // ВИПРАВЛЕНО: Замість різкого elasticOut використовуємо дуже плавний easeOutExpo
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutExpo),
      ),
    );

    // Плавна поява тексту (починається трохи пізніше)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    // Текст плавно випливає знизу (easeOutQuart дає м'яке гальмування)
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutQuart),
      ),
    );

    _controller.forward();

    // Загальний час показу сплеш-скріну перед переходом
    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 1000), // Плавний перехід в додаток
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const activeGradient = LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFF3A1C71), Color(0xFFD76D77), Color(0xFFFFAF7B)],
    );

    final primaryGlowColor = activeGradient.colors.first;

    return Scaffold(
      backgroundColor: AppColors.background, 
      body: Stack(
        children: [
          // --- 1. АНІМОВАНИЙ ЕМБІЄНТ ФОН ---
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.5, end: 1.5),
              duration: const Duration(milliseconds: 3000), // Більш плавне дихання фону
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          primaryGlowColor.withAlpha(100), 
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // --- 2. ЕФЕКТ МАТОВОГО СКЛА ---
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.transparent),
          ),

          // --- 3. ЛОГОТИП ДОДАТКУ ТА ТЕКСТ ---
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 140, 
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40), 
                      border: Border.all(
                        color: Colors.white.withAlpha(80), 
                        width: 2
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryGlowColor.withAlpha(150),
                          blurRadius: 40,
                          spreadRadius: 5,
                          offset: const Offset(0, 15),
                        ),
                        BoxShadow(
                          color: activeGradient.colors.last.withAlpha(80),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage('assets/appLogo.png'), 
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 35),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        const Text(
                          'GymHelper',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'splash.subtitle'.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary.withAlpha(200),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}