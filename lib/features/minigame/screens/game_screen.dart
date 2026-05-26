import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconsax_plus/iconsax_plus.dart'; // ДОДАНО ІМПОРТ ІКОНОК
import '../../../../core/constants/color_constants.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _score = 0;
  bool _isPlaying = false;
  
  Timer? _gameTimer;   
  Timer? _targetTimer; 
  
  int _timeLeft = 30;
  int _selectedDuration = 30; 
  
  double _targetX = 0.5;
  double _targetY = 0.5;
  int _currentDelayMs = 1000; 
  
  final Random _random = Random();

  void _startGame() {
    _gameTimer?.cancel();
    _targetTimer?.cancel();
    
    setState(() {
      _score = 0;
      _timeLeft = _selectedDuration;
      _isPlaying = true;
      _currentDelayMs = 1000;
      _resetTimerAndMove(); 
    });

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _gameOver(); 
        }
      });
    });
  }

  void _performTargetMove() {
    if (!_isPlaying) return;
    setState(() {
      _targetX = 0.1 + _random.nextDouble() * 0.8;
      _targetY = 0.1 + _random.nextDouble() * 0.7;
    });
  }

  void _resetTimerAndMove() {
    _targetTimer?.cancel(); 
    if (!_isPlaying) return;
    
    _performTargetMove(); 
    
    _targetTimer = Timer(Duration(milliseconds: _currentDelayMs), () {
      _resetTimerAndMove(); 
    });
  }

  void _onTargetTapped() {
    if (!_isPlaying) return;

    setState(() {
      _score++;
      if (_currentDelayMs > 350) {
        _currentDelayMs -= 25; 
      }
    });
    _resetTimerAndMove(); 
  }

  void _gameOver() {
    _gameTimer?.cancel();
    _targetTimer?.cancel();
    
    setState(() {
      _isPlaying = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('game.game_over'.tr(), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          'game.final_score'.tr(namedArgs: {'score': _score.toString()}),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('game.play_again'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _targetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('game.title'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.premiumGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(76), blurRadius: 15, offset: const Offset(0, 8))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('game.score'.tr(), style: const TextStyle(color: Colors.white70, fontSize: 14)),
                        Text('$_score', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // ВИПРАВЛЕНО: Прибрали const та використали правильну іконку Iconsax
                        Icon(IconsaxPlusLinear.timer_1, color: Colors.white.withAlpha(200), size: 20),
                        const SizedBox(height: 4),
                        Text(
                          'game.time_left'.tr(namedArgs: {'time': _timeLeft.toString()}), 
                          style: TextStyle(
                            color: _timeLeft <= 5 && _isPlaying ? Colors.red.shade200 : Colors.white, 
                            fontSize: 18, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            Expanded(
              child: _isPlaying 
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 200), 
                            curve: Curves.easeOutBack,
                            left: _targetX * constraints.maxWidth - 35, 
                            top: _targetY * constraints.maxHeight - 35,
                            child: GestureDetector(
                              onTap: _onTargetTapped,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(color: Colors.orange.withAlpha(100), blurRadius: 10, spreadRadius: 5),
                                  ],
                                ),
                                child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 40),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('game.select_time'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const SizedBox(height: 16),
                        SegmentedButton<int>(
                          style: SegmentedButton.styleFrom(
                            backgroundColor: AppColors.surface,
                            selectedBackgroundColor: AppColors.primary,
                            selectedForegroundColor: Colors.white,
                            side: BorderSide.none,
                          ),
                          segments: [
                            ButtonSegment(value: 15, label: Text('game.sec_15'.tr())),
                            ButtonSegment(value: 30, label: Text('game.sec_30'.tr())),
                            ButtonSegment(value: 60, label: Text('game.sec_60'.tr())),
                          ],
                          selected: {_selectedDuration},
                          onSelectionChanged: (Set<int> newSelection) {
                            setState(() => _selectedDuration = newSelection.first);
                          },
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: _startGame,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text('game.start'.tr(), style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}