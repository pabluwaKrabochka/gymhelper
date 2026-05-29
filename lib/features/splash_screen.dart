import 'dart:async';
import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gymhelper/core/constants/color_constants.dart'; 
import 'package:gymhelper/features/tracker/presentation/screens/main_screen.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

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

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500), 
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutExpo), // Логотип з'являється трохи пізніше
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutQuart),
      ),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 3800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 1000), 
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
    // Красивий спортивний/неоновий градієнт
    final gradientStart = AppColors.isDarkMode ? const Color(0xFF0F172A) : const Color(0xFF2E1A47);
    final gradientMiddle = AppColors.isDarkMode ? const Color(0xFF1E293B) : const Color(0xFF6B3A82);
    final gradientEnd = AppColors.isDarkMode ? const Color(0xFF334155) : const Color(0xFFD76D77);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [gradientStart, gradientMiddle, gradientEnd],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // --- ФОНОВІ ЕЛЕМЕНТИ ТРЕНУВАННЯ ---
            const _AnimatedEquipment(icon: Icons.fitness_center, top: 60, left: 30, size: 70, delay: 100, angle: -0.4), // Гантеля
            const _AnimatedEquipment(icon: Icons.timer_outlined, top: 120, right: 40, size: 50, delay: 300, angle: 0.2), // Таймер
            const _AnimatedEquipment(icon: IconsaxPlusLinear.weight, top: 250, left: -20, size: 90, delay: 500, angle: 0.1), // Гиря (зліва частково обрізана)
            const _AnimatedEquipment(icon: Icons.monitor_heart_outlined, top: 320, right: 20, size: 60, delay: 700, angle: -0.2), // Пульс
            const _AnimatedEquipment(icon: Icons.sports_gymnastics, bottom: 220, left: 40, size: 55, delay: 900, angle: 0.3), // Гімнастика
            const _AnimatedEquipment(icon: Icons.directions_run_rounded, bottom: 120, right: 50, size: 65, delay: 1100, angle: -0.1), // Біг
            const _AnimatedEquipment(icon: Icons.local_fire_department_outlined, bottom: -10, left: 100, size: 80, delay: 1300, angle: 0.0), // Вогонь
            const _AnimatedEquipment(icon: Icons.fitness_center, top: -10, right: 120, size: 50, delay: 600, angle: 0.5), // Ще одна гантеля

            // --- ЦЕНТРАЛЬНИЙ ЛОГОТИП ТА ТЕКСТ ---
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
                            color: gradientMiddle.withAlpha(150),
                            blurRadius: 40,
                            spreadRadius: 5,
                            offset: const Offset(0, 15),
                          ),
                          BoxShadow(
                            color: gradientEnd.withAlpha(80),
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
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'splash.subtitle'.tr(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
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
      ),
    );
  }
}

// =====================================================================
// ВІДЖЕТ ФОНОВИХ АНІМОВАНИХ ІКОНОК (Гантельки, таймери тощо)
// =====================================================================
class _AnimatedEquipment extends StatefulWidget {
  final IconData icon;
  final double? top, bottom, left, right;
  final double size;
  final int delay;
  final double angle;

  const _AnimatedEquipment({
    required this.icon,
    this.top, 
    this.bottom, 
    this.left, 
    this.right,
    required this.size, 
    required this.delay,
    required this.angle,
  });

  @override
  State<_AnimatedEquipment> createState() => _AnimatedEquipmentState();
}

class _AnimatedEquipmentState extends State<_AnimatedEquipment> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Ефект пружини при вискакуванні
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top, 
      bottom: widget.bottom,
      left: widget.left, 
      right: widget.right,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Transform.rotate(
          angle: widget.angle * pi, // Нахил іконки
          child: Opacity(
            opacity: 0.15, // Робимо їх напівпрозорими, щоб не відволікали від центру
            child: Icon(
              widget.icon,
              size: widget.size,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}