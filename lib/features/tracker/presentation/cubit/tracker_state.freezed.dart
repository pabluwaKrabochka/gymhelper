// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracker_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TrackerState {
  DateTime get selectedDate => throw _privateConstructorUsedError;
  List<MealRecordModel> get meals => throw _privateConstructorUsedError;
  List<WeightRecordModel> get weightHistory =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  UserModel? get user =>
      throw _privateConstructorUsedError; // Зберігаємо тут дані користувача
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of TrackerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrackerStateCopyWith<TrackerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackerStateCopyWith<$Res> {
  factory $TrackerStateCopyWith(
    TrackerState value,
    $Res Function(TrackerState) then,
  ) = _$TrackerStateCopyWithImpl<$Res, TrackerState>;
  @useResult
  $Res call({
    DateTime selectedDate,
    List<MealRecordModel> meals,
    List<WeightRecordModel> weightHistory,
    bool isLoading,
    UserModel? user,
    String? errorMessage,
  });

  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$TrackerStateCopyWithImpl<$Res, $Val extends TrackerState>
    implements $TrackerStateCopyWith<$Res> {
  _$TrackerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrackerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedDate = null,
    Object? meals = null,
    Object? weightHistory = null,
    Object? isLoading = null,
    Object? user = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            selectedDate: null == selectedDate
                ? _value.selectedDate
                : selectedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            meals: null == meals
                ? _value.meals
                : meals // ignore: cast_nullable_to_non_nullable
                      as List<MealRecordModel>,
            weightHistory: null == weightHistory
                ? _value.weightHistory
                : weightHistory // ignore: cast_nullable_to_non_nullable
                      as List<WeightRecordModel>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel?,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of TrackerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TrackerStateImplCopyWith<$Res>
    implements $TrackerStateCopyWith<$Res> {
  factory _$$TrackerStateImplCopyWith(
    _$TrackerStateImpl value,
    $Res Function(_$TrackerStateImpl) then,
  ) = __$$TrackerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime selectedDate,
    List<MealRecordModel> meals,
    List<WeightRecordModel> weightHistory,
    bool isLoading,
    UserModel? user,
    String? errorMessage,
  });

  @override
  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$TrackerStateImplCopyWithImpl<$Res>
    extends _$TrackerStateCopyWithImpl<$Res, _$TrackerStateImpl>
    implements _$$TrackerStateImplCopyWith<$Res> {
  __$$TrackerStateImplCopyWithImpl(
    _$TrackerStateImpl _value,
    $Res Function(_$TrackerStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrackerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedDate = null,
    Object? meals = null,
    Object? weightHistory = null,
    Object? isLoading = null,
    Object? user = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$TrackerStateImpl(
        selectedDate: null == selectedDate
            ? _value.selectedDate
            : selectedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        meals: null == meals
            ? _value._meals
            : meals // ignore: cast_nullable_to_non_nullable
                  as List<MealRecordModel>,
        weightHistory: null == weightHistory
            ? _value._weightHistory
            : weightHistory // ignore: cast_nullable_to_non_nullable
                  as List<WeightRecordModel>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel?,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$TrackerStateImpl implements _TrackerState {
  const _$TrackerStateImpl({
    required this.selectedDate,
    final List<MealRecordModel> meals = const [],
    final List<WeightRecordModel> weightHistory = const [],
    this.isLoading = false,
    this.user,
    this.errorMessage,
  }) : _meals = meals,
       _weightHistory = weightHistory;

  @override
  final DateTime selectedDate;
  final List<MealRecordModel> _meals;
  @override
  @JsonKey()
  List<MealRecordModel> get meals {
    if (_meals is EqualUnmodifiableListView) return _meals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_meals);
  }

  final List<WeightRecordModel> _weightHistory;
  @override
  @JsonKey()
  List<WeightRecordModel> get weightHistory {
    if (_weightHistory is EqualUnmodifiableListView) return _weightHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weightHistory);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final UserModel? user;
  // Зберігаємо тут дані користувача
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'TrackerState(selectedDate: $selectedDate, meals: $meals, weightHistory: $weightHistory, isLoading: $isLoading, user: $user, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackerStateImpl &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            const DeepCollectionEquality().equals(other._meals, _meals) &&
            const DeepCollectionEquality().equals(
              other._weightHistory,
              _weightHistory,
            ) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    selectedDate,
    const DeepCollectionEquality().hash(_meals),
    const DeepCollectionEquality().hash(_weightHistory),
    isLoading,
    user,
    errorMessage,
  );

  /// Create a copy of TrackerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrackerStateImplCopyWith<_$TrackerStateImpl> get copyWith =>
      __$$TrackerStateImplCopyWithImpl<_$TrackerStateImpl>(this, _$identity);
}

abstract class _TrackerState implements TrackerState {
  const factory _TrackerState({
    required final DateTime selectedDate,
    final List<MealRecordModel> meals,
    final List<WeightRecordModel> weightHistory,
    final bool isLoading,
    final UserModel? user,
    final String? errorMessage,
  }) = _$TrackerStateImpl;

  @override
  DateTime get selectedDate;
  @override
  List<MealRecordModel> get meals;
  @override
  List<WeightRecordModel> get weightHistory;
  @override
  bool get isLoading;
  @override
  UserModel? get user; // Зберігаємо тут дані користувача
  @override
  String? get errorMessage;

  /// Create a copy of TrackerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrackerStateImplCopyWith<_$TrackerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
