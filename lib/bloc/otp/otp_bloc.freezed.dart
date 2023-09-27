// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$OtpEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() setOtpTimer,
    required TResult Function() updateOtpTimer,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? setOtpTimer,
    TResult? Function()? updateOtpTimer,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? setOtpTimer,
    TResult Function()? updateOtpTimer,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SetOtpTimerEvent value) setOtpTimer,
    required TResult Function(_UpdateTimerEvent value) updateOtpTimer,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SetOtpTimerEvent value)? setOtpTimer,
    TResult? Function(_UpdateTimerEvent value)? updateOtpTimer,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SetOtpTimerEvent value)? setOtpTimer,
    TResult Function(_UpdateTimerEvent value)? updateOtpTimer,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpEventCopyWith<$Res> {
  factory $OtpEventCopyWith(OtpEvent value, $Res Function(OtpEvent) then) =
      _$OtpEventCopyWithImpl<$Res, OtpEvent>;
}

/// @nodoc
class _$OtpEventCopyWithImpl<$Res, $Val extends OtpEvent>
    implements $OtpEventCopyWith<$Res> {
  _$OtpEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_SetOtpTimerEventCopyWith<$Res> {
  factory _$$_SetOtpTimerEventCopyWith(
          _$_SetOtpTimerEvent value, $Res Function(_$_SetOtpTimerEvent) then) =
      __$$_SetOtpTimerEventCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_SetOtpTimerEventCopyWithImpl<$Res>
    extends _$OtpEventCopyWithImpl<$Res, _$_SetOtpTimerEvent>
    implements _$$_SetOtpTimerEventCopyWith<$Res> {
  __$$_SetOtpTimerEventCopyWithImpl(
      _$_SetOtpTimerEvent _value, $Res Function(_$_SetOtpTimerEvent) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_SetOtpTimerEvent implements _SetOtpTimerEvent {
  const _$_SetOtpTimerEvent();

  @override
  String toString() {
    return 'OtpEvent.setOtpTimer()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_SetOtpTimerEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() setOtpTimer,
    required TResult Function() updateOtpTimer,
  }) {
    return setOtpTimer();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? setOtpTimer,
    TResult? Function()? updateOtpTimer,
  }) {
    return setOtpTimer?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? setOtpTimer,
    TResult Function()? updateOtpTimer,
    required TResult orElse(),
  }) {
    if (setOtpTimer != null) {
      return setOtpTimer();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SetOtpTimerEvent value) setOtpTimer,
    required TResult Function(_UpdateTimerEvent value) updateOtpTimer,
  }) {
    return setOtpTimer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SetOtpTimerEvent value)? setOtpTimer,
    TResult? Function(_UpdateTimerEvent value)? updateOtpTimer,
  }) {
    return setOtpTimer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SetOtpTimerEvent value)? setOtpTimer,
    TResult Function(_UpdateTimerEvent value)? updateOtpTimer,
    required TResult orElse(),
  }) {
    if (setOtpTimer != null) {
      return setOtpTimer(this);
    }
    return orElse();
  }
}

abstract class _SetOtpTimerEvent implements OtpEvent {
  const factory _SetOtpTimerEvent() = _$_SetOtpTimerEvent;
}

