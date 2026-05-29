// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExtraItemRecord _$ExtraItemRecordFromJson(Map<String, dynamic> json) {
  return _ExtraItemRecord.fromJson(json);
}

/// @nodoc
mixin _$ExtraItemRecord {
  String get foodName =>
      throw _privateConstructorUsedError; // Укр. назва з бази (ключ для локалізації)
  double get weight =>
      throw _privateConstructorUsedError; // Вага або об'єм (г/мл)
  int get calories => throw _privateConstructorUsedError;

  /// Serializes this ExtraItemRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExtraItemRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExtraItemRecordCopyWith<ExtraItemRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExtraItemRecordCopyWith<$Res> {
  factory $ExtraItemRecordCopyWith(
    ExtraItemRecord value,
    $Res Function(ExtraItemRecord) then,
  ) = _$ExtraItemRecordCopyWithImpl<$Res, ExtraItemRecord>;
  @useResult
  $Res call({String foodName, double weight, int calories});
}

/// @nodoc
class _$ExtraItemRecordCopyWithImpl<$Res, $Val extends ExtraItemRecord>
    implements $ExtraItemRecordCopyWith<$Res> {
  _$ExtraItemRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExtraItemRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodName = null,
    Object? weight = null,
    Object? calories = null,
  }) {
    return _then(
      _value.copyWith(
            foodName: null == foodName
                ? _value.foodName
                : foodName // ignore: cast_nullable_to_non_nullable
                      as String,
            weight: null == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double,
            calories: null == calories
                ? _value.calories
                : calories // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExtraItemRecordImplCopyWith<$Res>
    implements $ExtraItemRecordCopyWith<$Res> {
  factory _$$ExtraItemRecordImplCopyWith(
    _$ExtraItemRecordImpl value,
    $Res Function(_$ExtraItemRecordImpl) then,
  ) = __$$ExtraItemRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String foodName, double weight, int calories});
}

/// @nodoc
class __$$ExtraItemRecordImplCopyWithImpl<$Res>
    extends _$ExtraItemRecordCopyWithImpl<$Res, _$ExtraItemRecordImpl>
    implements _$$ExtraItemRecordImplCopyWith<$Res> {
  __$$ExtraItemRecordImplCopyWithImpl(
    _$ExtraItemRecordImpl _value,
    $Res Function(_$ExtraItemRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExtraItemRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodName = null,
    Object? weight = null,
    Object? calories = null,
  }) {
    return _then(
      _$ExtraItemRecordImpl(
        foodName: null == foodName
            ? _value.foodName
            : foodName // ignore: cast_nullable_to_non_nullable
                  as String,
        weight: null == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double,
        calories: null == calories
            ? _value.calories
            : calories // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExtraItemRecordImpl implements _ExtraItemRecord {
  const _$ExtraItemRecordImpl({
    required this.foodName,
    required this.weight,
    required this.calories,
  });

  factory _$ExtraItemRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExtraItemRecordImplFromJson(json);

  @override
  final String foodName;
  // Укр. назва з бази (ключ для локалізації)
  @override
  final double weight;
  // Вага або об'єм (г/мл)
  @override
  final int calories;

  @override
  String toString() {
    return 'ExtraItemRecord(foodName: $foodName, weight: $weight, calories: $calories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExtraItemRecordImpl &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.calories, calories) ||
                other.calories == calories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, foodName, weight, calories);

  /// Create a copy of ExtraItemRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExtraItemRecordImplCopyWith<_$ExtraItemRecordImpl> get copyWith =>
      __$$ExtraItemRecordImplCopyWithImpl<_$ExtraItemRecordImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExtraItemRecordImplToJson(this);
  }
}

abstract class _ExtraItemRecord implements ExtraItemRecord {
  const factory _ExtraItemRecord({
    required final String foodName,
    required final double weight,
    required final int calories,
  }) = _$ExtraItemRecordImpl;

  factory _ExtraItemRecord.fromJson(Map<String, dynamic> json) =
      _$ExtraItemRecordImpl.fromJson;

  @override
  String get foodName; // Укр. назва з бази (ключ для локалізації)
  @override
  double get weight; // Вага або об'єм (г/мл)
  @override
  int get calories;

  /// Create a copy of ExtraItemRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExtraItemRecordImplCopyWith<_$ExtraItemRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MealRecordModel _$MealRecordModelFromJson(Map<String, dynamic> json) {
  return _MealRecordModel.fromJson(json);
}

/// @nodoc
mixin _$MealRecordModel {
  int? get id => throw _privateConstructorUsedError;
  String get foodName =>
      throw _privateConstructorUsedError; // Тільки назва основної страви
  int get calories =>
      throw _privateConstructorUsedError; // Загальні калорії (страва + добавки + напої)
  double get proteins => throw _privateConstructorUsedError; // Загальні білки
  double get fats => throw _privateConstructorUsedError; // Загальні жири
  double get carbs => throw _privateConstructorUsedError; // Загальні вуглеводи
  DateTime get date => throw _privateConstructorUsedError;
  MealType get mealType =>
      throw _privateConstructorUsedError; // Списки добавок та напоїв (за замовчуванням порожні, щоб не зламати старі дані)
  List<ExtraItemRecord> get addons => throw _privateConstructorUsedError;
  List<ExtraItemRecord> get drinks => throw _privateConstructorUsedError;

  /// Serializes this MealRecordModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealRecordModelCopyWith<MealRecordModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealRecordModelCopyWith<$Res> {
  factory $MealRecordModelCopyWith(
    MealRecordModel value,
    $Res Function(MealRecordModel) then,
  ) = _$MealRecordModelCopyWithImpl<$Res, MealRecordModel>;
  @useResult
  $Res call({
    int? id,
    String foodName,
    int calories,
    double proteins,
    double fats,
    double carbs,
    DateTime date,
    MealType mealType,
    List<ExtraItemRecord> addons,
    List<ExtraItemRecord> drinks,
  });
}

/// @nodoc
class _$MealRecordModelCopyWithImpl<$Res, $Val extends MealRecordModel>
    implements $MealRecordModelCopyWith<$Res> {
  _$MealRecordModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? foodName = null,
    Object? calories = null,
    Object? proteins = null,
    Object? fats = null,
    Object? carbs = null,
    Object? date = null,
    Object? mealType = null,
    Object? addons = null,
    Object? drinks = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            foodName: null == foodName
                ? _value.foodName
                : foodName // ignore: cast_nullable_to_non_nullable
                      as String,
            calories: null == calories
                ? _value.calories
                : calories // ignore: cast_nullable_to_non_nullable
                      as int,
            proteins: null == proteins
                ? _value.proteins
                : proteins // ignore: cast_nullable_to_non_nullable
                      as double,
            fats: null == fats
                ? _value.fats
                : fats // ignore: cast_nullable_to_non_nullable
                      as double,
            carbs: null == carbs
                ? _value.carbs
                : carbs // ignore: cast_nullable_to_non_nullable
                      as double,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            mealType: null == mealType
                ? _value.mealType
                : mealType // ignore: cast_nullable_to_non_nullable
                      as MealType,
            addons: null == addons
                ? _value.addons
                : addons // ignore: cast_nullable_to_non_nullable
                      as List<ExtraItemRecord>,
            drinks: null == drinks
                ? _value.drinks
                : drinks // ignore: cast_nullable_to_non_nullable
                      as List<ExtraItemRecord>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MealRecordModelImplCopyWith<$Res>
    implements $MealRecordModelCopyWith<$Res> {
  factory _$$MealRecordModelImplCopyWith(
    _$MealRecordModelImpl value,
    $Res Function(_$MealRecordModelImpl) then,
  ) = __$$MealRecordModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String foodName,
    int calories,
    double proteins,
    double fats,
    double carbs,
    DateTime date,
    MealType mealType,
    List<ExtraItemRecord> addons,
    List<ExtraItemRecord> drinks,
  });
}

/// @nodoc
class __$$MealRecordModelImplCopyWithImpl<$Res>
    extends _$MealRecordModelCopyWithImpl<$Res, _$MealRecordModelImpl>
    implements _$$MealRecordModelImplCopyWith<$Res> {
  __$$MealRecordModelImplCopyWithImpl(
    _$MealRecordModelImpl _value,
    $Res Function(_$MealRecordModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MealRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? foodName = null,
    Object? calories = null,
    Object? proteins = null,
    Object? fats = null,
    Object? carbs = null,
    Object? date = null,
    Object? mealType = null,
    Object? addons = null,
    Object? drinks = null,
  }) {
    return _then(
      _$MealRecordModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        foodName: null == foodName
            ? _value.foodName
            : foodName // ignore: cast_nullable_to_non_nullable
                  as String,
        calories: null == calories
            ? _value.calories
            : calories // ignore: cast_nullable_to_non_nullable
                  as int,
        proteins: null == proteins
            ? _value.proteins
            : proteins // ignore: cast_nullable_to_non_nullable
                  as double,
        fats: null == fats
            ? _value.fats
            : fats // ignore: cast_nullable_to_non_nullable
                  as double,
        carbs: null == carbs
            ? _value.carbs
            : carbs // ignore: cast_nullable_to_non_nullable
                  as double,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        mealType: null == mealType
            ? _value.mealType
            : mealType // ignore: cast_nullable_to_non_nullable
                  as MealType,
        addons: null == addons
            ? _value._addons
            : addons // ignore: cast_nullable_to_non_nullable
                  as List<ExtraItemRecord>,
        drinks: null == drinks
            ? _value._drinks
            : drinks // ignore: cast_nullable_to_non_nullable
                  as List<ExtraItemRecord>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MealRecordModelImpl implements _MealRecordModel {
  const _$MealRecordModelImpl({
    this.id,
    required this.foodName,
    required this.calories,
    required this.proteins,
    required this.fats,
    required this.carbs,
    required this.date,
    required this.mealType,
    final List<ExtraItemRecord> addons = const [],
    final List<ExtraItemRecord> drinks = const [],
  }) : _addons = addons,
       _drinks = drinks;

  factory _$MealRecordModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealRecordModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String foodName;
  // Тільки назва основної страви
  @override
  final int calories;
  // Загальні калорії (страва + добавки + напої)
  @override
  final double proteins;
  // Загальні білки
  @override
  final double fats;
  // Загальні жири
  @override
  final double carbs;
  // Загальні вуглеводи
  @override
  final DateTime date;
  @override
  final MealType mealType;
  // Списки добавок та напоїв (за замовчуванням порожні, щоб не зламати старі дані)
  final List<ExtraItemRecord> _addons;
  // Списки добавок та напоїв (за замовчуванням порожні, щоб не зламати старі дані)
  @override
  @JsonKey()
  List<ExtraItemRecord> get addons {
    if (_addons is EqualUnmodifiableListView) return _addons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addons);
  }

  final List<ExtraItemRecord> _drinks;
  @override
  @JsonKey()
  List<ExtraItemRecord> get drinks {
    if (_drinks is EqualUnmodifiableListView) return _drinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_drinks);
  }

  @override
  String toString() {
    return 'MealRecordModel(id: $id, foodName: $foodName, calories: $calories, proteins: $proteins, fats: $fats, carbs: $carbs, date: $date, mealType: $mealType, addons: $addons, drinks: $drinks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealRecordModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.proteins, proteins) ||
                other.proteins == proteins) &&
            (identical(other.fats, fats) || other.fats == fats) &&
            (identical(other.carbs, carbs) || other.carbs == carbs) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            const DeepCollectionEquality().equals(other._addons, _addons) &&
            const DeepCollectionEquality().equals(other._drinks, _drinks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    foodName,
    calories,
    proteins,
    fats,
    carbs,
    date,
    mealType,
    const DeepCollectionEquality().hash(_addons),
    const DeepCollectionEquality().hash(_drinks),
  );

  /// Create a copy of MealRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealRecordModelImplCopyWith<_$MealRecordModelImpl> get copyWith =>
      __$$MealRecordModelImplCopyWithImpl<_$MealRecordModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MealRecordModelImplToJson(this);
  }
}

abstract class _MealRecordModel implements MealRecordModel {
  const factory _MealRecordModel({
    final int? id,
    required final String foodName,
    required final int calories,
    required final double proteins,
    required final double fats,
    required final double carbs,
    required final DateTime date,
    required final MealType mealType,
    final List<ExtraItemRecord> addons,
    final List<ExtraItemRecord> drinks,
  }) = _$MealRecordModelImpl;

  factory _MealRecordModel.fromJson(Map<String, dynamic> json) =
      _$MealRecordModelImpl.fromJson;

  @override
  int? get id;
  @override
  String get foodName; // Тільки назва основної страви
  @override
  int get calories; // Загальні калорії (страва + добавки + напої)
  @override
  double get proteins; // Загальні білки
  @override
  double get fats; // Загальні жири
  @override
  double get carbs; // Загальні вуглеводи
  @override
  DateTime get date;
  @override
  MealType get mealType; // Списки добавок та напоїв (за замовчуванням порожні, щоб не зламати старі дані)
  @override
  List<ExtraItemRecord> get addons;
  @override
  List<ExtraItemRecord> get drinks;

  /// Create a copy of MealRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealRecordModelImplCopyWith<_$MealRecordModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
