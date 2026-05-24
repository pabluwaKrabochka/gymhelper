// ФАЙЛ: lib/features/transactions/widgets/carousel_widget.dart
// (або promo_carousel.dart, залежно від того, як ти його назвав)

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gymhelper/core/constants/color_constants.dart';
import 'package:gymhelper/core/constants/home_constants.dart';
import 'package:iconsax_plus/iconsax_plus.dart';


class PromoCarousel extends StatefulWidget {
  final List<dynamic>? currencyRates;
  const PromoCarousel({super.key, this.currencyRates});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  int _currentIndex = 0;

  // --- МОДАЛЬНЕ ВІКНО ДЕТАЛЕЙ БАНЕРА ---
  // --- МОДАЛЬНЕ ВІКНО ДЕТАЛЕЙ БАНЕРА З BLUR ---
  void _showBannerDetails(Map<String, dynamic> banner) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Фон прозорий, щоб бачити blur
      barrierColor: Colors.black.withAlpha(76), // Трохи затемнюємо задній фон
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;
        
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 1. РОЗМИТТЯ (BLUR) ВБИРАЄТЬСЯ В УВЕСЬ ЕКРАН ПІД МОДАЛКОЮ
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            
            // 2. САМА КАРТКА БАНЕРА
            Container(
              constraints: BoxConstraints(maxHeight: screenHeight * 0.88),
              decoration: const BoxDecoration(
                color: AppColors.background, // Сучасний фон (світло-сірий)
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 30, offset: Offset(0, -10)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Смужка для закриття свайпом
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 20),
                      width: 48,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Картинка з гарним скругленням і кнопкою "Х"
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(30), 
                                      blurRadius: 20, 
                                      offset: const Offset(0, 10)
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.asset(
                                    banner["image"],
                                    height: screenHeight * 0.22, // Трохи збільшено для wow-ефекту
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      height: screenHeight * 0.26,
                                      color: Colors.grey[200],
                                      child: const Center(child: Text("Банер відсутній", style: TextStyle(color: AppColors.textSecondary))),
                                    ),
                                  ),
                                ),
                              ),
                              // Кнопка закриття поверх картинки (стиль iOS)
                              Positioned(
                                top: 12,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withAlpha(102), // Напівпрозорий чорний
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(IconsaxPlusLinear.close_circle, color: Colors.white, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          
                          // Назва банера
                          Text(
                            banner["title"],
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900, // Екстра-жирний заголовок
                              color: AppColors.textPrimary,
                              height: 1.2,
                              letterSpacing: -0.5, // Сучасна типографіка
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Опис банера
                          Text(
                            banner["description"],
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              height: 1.6, // Великий інтервал для читабельності
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    // Трохи збільшуємо висоту, щоб вмістити тіні (margin: 8)
    final double carouselHeight = MediaQuery.of(context).size.height * 0.23;

    final List<Widget> items = [
      _buildRatesTable(widget.currencyRates),
      ...HomeConstants.banners.map((b) => _buildClickableBanner(b)),
    ];

    return Column(
      children: [
        CarouselSlider(
          items: items,
          options: CarouselOptions(
            height: carouselHeight,
            viewportFraction: 0.9, // Трохи менше, щоб було видно краї сусідніх карток
            enableInfiniteScroll: true,
            autoPlay: false, // Включив автопрокрутку для динаміки
            autoPlayInterval: const Duration(seconds: 8),
            enlargeCenterPage: true,
            onPageChanged: (index, reason) => setState(() => _currentIndex = index),
          ),
        ),
        const SizedBox(height: 12),
        
        // Індикатори (Крапки)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.asMap().entries.map((entry) {
            final isActive = _currentIndex == entry.key;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 24.0 : 8.0, 
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isActive ? AppColors.primary : Colors.grey.withAlpha(76),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- БАНЕР-КАРТИНКА ---
  Widget _buildClickableBanner(Map<String, dynamic> banner) {
    return GestureDetector(
      onTap: () => _showBannerDetails(banner),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4), // Відступи для тіні
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(22), // М'яка преміальна тінь
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            banner["image"],
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover, // cover краще заповнює простір
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[200],
              child: const Center(child: Text("Банер відсутній", style: TextStyle(color: AppColors.textSecondary))),
            ),
          ),
        ),
      ),
    );
  }

  // --- ТАБЛИЦЯ ВАЛЮТ ---
  Widget _buildRatesTable(List<dynamic>? rates) {
    if (rates == null || rates.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
        child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4), // Відступи для тіні
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15), 
            blurRadius: 15, 
            offset: const Offset(0, 6)
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Валюта', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
              Text('Купівля', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
              Text('Продаж', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.grey.withAlpha(50), height: 1),
          const SizedBox(height: 8),
          
          ...rates.where((e) => e['ccy'] == 'USD' || e['ccy'] == 'EUR').map((rate) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Назва валюти (жирна, темна)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: AppColors.primary.withAlpha(25), shape: BoxShape.circle),
                      child: Text(
                        rate['ccy'] == 'USD' ? '\$' : '€', 
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${rate['ccy']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                  ],
                ),
                // Купівля
                Text('${double.parse(rate['buy']).toStringAsFixed(2)} ₴', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                // Продаж (колір Primary)
                Text('${double.parse(rate['sale']).toStringAsFixed(2)} ₴', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}