/// @nodoc
abstract class _$$_UpdateTimerEventCopyWith<$Res> {
  factory _$$_UpdateTimerEventCopyWith(
          _$_UpdateTimerEvent value, $Res Function(_$_UpdateTimerEvent) then) =
      __$$_UpdateTimerEventCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_UpdateTimerEventCopyWithImpl<$Res>
    extends _$OtpEventCopyWithImpl<$Res, _$_UpdateTimerEvent>
    implements _$$_UpdateTimerEventCopyWith<$Res> {
  __$$_UpdateTimerEventCopyWithImpl(
      _$_UpdateTimerEvent _value, $Res Function(_$_UpdateTimerEvent) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_UpdateTimerEvent implements _UpdateTimerEvent {
  const _$_UpdateTimerEvent();

  @override
  String toString() {
    return 'OtpEvent.updateOtpTimer()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_UpdateTimerEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() setOtpTimer,
    required TResult Function() updateOtpTimer,
  }) {
    return updateOtpTimer();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? setOtpTimer,
    TResult? Function()? updateOtpTimer,
  }) {
    return updateOtpTimer?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? setOtpTimer,
    TResult Function()? updateOtpTimer,
    required TResult orElse(),
  }) {
    if (updateOtpTimer != null) {
      return updateOtpTimer();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SetOtpTimerEvent value) setOtpTimer,
    required TResult Function(_UpdateTimerEvent value) updateOtpTimer,
  }) {
    return updateOtpTimer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SetOtpTimerEvent value)? setOtpTimer,
    TResult? Function(_UpdateTimerEvent value)? updateOtpTimer,
  }) {
    return updateOtpTimer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SetOtpTimerEvent value)? setOtpTimer,
    TResult Function(_UpdateTimerEvent value)? updateOtpTimer,
    required TResult orElse(),
  }) {
    if (updateOtpTimer != null) {
      return updateOtpTimer(this);
    }
    return orElse();
  }
}

abstract class _UpdateTimerEvent implements OtpEvent {
  const factory _UpdateTimerEvent() = _$_UpdateTimerEvent;
}

/// @nodoc
mixin _$OtpState {
  bool get isOtpTimerVisible => throw _privateConstructorUsedError;
  int get otpTimer => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OtpStateCopyWith<OtpState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpStateCopyWith<$Res> {
  factory $OtpStateCopyWith(OtpState value, $Res Function(OtpState) then) =
      _$OtpStateCopyWithImpl<$Res, OtpState>;
  @useResult
  $Res call({bool isOtpTimerVisible, int otpTimer});
}

/// @nodoc
class _$OtpStateCopyWithImpl<$Res, $Val extends OtpState>
    implements $OtpStateCopyWith<$Res> {
  _$OtpStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOtpTimerVisible = null,
    Object? otpTimer = null,
  }) {
    return _then(_value.copyWith(
      isOtpTimerVisible: null == isOtpTimerVisible
          ? _value.isOtpTimerVisible
          : isOtpTimerVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      otpTimer: null == otpTimer
          ? _value.otpTimer
          : otpTimer // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res> implements $OtpStateCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isOtpTimerVisible, int otpTimer});
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$OtpStateCopyWithImpl<$Res, _$_Initial>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOtpTimerVisible = null,
    Object? otpTimer = null,
  }) {
    return _then(_$_Initial(
      isOtpTimerVisible: null == isOtpTimerVisible
          ? _value.isOtpTimerVisible
          : isOtpTimerVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      otpTimer: null == otpTimer
          ? _value.otpTimer
          : otpTimer // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial({required this.isOtpTimerVisible, required this.otpTimer});

  @override
  final bool isOtpTimerVisible;
  @override
  final int otpTimer;

  @override
  String toString() {
    return 'OtpState(isOtpTimerVisible: $isOtpTimerVisible, otpTimer: $otpTimer)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Initial &&
            (identical(other.isOtpTimerVisible, isOtpTimerVisible) ||
                other.isOtpTimerVisible == isOtpTimerVisible) &&
            (identical(other.otpTimer, otpTimer) ||
                other.otpTimer == otpTimer));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isOtpTimerVisible, otpTimer);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      __$$_InitialCopyWithImpl<_$_Initial>(this, _$identity);
}

abstract class _Initial implements OtpState {
  const factory _Initial(
      {required final bool isOtpTimerVisible,
      required final int otpTimer}) = _$_Initial;

  @override
  bool get isOtpTimerVisible;
  @override
  int get otpTimer;
  @override
  @JsonKey(ignore: true)
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      throw _privateConstructorUsedError;
}
