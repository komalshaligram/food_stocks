// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LogInEvent {
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, String email) buttonPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, String email)? buttonPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, String email)? buttonPressed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LogInButtonPressedEvent value) buttonPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LogInButtonPressedEvent value)? buttonPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LogInButtonPressedEvent value)? buttonPressed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LogInEventCopyWith<LogInEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogInEventCopyWith<$Res> {
  factory $LogInEventCopyWith(
          LogInEvent value, $Res Function(LogInEvent) then) =
      _$LogInEventCopyWithImpl<$Res, LogInEvent>;
  @useResult
  $Res call({String name, String email});
}

/// @nodoc
class _$LogInEventCopyWithImpl<$Res, $Val extends LogInEvent>
    implements $LogInEventCopyWith<$Res> {
  _$LogInEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LogInButtonPressedEventCopyWith<$Res>
    implements $LogInEventCopyWith<$Res> {
  factory _$$_LogInButtonPressedEventCopyWith(_$_LogInButtonPressedEvent value,
          $Res Function(_$_LogInButtonPressedEvent) then) =
      __$$_LogInButtonPressedEventCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String email});
}

/// @nodoc
class __$$_LogInButtonPressedEventCopyWithImpl<$Res>
    extends _$LogInEventCopyWithImpl<$Res, _$_LogInButtonPressedEvent>
    implements _$$_LogInButtonPressedEventCopyWith<$Res> {
  __$$_LogInButtonPressedEventCopyWithImpl(_$_LogInButtonPressedEvent _value,
      $Res Function(_$_LogInButtonPressedEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
  }) {
    return _then(_$_LogInButtonPressedEvent(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_LogInButtonPressedEvent implements _LogInButtonPressedEvent {
  _$_LogInButtonPressedEvent({required this.name, required this.email});

  @override
  final String name;
  @override
  final String email;

  @override
  String toString() {
    return 'LogInEvent.buttonPressed(name: $name, email: $email)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LogInButtonPressedEvent &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, email);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LogInButtonPressedEventCopyWith<_$_LogInButtonPressedEvent>
      get copyWith =>
          __$$_LogInButtonPressedEventCopyWithImpl<_$_LogInButtonPressedEvent>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, String email) buttonPressed,
  }) {
    return buttonPressed(name, email);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, String email)? buttonPressed,
  }) {
    return buttonPressed?.call(name, email);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, String email)? buttonPressed,
    required TResult orElse(),
  }) {
    if (buttonPressed != null) {
      return buttonPressed(name, email);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LogInButtonPressedEvent value) buttonPressed,
  }) {
    return buttonPressed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LogInButtonPressedEvent value)? buttonPressed,
  }) {
    return buttonPressed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LogInButtonPressedEvent value)? buttonPressed,
    required TResult orElse(),
  }) {
    if (buttonPressed != null) {
      return buttonPressed(this);
    }
    return orElse();
  }
}

abstract class _LogInButtonPressedEvent implements LogInEvent {
  factory _LogInButtonPressedEvent(
      {required final String name,
      required final String email}) = _$_LogInButtonPressedEvent;

  @override
  String get name;
  @override
  String get email;
  @override
  @JsonKey(ignore: true)
  _$$_LogInButtonPressedEventCopyWith<_$_LogInButtonPressedEvent>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LogInState {
  LogInReqModel get reqModel => throw _privateConstructorUsedError;
  LoginStatus get loginStatus => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LogInStateCopyWith<LogInState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogInStateCopyWith<$Res> {
  factory $LogInStateCopyWith(
          LogInState value, $Res Function(LogInState) then) =
      _$LogInStateCopyWithImpl<$Res, LogInState>;
  @useResult
  $Res call({LogInReqModel reqModel, LoginStatus loginStatus});

  $LogInReqModelCopyWith<$Res> get reqModel;
}

/// @nodoc
class _$LogInStateCopyWithImpl<$Res, $Val extends LogInState>
    implements $LogInStateCopyWith<$Res> {
  _$LogInStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reqModel = null,
    Object? loginStatus = null,
  }) {
    return _then(_value.copyWith(
      reqModel: null == reqModel
          ? _value.reqModel
          : reqModel // ignore: cast_nullable_to_non_nullable
              as LogInReqModel,
      loginStatus: null == loginStatus
          ? _value.loginStatus
          : loginStatus // ignore: cast_nullable_to_non_nullable
              as LoginStatus,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LogInReqModelCopyWith<$Res> get reqModel {
    return $LogInReqModelCopyWith<$Res>(_value.reqModel, (value) {
      return _then(_value.copyWith(reqModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LogInStateCopyWith<$Res>
    implements $LogInStateCopyWith<$Res> {
  factory _$$_LogInStateCopyWith(
          _$_LogInState value, $Res Function(_$_LogInState) then) =
      __$$_LogInStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LogInReqModel reqModel, LoginStatus loginStatus});

  @override
  $LogInReqModelCopyWith<$Res> get reqModel;
}

/// @nodoc
class __$$_LogInStateCopyWithImpl<$Res>
    extends _$LogInStateCopyWithImpl<$Res, _$_LogInState>
    implements _$$_LogInStateCopyWith<$Res> {
  __$$_LogInStateCopyWithImpl(
      _$_LogInState _value, $Res Function(_$_LogInState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reqModel = null,
    Object? loginStatus = null,
  }) {
    return _then(_$_LogInState(
      reqModel: null == reqModel
          ? _value.reqModel
          : reqModel // ignore: cast_nullable_to_non_nullable
              as LogInReqModel,
      loginStatus: null == loginStatus
          ? _value.loginStatus
          : loginStatus // ignore: cast_nullable_to_non_nullable
              as LoginStatus,
    ));
  }
}

/// @nodoc

class _$_LogInState implements _LogInState {
  const _$_LogInState({required this.reqModel, required this.loginStatus});

  @override
  final LogInReqModel reqModel;
  @override
  final LoginStatus loginStatus;

  @override
  String toString() {
    return 'LogInState(reqModel: $reqModel, loginStatus: $loginStatus)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LogInState &&
            (identical(other.reqModel, reqModel) ||
                other.reqModel == reqModel) &&
            (identical(other.loginStatus, loginStatus) ||
                other.loginStatus == loginStatus));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reqModel, loginStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LogInStateCopyWith<_$_LogInState> get copyWith =>
      __$$_LogInStateCopyWithImpl<_$_LogInState>(this, _$identity);
}

abstract class _LogInState implements LogInState {
  const factory _LogInState(
      {required final LogInReqModel reqModel,
      required final LoginStatus loginStatus}) = _$_LogInState;

  @override
  LogInReqModel get reqModel;
  @override
  LoginStatus get loginStatus;
  @override
  @JsonKey(ignore: true)
  _$$_LogInStateCopyWith<_$_LogInState> get copyWith =>
      throw _privateConstructorUsedError;
}
