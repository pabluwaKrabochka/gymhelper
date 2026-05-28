import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gymhelper/features/minigame/screens/leaderboard_screen.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../core/constants/color_constants.dart';
import '../presentation/game_cubit.dart';
import '../presentation/game_state.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCubit(),
      child: const GameView(),
    );
  }
}

class GameView extends StatelessWidget {
  const GameView({super.key});

  // Допоміжна функція для визначення розміру екрану
  bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600;

  void _showGameOverDialog(BuildContext context, int score) {
    final cubit = context.read<GameCubit>();
    final tablet = isTablet(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text('game.game_over'.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 24 : 20))),
            IconButton(
              icon: Icon(Icons.close, color: Colors.grey, size: tablet ? 32 : 24),
              onPressed: () {
                Navigator.pop(dialogContext);
                cubit.exitGame();
              },
            ),
          ],
        ),
        content: Text(
          'game.final_score'.tr(namedArgs: {'score': score.toString()}),
          style: TextStyle(fontSize: tablet ? 22 : 18),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: tablet ? 30 : 20, vertical: tablet ? 16 : 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.startGame();
            },
            child: Text('game.play_again'.tr(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: tablet ? 18 : 16)),
          ),
        ],
      ),
    );
  }

  void _showPauseDialog(BuildContext context) {
    final cubit = context.read<GameCubit>();
    final tablet = isTablet(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('game.pause'.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 24 : 20)),
            IconButton(
              icon: Icon(Icons.close, color: Colors.grey, size: tablet ? 32 : 24),
              onPressed: () {
                Navigator.pop(dialogContext);
                cubit.togglePause(); 
              },
            ),
          ],
        ),
        content: const SizedBox(height: 10), 
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.exitGame(); 
            },
            child: Text('game.exit'.tr(), style: TextStyle(color: Colors.red, fontSize: tablet ? 20 : 16)),
          ),
          SizedBox(width: tablet ? 24 : 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: tablet ? 30 : 20, vertical: tablet ? 16 : 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.togglePause();
            },
            child: Text('game.resume'.tr(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: tablet ? 18 : 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);

    return BlocListener<GameCubit, GameState>(
      listenWhen: (previous, current) => !previous.isGameOver && current.isGameOver,
      listener: (context, state) {
        if (state.isGameOver) {
          _showGameOverDialog(context, state.score);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('game.title'.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: tablet ? 24 : 20)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.emoji_events_rounded, color: Colors.orange, size: tablet ? 36 : 28),
              onPressed: () {
                final cubit = context.read<GameCubit>();
                if (cubit.state.isPlaying && !cubit.state.isPaused) {
                  cubit.togglePause();
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
                );
              },
            ),
            SizedBox(width: tablet ? 16 : 8),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildInfoPanel(context, tablet),
              Expanded(
                child: BlocBuilder<GameCubit, GameState>(
                  builder: (context, state) {
                    if (state.isPlaying) {
                      return _buildActiveGameZone(context, state, tablet);
                    } else {
                      return _buildStartMenu(context, state, tablet);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPanel(BuildContext context, bool tablet) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        final screenWidth = MediaQuery.of(context).size.width;
        final horizontalPadding = tablet ? screenWidth * 0.1 : 24.0;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10.0),
          child: Container(
            padding: EdgeInsets.all(tablet ? 24 : 16),
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
                    Text('game.score'.tr(), style: TextStyle(color: Colors.white70, fontSize: tablet ? 18 : 14)),
                    Text('${state.score}', style: TextStyle(color: Colors.white, fontSize: tablet ? 36 : 28, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(IconsaxPlusLinear.timer_1, color: Colors.white.withAlpha(200), size: tablet ? 26 : 20),
                        if (state.isPlaying) ...[
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              context.read<GameCubit>().togglePause();
                              _showPauseDialog(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(tablet ? 8 : 4),
                              decoration: BoxDecoration(color: Colors.white.withAlpha(50), shape: BoxShape.circle),
                              child: Icon(Icons.pause, color: Colors.white, size: tablet ? 24 : 20),
                            ),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'game.time_left'.tr(namedArgs: {'time': state.timeLeft.toString()}),
                      style: TextStyle(
                        color: state.timeLeft <= 5 && state.isPlaying ? Colors.red.shade200 : Colors.white,
                        fontSize: tablet ? 24 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStartMenu(BuildContext context, GameState state, bool tablet) {
    final cubit = context.read<GameCubit>();
    final maxWidth = tablet ? 500.0 : double.infinity;
    final fontSize = tablet ? 18.0 : 14.0; // Локальний розмір шрифту

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('game.select_time'.tr(), style: TextStyle(fontSize: tablet ? 20 : 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              SizedBox(
                width: maxWidth,
                child: SegmentedButton<int>(
                  style: SegmentedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    selectedBackgroundColor: AppColors.primary,
                    selectedForegroundColor: Colors.white,
                    side: BorderSide.none,
                    padding: EdgeInsets.symmetric(vertical: tablet ? 16 : 8),
                  ),
                  segments: [
                    // ВАЖЛИВО: Шрифт задаємо тільки через style всередині Text, щоб не ламати кольори
                    ButtonSegment(value: 15, label: Text('game.sec_15'.tr(), style: TextStyle(fontSize: fontSize))),
                    ButtonSegment(value: 30, label: Text('game.sec_30'.tr(), style: TextStyle(fontSize: fontSize))),
                    ButtonSegment(value: 60, label: Text('game.sec_60'.tr(), style: TextStyle(fontSize: fontSize))),
                  ],
                  selected: {state.selectedDuration},
                  onSelectionChanged: (Set<int> newSelection) {
                    cubit.selectDuration(newSelection.first);
                  },
                ),
              ),
              SizedBox(height: tablet ? 32 : 24),

              Text('game.difficulty'.tr(), style: TextStyle(fontSize: tablet ? 20 : 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              SizedBox(
                width: maxWidth,
                child: SegmentedButton<GameDifficulty>(
                  style: SegmentedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    selectedBackgroundColor: AppColors.primary,
                    selectedForegroundColor: Colors.white,
                    side: BorderSide.none,
                    padding: EdgeInsets.symmetric(vertical: tablet ? 16 : 8),
                  ),
                  segments: [
                    ButtonSegment(
                      value: GameDifficulty.easy, 
                      label: FittedBox(fit: BoxFit.scaleDown, child: Text('game.easy'.tr(), style: TextStyle(fontSize: fontSize))),
                    ),
                    ButtonSegment(
                      value: GameDifficulty.medium, 
                      label: FittedBox(fit: BoxFit.scaleDown, child: Text('game.medium'.tr(), style: TextStyle(fontSize: fontSize))),
                    ),
                    ButtonSegment(
                      value: GameDifficulty.hard, 
                      label: FittedBox(fit: BoxFit.scaleDown, child: Text('game.hard'.tr(), style: TextStyle(fontSize: fontSize))),
                    ),
                  ],
                  selected: {state.selectedDifficulty},
                  onSelectionChanged: (Set<GameDifficulty> newSelection) {
                    cubit.selectDifficulty(newSelection.first);
                  },
                ),
              ),
              SizedBox(height: tablet ? 50 : 40),

              SizedBox(
                width: tablet ? 300 : null,
                child: ElevatedButton(
                  onPressed: () => cubit.startGame(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: tablet ? 20 : 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('game.start'.tr(), style: TextStyle(fontSize: tablet ? 24 : 20, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveGameZone(BuildContext context, GameState state, bool tablet) {
    final cubit = context.read<GameCubit>();
    
    final targetSize = tablet ? 60.0 : 40.0;
    final hitboxSize = tablet ? 120.0 : 80.0;
    final iconSize = tablet ? 36.0 : 24.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            AnimatedPositioned(
              duration: Duration.zero, 
              left: state.targetX * constraints.maxWidth - (hitboxSize / 2),
              top: state.targetY * constraints.maxHeight - (hitboxSize / 2),
              child: state.isPaused 
                ? const SizedBox.shrink() 
                : GestureDetector(
                  onTap: () => cubit.onTargetTapped(),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: hitboxSize,
                    height: hitboxSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: targetSize,
                          height: targetSize,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.orange.withAlpha(100), blurRadius: 10, spreadRadius: 5)],
                          ),
                          child: Icon(Icons.bolt_rounded, color: Colors.white, size: iconSize),
                        ),
                        TweenAnimationBuilder<double>(
                          key: ValueKey('${state.targetX}_${state.targetY}'),
                          tween: Tween<double>(begin: hitboxSize, end: targetSize),
                          duration: Duration(milliseconds: state.currentDelayMs),
                          builder: (context, size, child) {
                            return Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.orange.withAlpha(150), width: tablet ? 4 : 3),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ),
          ],
        );
      },
    );
  }
}