import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gymhelper/core/constants/color_constants.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class CustomSnackbar {
  static OverlayEntry? _currentEntry;

  // Успішна дія (зелений / градієнтний)
  static void showSuccess(BuildContext context, String message) {
    _showOverlay(
      context,
      message,
      icon: IconsaxPlusBold.tick_circle,
      gradient: AppColors.premiumGradient,
    );
  }

  // Помилка (червоний)
  static void showError(BuildContext context, String message) {
    _showOverlay(
      context,
      message,
      icon: IconsaxPlusBold.close_circle,
      gradient: const LinearGradient(
        colors: [Color(0xFFEF4444), Color(0xFFDC2626)], // Червоні відтінки
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  // Метод, який створює і показує Overlay
  static void _showOverlay(
    BuildContext context,
    String message, {
    required IconData icon,
    required Gradient gradient,
  }) {
    // Якщо вже є активний снекбар - прибираємо його, щоб не накладалися
    _currentEntry?.remove();

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _AnimatedToast(
        message: message,
        icon: icon,
        gradient: gradient,
        onDismissed: () {
          if (_currentEntry == entry) {
            _currentEntry?.remove();
            _currentEntry = null;
          }
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }
}

// Приватний віджет, який відповідає за красу та анімацію
class _AnimatedToast extends StatefulWidget {
  final String message;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onDismissed;

  const _AnimatedToast({
    required this.message,
    required this.icon,
    required this.gradient,
    required this.onDismissed,
  });

  @override
  State<_AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<_AnimatedToast> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // Плавна тривалість анімації
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Анімація виїзду зверху з легким "пружинним" ефектом (easeOutBack)
    _slideAnimation = Tween<Offset>(begin: const Offset(0, -1.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Запускаємо анімацію появи
    _controller.forward();

    // Снекбар висітиме 3 секунди, а потім поїде назад
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismissed());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SafeArea гарантує, що снекбар не перекриє "чубчик" (notch) чи статус-бар телефону
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter, // Вирівнювання по центру зверху
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
          child: Material(
            color: Colors.transparent,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: widget.gradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        // ЗАМІНЕНО: withOpacity(0.4) -> withAlpha(102)
                        color: widget.gradient.colors.last.withAlpha(102),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(widget.icon, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}