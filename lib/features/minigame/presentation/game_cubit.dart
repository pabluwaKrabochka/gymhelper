import 'dart:async';
import 'dart:convert'; // Для JSON
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Збереження даних
import 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(const GameState());

  Timer? _gameTimer;
  Timer? _targetTimer;
  int _currentDelayMs = 800; 
  final Random _random = Random();

  void selectDuration(int duration) {
    if (!state.isPlaying) {
      emit(state.copyWith(selectedDuration: duration, timeLeft: duration));
    }
  }

  void selectDifficulty(GameDifficulty difficulty) {
    if (!state.isPlaying) {
      emit(state.copyWith(selectedDifficulty: difficulty));
    }
  }

  void startGame() {
    _gameTimer?.cancel();
    _targetTimer?.cancel();

    switch (state.selectedDifficulty) {
      case GameDifficulty.easy:
        _currentDelayMs = 1000;
        break;
      case GameDifficulty.medium:
        _currentDelayMs = 900;
        break;
      case GameDifficulty.hard:
        _currentDelayMs = 800;
        break;
    }
    
    emit(state.copyWith(
      score: 0,
      timeLeft: state.selectedDuration,
      isPlaying: true,
      isPaused: false,
      isGameOver: false,
      currentDelayMs: _currentDelayMs,
    ));

    _resetTimerAndMove();
    _startGameTimer();
  }

  void _startGameTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft > 0) {
        emit(state.copyWith(timeLeft: state.timeLeft - 1));
      } else {
        _gameOver();
      }
    });
  }

  void _performTargetMove() {
    if (!state.isPlaying || state.isPaused) return;
    
    emit(state.copyWith(
      targetX: 0.1 + _random.nextDouble() * 0.8,
      targetY: 0.1 + _random.nextDouble() * 0.7,
      currentDelayMs: _currentDelayMs, 
    ));
  }

  void _resetTimerAndMove() {
    _targetTimer?.cancel(); 
    if (!state.isPlaying || state.isPaused) return;

    _performTargetMove();

    _targetTimer = Timer(Duration(milliseconds: _currentDelayMs), () {
      _resetTimerAndMove();
    });
  }

  void onTargetTapped() {
    if (!state.isPlaying || state.isPaused) return;

    int minDelay = 0;
    int step = 0;

    switch (state.selectedDifficulty) {
      case GameDifficulty.easy:
        minDelay = 1000; 
        step = 20;
        break;
      case GameDifficulty.medium:
        minDelay = 850; 
        step = 20;
        break;
      case GameDifficulty.hard:
        minDelay = 700; 
        step = 20;
        break;
    }

    if (_currentDelayMs > minDelay) {
      _currentDelayMs -= step;
    }

    emit(state.copyWith(score: state.score + 1));
    _resetTimerAndMove(); 
  }

  void togglePause() {
    if (!state.isPlaying) return;

    if (state.isPaused) {
      emit(state.copyWith(isPaused: false));
      _startGameTimer();
      _resetTimerAndMove();
    } else {
      _gameTimer?.cancel();
      _targetTimer?.cancel();
      emit(state.copyWith(isPaused: true));
    }
  }

  void exitGame() {
    _gameTimer?.cancel();
    _targetTimer?.cancel();
    emit(state.copyWith(isPlaying: false, isPaused: false, score: 0, timeLeft: state.selectedDuration));
  }

  // --- ЛОГІКА ЗБЕРЕЖЕННЯ РЕЗУЛЬТАТУ ---
  void _gameOver() async {
    _gameTimer?.cancel();
    _targetTimer?.cancel();
    emit(state.copyWith(isPlaying: false, isGameOver: true));

    // Якщо гравець набрав хоча б 1 очко - зберігаємо
    if (state.score > 0) {
      final prefs = await SharedPreferences.getInstance();
      final scoresJson = prefs.getStringList('game_scores') ?? [];
      
      final newScore = {
        'score': state.score,
        'difficulty': state.selectedDifficulty.name,
        'date': DateTime.now().toIso8601String(),
      };
      
      scoresJson.add(jsonEncode(newScore));
      await prefs.setStringList('game_scores', scoresJson);
    }
  }

  @override
  Future<void> close() {
    _gameTimer?.cancel();
    _targetTimer?.cancel();
    return super.close();
  }
}