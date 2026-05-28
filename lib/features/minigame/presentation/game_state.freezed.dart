// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameState {
  int get score => throw _privateConstructorUsedError;
  bool get isPlaying => throw _privateConstructorUsedError;
  bool get isPaused => throw _privateConstructorUsedError;
  int get timeLeft => throw _privateConstructorUsedError;
  int get selectedDuration => throw _privateConstructorUsedError;
  GameDifficulty get selectedDifficulty =>
      throw _privateConstructorUsedError; // ДОДАНО
  double get targetX => throw _privateConstructorUsedError;
  double get targetY => throw _privateConstructorUsedError;
  bool get isGameOver => throw _privateConstructorUsedError;
  int get currentDelayMs => throw _privateConstructorUsedError;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call({
    int score,
    bool isPlaying,
    bool isPaused,
    int timeLeft,
    int selectedDuration,
    GameDifficulty selectedDifficulty,
    double targetX,
    double targetY,
    bool isGameOver,
    int currentDelayMs,
  });
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? isPlaying = null,
    Object? isPaused = null,
    Object? timeLeft = null,
    Object? selectedDuration = null,
    Object? selectedDifficulty = null,
    Object? targetX = null,
    Object? targetY = null,
    Object? isGameOver = null,
    Object? currentDelayMs = null,
  }) {
    return _then(
      _value.copyWith(
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int,
            isPlaying: null == isPlaying
                ? _value.isPlaying
                : isPlaying // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPaused: null == isPaused
                ? _value.isPaused
                : isPaused // ignore: cast_nullable_to_non_nullable
                      as bool,
            timeLeft: null == timeLeft
                ? _value.timeLeft
                : timeLeft // ignore: cast_nullable_to_non_nullable
                      as int,
            selectedDuration: null == selectedDuration
                ? _value.selectedDuration
                : selectedDuration // ignore: cast_nullable_to_non_nullable
                      as int,
            selectedDifficulty: null == selectedDifficulty
                ? _value.selectedDifficulty
                : selectedDifficulty // ignore: cast_nullable_to_non_nullable
                      as GameDifficulty,
            targetX: null == targetX
                ? _value.targetX
                : targetX // ignore: cast_nullable_to_non_nullable
                      as double,
            targetY: null == targetY
                ? _value.targetY
                : targetY // ignore: cast_nullable_to_non_nullable
                      as double,
            isGameOver: null == isGameOver
                ? _value.isGameOver
                : isGameOver // ignore: cast_nullable_to_non_nullable
                      as bool,
            currentDelayMs: null == currentDelayMs
                ? _value.currentDelayMs
                : currentDelayMs // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
    _$GameStateImpl value,
    $Res Function(_$GameStateImpl) then,
  ) = __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int score,
    bool isPlaying,
    bool isPaused,
    int timeLeft,
    int selectedDuration,
    GameDifficulty selectedDifficulty,
    double targetX,
    double targetY,
    bool isGameOver,
    int currentDelayMs,
  });
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
    _$GameStateImpl _value,
    $Res Function(_$GameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? isPlaying = null,
    Object? isPaused = null,
    Object? timeLeft = null,
    Object? selectedDuration = null,
    Object? selectedDifficulty = null,
    Object? targetX = null,
    Object? targetY = null,
    Object? isGameOver = null,
    Object? currentDelayMs = null,
  }) {
    return _then(
      _$GameStateImpl(
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int,
        isPlaying: null == isPlaying
            ? _value.isPlaying
            : isPlaying // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPaused: null == isPaused
            ? _value.isPaused
            : isPaused // ignore: cast_nullable_to_non_nullable
                  as bool,
        timeLeft: null == timeLeft
            ? _value.timeLeft
            : timeLeft // ignore: cast_nullable_to_non_nullable
                  as int,
        selectedDuration: null == selectedDuration
            ? _value.selectedDuration
            : selectedDuration // ignore: cast_nullable_to_non_nullable
                  as int,
        selectedDifficulty: null == selectedDifficulty
            ? _value.selectedDifficulty
            : selectedDifficulty // ignore: cast_nullable_to_non_nullable
                  as GameDifficulty,
        targetX: null == targetX
            ? _value.targetX
            : targetX // ignore: cast_nullable_to_non_nullable
                  as double,
        targetY: null == targetY
            ? _value.targetY
            : targetY // ignore: cast_nullable_to_non_nullable
                  as double,
        isGameOver: null == isGameOver
            ? _value.isGameOver
            : isGameOver // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentDelayMs: null == currentDelayMs
            ? _value.currentDelayMs
            : currentDelayMs // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$GameStateImpl implements _GameState {
  const _$GameStateImpl({
    this.score = 0,
    this.isPlaying = false,
    this.isPaused = false,
    this.timeLeft = 30,
    this.selectedDuration = 30,
    this.selectedDifficulty = GameDifficulty.medium,
    this.targetX = 0.5,
    this.targetY = 0.5,
    this.isGameOver = false,
    this.currentDelayMs = 800,
  });

  @override
  @JsonKey()
  final int score;
  @override
  @JsonKey()
  final bool isPlaying;
  @override
  @JsonKey()
  final bool isPaused;
  @override
  @JsonKey()
  final int timeLeft;
  @override
  @JsonKey()
  final int selectedDuration;
  @override
  @JsonKey()
  final GameDifficulty selectedDifficulty;
  // ДОДАНО
  @override
  @JsonKey()
  final double targetX;
  @override
  @JsonKey()
  final double targetY;
  @override
  @JsonKey()
  final bool isGameOver;
  @override
  @JsonKey()
  final int currentDelayMs;

  @override
  String toString() {
    return 'GameState(score: $score, isPlaying: $isPlaying, isPaused: $isPaused, timeLeft: $timeLeft, selectedDuration: $selectedDuration, selectedDifficulty: $selectedDifficulty, targetX: $targetX, targetY: $targetY, isGameOver: $isGameOver, currentDelayMs: $currentDelayMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying) &&
            (identical(other.isPaused, isPaused) ||
                other.isPaused == isPaused) &&
            (identical(other.timeLeft, timeLeft) ||
                other.timeLeft == timeLeft) &&
            (identical(other.selectedDuration, selectedDuration) ||
                other.selectedDuration == selectedDuration) &&
            (identical(other.selectedDifficulty, selectedDifficulty) ||
                other.selectedDifficulty == selectedDifficulty) &&
            (identical(other.targetX, targetX) || other.targetX == targetX) &&
            (identical(other.targetY, targetY) || other.targetY == targetY) &&
            (identical(other.isGameOver, isGameOver) ||
                other.isGameOver == isGameOver) &&
            (identical(other.currentDelayMs, currentDelayMs) ||
                other.currentDelayMs == currentDelayMs));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    score,
    isPlaying,
    isPaused,
    timeLeft,
    selectedDuration,
    selectedDifficulty,
    targetX,
    targetY,
    isGameOver,
    currentDelayMs,
  );

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);
}

abstract class _GameState implements GameState {
  const factory _GameState({
    final int score,
    final bool isPlaying,
    final bool isPaused,
    final int timeLeft,
    final int selectedDuration,
    final GameDifficulty selectedDifficulty,
    final double targetX,
    final double targetY,
    final bool isGameOver,
    final int currentDelayMs,
  }) = _$GameStateImpl;

  @override
  int get score;
  @override
  bool get isPlaying;
  @override
  bool get isPaused;
  @override
  int get timeLeft;
  @override
  int get selectedDuration;
  @override
  GameDifficulty get selectedDifficulty; // ДОДАНО
  @override
  double get targetX;
  @override
  double get targetY;
  @override
  bool get isGameOver;
  @override
  int get currentDelayMs;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
