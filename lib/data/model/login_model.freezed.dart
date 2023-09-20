// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LogInReqModel _$LogInReqModelFromJson(Map<String, dynamic> json) {
  return _LogInReqModel.fromJson(json);
}

/// @nodoc
mixin _$LogInReqModel {
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'email')
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'password')
  String? get password => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LogInReqModelCopyWith<LogInReqModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogInReqModelCopyWith<$Res> {
  factory $LogInReqModelCopyWith(
          LogInReqModel value, $Res Function(LogInReqModel) then) =
      _$LogInReqModelCopyWithImpl<$Res, LogInReqModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'password') String? password});
}

/// @nodoc
class _$LogInReqModelCopyWithImpl<$Res, $Val extends LogInReqModel>
    implements $LogInReqModelCopyWith<$Res> {
  _$LogInReqModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? email = freezed,
    Object? password = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LogInReqModelCopyWith<$Res>
    implements $LogInReqModelCopyWith<$Res> {
  factory _$$_LogInReqModelCopyWith(
          _$_LogInReqModel value, $Res Function(_$_LogInReqModel) then) =
      __$$_LogInReqModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'password') String? password});
}

/// @nodoc
class __$$_LogInReqModelCopyWithImpl<$Res>
    extends _$LogInReqModelCopyWithImpl<$Res, _$_LogInReqModel>
    implements _$$_LogInReqModelCopyWith<$Res> {
  __$$_LogInReqModelCopyWithImpl(
      _$_LogInReqModel _value, $Res Function(_$_LogInReqModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? email = freezed,
    Object? password = freezed,
  }) {
    return _then(_$_LogInReqModel(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _$_LogInReqModel implements _LogInReqModel {
  const _$_LogInReqModel(
      {@JsonKey(name: 'name') this.name,
      @JsonKey(name: 'email') this.email,
      @JsonKey(name: 'password') this.password});

  factory _$_LogInReqModel.fromJson(Map<String, dynamic> json) =>
      _$$_LogInReqModelFromJson(json);

  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'email')
  final String? email;
  @override
  @JsonKey(name: 'password')
  final String? password;

  @override
  String toString() {
    return 'LogInReqModel(name: $name, email: $email, password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LogInReqModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, email, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LogInReqModelCopyWith<_$_LogInReqModel> get copyWith =>
      __$$_LogInReqModelCopyWithImpl<_$_LogInReqModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LogInReqModelToJson(
      this,
    );
  }
}

abstract class _LogInReqModel implements LogInReqModel {
  const factory _LogInReqModel(
      {@JsonKey(name: 'name') final String? name,
      @JsonKey(name: 'email') final String? email,
      @JsonKey(name: 'password') final String? password}) = _$_LogInReqModel;

  factory _LogInReqModel.fromJson(Map<String, dynamic> json) =
      _$_LogInReqModel.fromJson;

  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'email')
  String? get email;
  @override
  @JsonKey(name: 'password')
  String? get password;
  @override
  @JsonKey(ignore: true)
  _$$_LogInReqModelCopyWith<_$_LogInReqModel> get copyWith =>
      throw _privateConstructorUsedError;
}
