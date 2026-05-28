import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state.freezed.dart';

// ДОДАНО: Перелічення складності
enum GameDifficulty { easy, medium, hard }

@freezed
class GameState with _$GameState {
  const factory GameState({
    @Default(0) int score,
    @Default(false) bool isPlaying,
    @Default(false) bool isPaused,
    @Default(30) int timeLeft,
    @Default(30) int selectedDuration,
    @Default(GameDifficulty.medium) GameDifficulty selectedDifficulty, // ДОДАНО
    @Default(0.5) double targetX,
    @Default(0.5) double targetY,
    @Default(false) bool isGameOver,
    @Default(800) int currentDelayMs,
  }) = _GameState;
}