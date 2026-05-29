import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymhelper/core/theme_cubit.dart'; // Перевір свій шлях

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ThemeCubit>();

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        // Визначаємо, яка тема ФАКТИЧНО зараз відображається
        final isDarkMode = mode == ThemeMode.dark || 
            (mode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark);

        return GestureDetector(
          onTap: () {
            cubit.setTheme(isDarkMode ? ThemeMode.light : ThemeMode.dark);
          },
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutBack,
            width: 64, 
            height: 32, 
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: isDarkMode 
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)] 
                    : [const Color(0xFF60A5FA), const Color(0xFF38BDF8)], 
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDarkMode ? 80 : 30),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // ВИПРАВЛЕНО: Positioned тепер зовні, а AnimatedOpacity всередині!
                Positioned(
                  left: 8, 
                  top: 10, 
                  child: AnimatedOpacity(
                    opacity: isDarkMode ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 400),
                    child: const Icon(Icons.star_rounded, size: 8, color: Colors.white70),
                  ),
                ),
                Positioned(
                  left: 20, 
                  top: 18, 
                  child: AnimatedOpacity(
                    opacity: isDarkMode ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: const Icon(Icons.star_rounded, size: 6, color: Colors.white54),
                  ),
                ),
                Positioned(
                  right: 8, 
                  top: 10, 
                  child: AnimatedOpacity(
                    opacity: isDarkMode ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 400),
                    child: const Icon(Icons.cloud_rounded, size: 12, color: Colors.white70),
                  ),
                ),

                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutBack,
                  top: 2,
                  left: isDarkMode ? 34 : 2, 
                  child: AnimatedRotation(
                    turns: isDarkMode ? 1.0 : 0.0, 
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOutBack,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                        child: isDarkMode
                            ? Icon(Icons.nightlight_round, key: const ValueKey('moon'), color: Colors.indigo.shade400, size: 18)
                            : const Icon(Icons.wb_sunny_rounded, key: ValueKey('sun'), color: Colors.orange, size: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}