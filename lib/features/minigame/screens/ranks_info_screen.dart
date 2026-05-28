import 'dart:ui';
import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:easy_localization/easy_localization.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../../../../core/constants/color_constants.dart';

// --- СПІЛЬНА МОДЕЛЬ ДАНИХ ДЛЯ РАНГІВ ---
class RankData {
  final String nameKey;
  final String descKey;
  final int minScore;
  final Color color;
  final IconData icon;

  const RankData({
    required this.nameKey, 
    required this.descKey, 
    required this.minScore, 
    required this.color, 
    required this.icon
  });
}

// --- ПОМІЧНИК ДЛЯ ВИЗНАЧЕННЯ РАНГУ ---
class RankHelper {
  static final List<RankData> ranks = [
    const RankData(nameKey: 'game.rank_10', descKey: 'game.rank_10_desc', minScore: 120, color: Colors.redAccent, icon: Icons.diamond_rounded),
    const RankData(nameKey: 'game.rank_9', descKey: 'game.rank_9_desc', minScore: 105, color: Colors.deepPurpleAccent, icon: Icons.star_rounded),
    const RankData(nameKey: 'game.rank_8', descKey: 'game.rank_8_desc', minScore: 90, color: Colors.orangeAccent, icon: Icons.emoji_emotions_outlined),
    const RankData(nameKey: 'game.rank_7', descKey: 'game.rank_7_desc', minScore: 75, color: Colors.amber, icon: Icons.pets_outlined),
    const RankData(nameKey: 'game.rank_6', descKey: 'game.rank_6_desc', minScore: 60, color: Colors.teal, icon: Icons.cruelty_free),
    const RankData(nameKey: 'game.rank_5', descKey: 'game.rank_5_desc', minScore: 45, color: Colors.blueAccent, icon: Icons.rocket_launch_rounded),
    const RankData(nameKey: 'game.rank_4', descKey: 'game.rank_4_desc', minScore: 30, color: Colors.lightBlue, icon: Icons.sports_martial_arts),
    const RankData(nameKey: 'game.rank_3', descKey: 'game.rank_3_desc', minScore: 20, color: Colors.deepOrange, icon: Icons.thumb_up_alt_outlined),
    const RankData(nameKey: 'game.rank_2', descKey: 'game.rank_2_desc', minScore: 10, color: Colors.green, icon: Icons.emoji_people_outlined),
    const RankData(nameKey: 'game.rank_1', descKey: 'game.rank_1_desc', minScore: 0, color: Colors.grey, icon: IconsaxPlusLinear.star),
  ];

  static RankData getRank(int score) {
    for (var rank in ranks) {
      if (score >= rank.minScore) return rank;
    }
    return ranks.last;
  }
}

class RanksInfoScreen extends StatefulWidget {
  const RanksInfoScreen({super.key});

  @override
  State<RanksInfoScreen> createState() => _RanksInfoScreenState();
}

class _RanksInfoScreenState extends State<RanksInfoScreen> {
  late PageController _pageController;
  double _currentPage = 0.0;
  int _lastReportedPage = 0; 
  bool _isControllerInitialized = false;
  
  Set<String> _flippedRanks = {}; 
  bool _isLoaded = false; 

  final List<RankData> displayRanks = RankHelper.ranks.reversed.toList();

  bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600;

  @override
  void initState() {
    super.initState();
    _loadFlippedStates();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ініціалізуємо контролер тут, щоб мати доступ до MediaQuery для визначення планшету
    if (!_isControllerInitialized) {
      final tablet = isTablet(context);
      _pageController = PageController(
        viewportFraction: tablet ? 0.45 : 0.72, // На планшеті картка займає 45% ширини екрану
        initialPage: 0
      );
      _pageController.addListener(() {
        setState(() {
          _currentPage = _pageController.page ?? 0.0;
        });

        int newPage = _currentPage.round();
        if (newPage != _lastReportedPage) {
          HapticFeedback.lightImpact(); 
          _lastReportedPage = newPage;
        }
      });
      _isControllerInitialized = true;
    }
  }

  Future<void> _loadFlippedStates() async {
    final prefs = await SharedPreferences.getInstance();
    final flippedList = prefs.getStringList('flipped_ranks') ?? [];
    setState(() {
      _flippedRanks = flippedList.toSet();
      _isLoaded = true;
    });
  }

