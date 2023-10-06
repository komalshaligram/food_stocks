// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HomeEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getPreferencesDataEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getPreferencesDataEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getPreferencesDataEvent,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_getPreferencesDataEvent value)
        getPreferencesDataEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeEventCopyWith<$Res> {
  factory $HomeEventCopyWith(HomeEvent value, $Res Function(HomeEvent) then) =
      _$HomeEventCopyWithImpl<$Res, HomeEvent>;
}

/// @nodoc
class _$HomeEventCopyWithImpl<$Res, $Val extends HomeEvent>
    implements $HomeEventCopyWith<$Res> {
  _$HomeEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_getPreferencesDataEventCopyWith<$Res> {
  factory _$$_getPreferencesDataEventCopyWith(_$_getPreferencesDataEvent value,
          $Res Function(_$_getPreferencesDataEvent) then) =
      __$$_getPreferencesDataEventCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_getPreferencesDataEventCopyWithImpl<$Res>
    extends _$HomeEventCopyWithImpl<$Res, _$_getPreferencesDataEvent>
    implements _$$_getPreferencesDataEventCopyWith<$Res> {
  __$$_getPreferencesDataEventCopyWithImpl(_$_getPreferencesDataEvent _value,
      $Res Function(_$_getPreferencesDataEvent) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_getPreferencesDataEvent implements _getPreferencesDataEvent {
  const _$_getPreferencesDataEvent();

  @override
  String toString() {
    return 'HomeEvent.getPreferencesDataEvent()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_getPreferencesDataEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getPreferencesDataEvent,
  }) {
    return getPreferencesDataEvent();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getPreferencesDataEvent,
  }) {
    return getPreferencesDataEvent?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getPreferencesDataEvent,
    required TResult orElse(),
  }) {
    if (getPreferencesDataEvent != null) {
      return getPreferencesDataEvent();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_getPreferencesDataEvent value)
        getPreferencesDataEvent,
  }) {
    return getPreferencesDataEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
  }) {
    return getPreferencesDataEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
    required TResult orElse(),
  }) {
    if (getPreferencesDataEvent != null) {
      return getPreferencesDataEvent(this);
    }
    return orElse();
  }
}

abstract class _getPreferencesDataEvent implements HomeEvent {
  const factory _getPreferencesDataEvent() = _$_getPreferencesDataEvent;
}

/// @nodoc
mixin _$HomeState {
  String get UserImageUrl => throw _privateConstructorUsedError;
  String get UserCompanyLogoUrl => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call({String UserImageUrl, String UserCompanyLogoUrl});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? UserImageUrl = null,
    Object? UserCompanyLogoUrl = null,
  }) {
    return _then(_value.copyWith(
      UserImageUrl: null == UserImageUrl
          ? _value.UserImageUrl
          : UserImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      UserCompanyLogoUrl: null == UserCompanyLogoUrl
          ? _value.UserCompanyLogoUrl
          : UserCompanyLogoUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$$_HomeStateCopyWith(
          _$_HomeState value, $Res Function(_$_HomeState) then) =
      __$$_HomeStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String UserImageUrl, String UserCompanyLogoUrl});
}

/// @nodoc
class __$$_HomeStateCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$_HomeState>
    implements _$$_HomeStateCopyWith<$Res> {
  __$$_HomeStateCopyWithImpl(
      _$_HomeState _value, $Res Function(_$_HomeState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? UserImageUrl = null,
    Object? UserCompanyLogoUrl = null,
  }) {
    return _then(_$_HomeState(
      UserImageUrl: null == UserImageUrl
          ? _value.UserImageUrl
          : UserImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      UserCompanyLogoUrl: null == UserCompanyLogoUrl
          ? _value.UserCompanyLogoUrl
          : UserCompanyLogoUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_HomeState implements _HomeState {
  const _$_HomeState(
      {required this.UserImageUrl, required this.UserCompanyLogoUrl});

  @override
  final String UserImageUrl;
  @override
  final String UserCompanyLogoUrl;

  @override
  String toString() {
    return 'HomeState(UserImageUrl: $UserImageUrl, UserCompanyLogoUrl: $UserCompanyLogoUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HomeState &&
            (identical(other.UserImageUrl, UserImageUrl) ||
                other.UserImageUrl == UserImageUrl) &&
            (identical(other.UserCompanyLogoUrl, UserCompanyLogoUrl) ||
                other.UserCompanyLogoUrl == UserCompanyLogoUrl));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, UserImageUrl, UserCompanyLogoUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_HomeStateCopyWith<_$_HomeState> get copyWith =>
      __$$_HomeStateCopyWithImpl<_$_HomeState>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState(
      {required final String UserImageUrl,
      required final String UserCompanyLogoUrl}) = _$_HomeState;

  @override
  String get UserImageUrl;
  @override
  String get UserCompanyLogoUrl;
  @override
  @JsonKey(ignore: true)
  _$$_HomeStateCopyWith<_$_HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}
