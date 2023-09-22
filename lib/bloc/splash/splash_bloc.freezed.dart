// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'splash_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SplashEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() splashLoaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? splashLoaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? splashLoaded,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SplashLoadedEvent value) splashLoaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SplashLoadedEvent value)? splashLoaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SplashLoadedEvent value)? splashLoaded,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplashEventCopyWith<$Res> {
  factory $SplashEventCopyWith(
          SplashEvent value, $Res Function(SplashEvent) then) =
      _$SplashEventCopyWithImpl<$Res, SplashEvent>;
}

/// @nodoc
class _$SplashEventCopyWithImpl<$Res, $Val extends SplashEvent>
    implements $SplashEventCopyWith<$Res> {
  _$SplashEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_SplashLoadedEventCopyWith<$Res> {
  factory _$$_SplashLoadedEventCopyWith(_$_SplashLoadedEvent value,
          $Res Function(_$_SplashLoadedEvent) then) =
      __$$_SplashLoadedEventCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_SplashLoadedEventCopyWithImpl<$Res>
    extends _$SplashEventCopyWithImpl<$Res, _$_SplashLoadedEvent>
    implements _$$_SplashLoadedEventCopyWith<$Res> {
  __$$_SplashLoadedEventCopyWithImpl(
      _$_SplashLoadedEvent _value, $Res Function(_$_SplashLoadedEvent) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_SplashLoadedEvent implements _SplashLoadedEvent {
  _$_SplashLoadedEvent();

  @override
  String toString() {
    return 'SplashEvent.splashLoaded()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_SplashLoadedEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() splashLoaded,
  }) {
    return splashLoaded();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? splashLoaded,
  }) {
    return splashLoaded?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? splashLoaded,
    required TResult orElse(),
  }) {
    if (splashLoaded != null) {
      return splashLoaded();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SplashLoadedEvent value) splashLoaded,
  }) {
    return splashLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SplashLoadedEvent value)? splashLoaded,
  }) {
    return splashLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SplashLoadedEvent value)? splashLoaded,
    required TResult orElse(),
  }) {
    if (splashLoaded != null) {
      return splashLoaded(this);
    }
    return orElse();
  }
}

abstract class _SplashLoadedEvent implements SplashEvent {
  factory _SplashLoadedEvent() = _$_SplashLoadedEvent;
}

/// @nodoc
mixin _$SplashState {
  bool get isRedirected => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SplashStateCopyWith<SplashState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplashStateCopyWith<$Res> {
  factory $SplashStateCopyWith(
          SplashState value, $Res Function(SplashState) then) =
      _$SplashStateCopyWithImpl<$Res, SplashState>;
  @useResult
  $Res call({bool isRedirected});
}

/// @nodoc
class _$SplashStateCopyWithImpl<$Res, $Val extends SplashState>
    implements $SplashStateCopyWith<$Res> {
  _$SplashStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRedirected = null,
  }) {
    return _then(_value.copyWith(
      isRedirected: null == isRedirected
          ? _value.isRedirected
          : isRedirected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SplashStateCopyWith<$Res>
    implements $SplashStateCopyWith<$Res> {
  factory _$$_SplashStateCopyWith(
          _$_SplashState value, $Res Function(_$_SplashState) then) =
      __$$_SplashStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isRedirected});
}

/// @nodoc
class __$$_SplashStateCopyWithImpl<$Res>
    extends _$SplashStateCopyWithImpl<$Res, _$_SplashState>
    implements _$$_SplashStateCopyWith<$Res> {
  __$$_SplashStateCopyWithImpl(
      _$_SplashState _value, $Res Function(_$_SplashState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRedirected = null,
  }) {
    return _then(_$_SplashState(
      isRedirected: null == isRedirected
          ? _value.isRedirected
          : isRedirected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_SplashState implements _SplashState {
  const _$_SplashState({required this.isRedirected});

  @override
  final bool isRedirected;

  @override
  String toString() {
    return 'SplashState(isRedirected: $isRedirected)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SplashState &&
            (identical(other.isRedirected, isRedirected) ||
                other.isRedirected == isRedirected));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isRedirected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SplashStateCopyWith<_$_SplashState> get copyWith =>
      __$$_SplashStateCopyWithImpl<_$_SplashState>(this, _$identity);
}

abstract class _SplashState implements SplashState {
  const factory _SplashState({required final bool isRedirected}) =
      _$_SplashState;

  @override
  bool get isRedirected;
  @override
  @JsonKey(ignore: true)
  _$$_SplashStateCopyWith<_$_SplashState> get copyWith =>
      throw _privateConstructorUsedError;
}