  void _markAsFlipped(String rankKey) async {
    if (!_flippedRanks.contains(rankKey)) {
      setState(() {
        _flippedRanks.add(rankKey);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('flipped_ranks', _flippedRanks.toList());
    }
  }

  @override
  void dispose() {
    if (_isControllerInitialized) _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) return const Scaffold(backgroundColor: AppColors.background, body: Center(child: CircularProgressIndicator()));

    final tablet = isTablet(context);
    Color ambientColor = displayRanks[_currentPage.round().clamp(0, displayRanks.length - 1)].color;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: Text('game.ranks_info'.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 24 : 20)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // ЕМБІЄНТ ФОН
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, 0.1), 
                radius: 1.5,
                colors: [
                  ambientColor.withAlpha(40), 
                  AppColors.background,       
                ],
              ),
            ),
          ),
          
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: tablet ? 600 : 480, // Адаптивна висота каруселі
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: displayRanks.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final rank = displayRanks[index];
                    
                    double scale = 1.0;
                    double blurRadius = 0.0;
                    double opacity = 0.3;
                    double verticalOffset = 0.0; 

                    if (_pageController.position.haveDimensions) {
                      double difference = (_currentPage - index).abs();
                      scale = (1 - (difference * 0.15)).clamp(0.85, 1.0);
                      blurRadius = (1 - difference).clamp(0.0, 1.0) * (tablet ? 45.0 : 35.0); 
                      opacity = (1 - difference).clamp(0.3, 1.0);
                      verticalOffset = (difference * (tablet ? 40.0 : 30.0)); 
                    } else if (index == 0) {
                      scale = 1.0;
                      blurRadius = tablet ? 45.0 : 35.0;
                      opacity = 1.0;
                      verticalOffset = 0.0;
                    }

                    bool isActive = scale == 1.0;
                    bool isInitiallyFlipped = _flippedRanks.contains(rank.nameKey);

                    return Transform.translate(
                      offset: Offset(0, verticalOffset), 
                      child: Transform.scale(
                        scale: scale,
                        child: RankFlipCard(
                          rank: rank,
                          isActive: isActive,
                          opacity: opacity,
                          blurRadius: blurRadius,
                          isInitiallyFlipped: isInitiallyFlipped,
                          isTablet: tablet, // Передаємо параметр планшету
                          onFlipped: () => _markAsFlipped(rank.nameKey),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: tablet ? 40 : 30),
              
              // ІНДИКАТОР ГОРТАННЯ
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(displayRanks.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage.round() == index ? (tablet ? 40 : 30) : (tablet ? 12 : 8),
                    height: tablet ? 12 : 8,
                    decoration: BoxDecoration(
                      color: _currentPage.round() == index 
                          ? displayRanks[index].color 
                          : Colors.grey.shade600.withAlpha(100),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: _currentPage.round() == index ? [
                        BoxShadow(color: displayRanks[index].color.withAlpha(150), blurRadius: 10)
                      ] : [],
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// 3D КАРТКА З ПЕРЕГОРТАННЯМ ТА ПУЛЬСАЦІЄЮ
// =====================================================================
class RankFlipCard extends StatefulWidget {
  final RankData rank;
  final bool isActive;
  final double opacity;
  final double blurRadius;
  final bool isInitiallyFlipped;
  final bool isTablet;
  final VoidCallback onFlipped;

  const RankFlipCard({
    super.key,
    required this.rank,
    required this.isActive,
    required this.opacity,
    required this.blurRadius,
    required this.isInitiallyFlipped,
    required this.isTablet,
    required this.onFlipped,
  });

  @override
  State<RankFlipCard> createState() => _RankFlipCardState();
}

class _RankFlipCardState extends State<RankFlipCard> with SingleTickerProviderStateMixin {
  late double _targetAngle;
  late double _initialAngle; 
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initialAngle = widget.isInitiallyFlipped ? pi : 0.0;
    _targetAngle = _initialAngle;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), 
    );
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine)
    );

    if (!widget.isInitiallyFlipped) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onCardTapped(TapUpDetails details, double cardWidth) {
    if (!widget.isActive) return; 

    bool isLeftTap = details.localPosition.dx < (cardWidth / 2);
    
    setState(() {
      if (_targetAngle == 0.0) {
        _targetAngle = isLeftTap ? -pi : pi;
        _pulseController.stop(); 
        widget.onFlipped(); 
      } else {
        _targetAngle = 0.0;
      }
    });
    
    HapticFeedback.mediumImpact(); 
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapUp: (details) => _onCardTapped(details, constraints.maxWidth),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: _initialAngle, end: _targetAngle),
            duration: const Duration(milliseconds: 600), 
            curve: Curves.easeOutBack, 
            builder: (context, angle, child) {
              
              bool isFrontShowing = angle.abs() >= (pi / 2);

              Widget content = isFrontShowing ? _buildFront(widget.rank) : _buildBack(widget.rank);

              if (isFrontShowing) {
                content = Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: content,
                );
              }

              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0015) 
                  ..rotateY(angle),        
                alignment: Alignment.center,
                child: _buildCardBase(content),
              );
            },
          ),
        );
      }
    );
  }

  // --- БАЗОВИЙ КОНТЕЙНЕР ---
  Widget _buildCardBase(Widget child) {
    final radius = widget.isTablet ? 50.0 : 35.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius), 
        border: Border.all(
          color: widget.rank.color.withAlpha((widget.opacity * 180).toInt()), 
          width: widget.isActive ? (widget.isTablet ? 3.5 : 2.5) : 1.0
        ),
        boxShadow: [
          BoxShadow(
            color: widget.rank.color.withAlpha((widget.opacity * 120).toInt()),
            blurRadius: widget.blurRadius,
            spreadRadius: widget.isActive ? (widget.isTablet ? 12 : 8) : 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withAlpha(widget.isActive ? 220 : 150),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // --- СПИНА КАРТКИ З ПУЛЬСАЦІЄЮ ---
  Widget _buildBack(RankData rank) {
    return Center(
      child: ScaleTransition(
        scale: _pulseAnimation,
        child: Container(
          padding: EdgeInsets.all(widget.isTablet ? 60 : 40),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: rank.color.withAlpha(100), blurRadius: widget.isTablet ? 60 : 40, spreadRadius: widget.isTablet ? 15 : 10)
            ],
            gradient: RadialGradient(
              colors: [rank.color.withAlpha(150), rank.color.withAlpha(0)],
            ),
          ),
          child: Icon(rank.icon, color: rank.color, size: widget.isTablet ? 140 : 100),
        ),
      ),
    );
  }

  // --- ЛИЦЕ КАРТКИ ---
  Widget _buildFront(RankData rank) {
    return Padding(
      padding: EdgeInsets.all(widget.isTablet ? 32 : 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(widget.isTablet ? 28 : 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  rank.color.withAlpha(widget.isActive ? 100 : 30),
                  rank.color.withAlpha(widget.isActive ? 20 : 10),
                ]
              ),
              shape: BoxShape.circle,
              boxShadow: widget.isActive ? [
                BoxShadow(color: rank.color.withAlpha(50), blurRadius: 20, spreadRadius: 5)
              ] : [],
            ),
            child: Icon(rank.icon, color: rank.color, size: widget.isTablet ? 70 : 50),
          ),
          SizedBox(height: widget.isTablet ? 32 : 24),
          Text(
            rank.nameKey.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: widget.isTablet ? 36 : 28, 
              fontWeight: FontWeight.w900, 
              color: rank.color,
              shadows: [Shadow(color: rank.color.withAlpha(100), blurRadius: 10, offset: const Offset(0, 2))]
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: widget.isTablet ? 24 : 16, vertical: widget.isTablet ? 12 : 8),
            decoration: BoxDecoration(
              color: AppColors.background.withAlpha(200),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: rank.color.withAlpha(50)),
            ),
            child: Text(
              rank.minScore == 120 ? '120+ очок' : '${rank.minScore} - ${rank.minScore + 14} очок',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.isTablet ? 20 : 16, color: rank.color.withAlpha(200)),
            ),
          ),
          SizedBox(height: widget.isTablet ? 32 : 24),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                rank.descKey.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: widget.isTablet ? 18 : 15, 
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary.withAlpha((widget.opacity * 255).toInt()), 
                  height: 1.5
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}