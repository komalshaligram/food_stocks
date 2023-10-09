// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bottom_nav_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BottomNavEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index) changePage,
    required TResult Function() changeCartCount,
    required TResult Function() setNavigationCount,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index)? changePage,
    TResult? Function()? changeCartCount,
    TResult? Function()? setNavigationCount,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? changePage,
    TResult Function()? changeCartCount,
    TResult Function()? setNavigationCount,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_ChangeCartCountEvent value) changeCartCount,
    required TResult Function(_SetNavigationEvent value) setNavigationCount,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_ChangeCartCountEvent value)? changeCartCount,
    TResult? Function(_SetNavigationEvent value)? setNavigationCount,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_ChangeCartCountEvent value)? changeCartCount,
    TResult Function(_SetNavigationEvent value)? setNavigationCount,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BottomNavEventCopyWith<$Res> {
  factory $BottomNavEventCopyWith(
          BottomNavEvent value, $Res Function(BottomNavEvent) then) =
      _$BottomNavEventCopyWithImpl<$Res, BottomNavEvent>;
}

/// @nodoc
class _$BottomNavEventCopyWithImpl<$Res, $Val extends BottomNavEvent>
    implements $BottomNavEventCopyWith<$Res> {
  _$BottomNavEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_ChangePageEventCopyWith<$Res> {
  factory _$$_ChangePageEventCopyWith(
          _$_ChangePageEvent value, $Res Function(_$_ChangePageEvent) then) =
      __$$_ChangePageEventCopyWithImpl<$Res>;
  @useResult
  $Res call({int index});
}

/// @nodoc
class __$$_ChangePageEventCopyWithImpl<$Res>
    extends _$BottomNavEventCopyWithImpl<$Res, _$_ChangePageEvent>
    implements _$$_ChangePageEventCopyWith<$Res> {
  __$$_ChangePageEventCopyWithImpl(
      _$_ChangePageEvent _value, $Res Function(_$_ChangePageEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
  }) {
    return _then(_$_ChangePageEvent(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_ChangePageEvent implements _ChangePageEvent {
  _$_ChangePageEvent({required this.index});

  @override
  final int index;

  @override
  String toString() {
    return 'BottomNavEvent.changePage(index: $index)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChangePageEvent &&
            (identical(other.index, index) || other.index == index));
  }

  @override
  int get hashCode => Object.hash(runtimeType, index);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChangePageEventCopyWith<_$_ChangePageEvent> get copyWith =>
      __$$_ChangePageEventCopyWithImpl<_$_ChangePageEvent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index) changePage,
    required TResult Function() changeCartCount,
    required TResult Function() setNavigationCount,
  }) {
    return changePage(index);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index)? changePage,
    TResult? Function()? changeCartCount,
    TResult? Function()? setNavigationCount,
  }) {
    return changePage?.call(index);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? changePage,
    TResult Function()? changeCartCount,
    TResult Function()? setNavigationCount,
    required TResult orElse(),
  }) {
    if (changePage != null) {
      return changePage(index);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_ChangeCartCountEvent value) changeCartCount,
    required TResult Function(_SetNavigationEvent value) setNavigationCount,
  }) {
    return changePage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_ChangeCartCountEvent value)? changeCartCount,
    TResult? Function(_SetNavigationEvent value)? setNavigationCount,
  }) {
    return changePage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_ChangeCartCountEvent value)? changeCartCount,
    TResult Function(_SetNavigationEvent value)? setNavigationCount,
    required TResult orElse(),
  }) {
    if (changePage != null) {
      return changePage(this);
    }
    return orElse();
  }
}

abstract class _ChangePageEvent implements BottomNavEvent {
  factory _ChangePageEvent({required final int index}) = _$_ChangePageEvent;

  int get index;
  @JsonKey(ignore: true)
  _$$_ChangePageEventCopyWith<_$_ChangePageEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_ChangeCartCountEventCopyWith<$Res> {
  factory _$$_ChangeCartCountEventCopyWith(_$_ChangeCartCountEvent value,
          $Res Function(_$_ChangeCartCountEvent) then) =
      __$$_ChangeCartCountEventCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ChangeCartCountEventCopyWithImpl<$Res>
    extends _$BottomNavEventCopyWithImpl<$Res, _$_ChangeCartCountEvent>
    implements _$$_ChangeCartCountEventCopyWith<$Res> {
  __$$_ChangeCartCountEventCopyWithImpl(_$_ChangeCartCountEvent _value,
      $Res Function(_$_ChangeCartCountEvent) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ChangeCartCountEvent implements _ChangeCartCountEvent {
  _$_ChangeCartCountEvent();

  @override
  String toString() {
    return 'BottomNavEvent.changeCartCount()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_ChangeCartCountEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index) changePage,
    required TResult Function() changeCartCount,
    required TResult Function() setNavigationCount,
  }) {
    return changeCartCount();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index)? changePage,
    TResult? Function()? changeCartCount,
    TResult? Function()? setNavigationCount,
  }) {
    return changeCartCount?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? changePage,
    TResult Function()? changeCartCount,
    TResult Function()? setNavigationCount,
    required TResult orElse(),
  }) {
    if (changeCartCount != null) {
      return changeCartCount();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_ChangeCartCountEvent value) changeCartCount,
    required TResult Function(_SetNavigationEvent value) setNavigationCount,
  }) {
    return changeCartCount(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_ChangeCartCountEvent value)? changeCartCount,
    TResult? Function(_SetNavigationEvent value)? setNavigationCount,
  }) {
    return changeCartCount?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_ChangeCartCountEvent value)? changeCartCount,
    TResult Function(_SetNavigationEvent value)? setNavigationCount,
    required TResult orElse(),
  }) {
    if (changeCartCount != null) {
      return changeCartCount(this);
    }
    return orElse();
  }
}

abstract class _ChangeCartCountEvent implements BottomNavEvent {
  factory _ChangeCartCountEvent() = _$_ChangeCartCountEvent;
}

/// @nodoc
abstract class _$$_SetNavigationEventCopyWith<$Res> {
  factory _$$_SetNavigationEventCopyWith(_$_SetNavigationEvent value,
          $Res Function(_$_SetNavigationEvent) then) =
      __$$_SetNavigationEventCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_SetNavigationEventCopyWithImpl<$Res>
    extends _$BottomNavEventCopyWithImpl<$Res, _$_SetNavigationEvent>
    implements _$$_SetNavigationEventCopyWith<$Res> {
  __$$_SetNavigationEventCopyWithImpl(
      _$_SetNavigationEvent _value, $Res Function(_$_SetNavigationEvent) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_SetNavigationEvent implements _SetNavigationEvent {
  _$_SetNavigationEvent();

  @override
  String toString() {
    return 'BottomNavEvent.setNavigationCount()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_SetNavigationEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index) changePage,
    required TResult Function() changeCartCount,
    required TResult Function() setNavigationCount,
  }) {
    return setNavigationCount();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index)? changePage,
    TResult? Function()? changeCartCount,
    TResult? Function()? setNavigationCount,
  }) {
    return setNavigationCount?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? changePage,
    TResult Function()? changeCartCount,
    TResult Function()? setNavigationCount,
    required TResult orElse(),
  }) {
    if (setNavigationCount != null) {
      return setNavigationCount();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_ChangeCartCountEvent value) changeCartCount,
    required TResult Function(_SetNavigationEvent value) setNavigationCount,
  }) {
    return setNavigationCount(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_ChangeCartCountEvent value)? changeCartCount,
    TResult? Function(_SetNavigationEvent value)? setNavigationCount,
  }) {
    return setNavigationCount?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_ChangeCartCountEvent value)? changeCartCount,
    TResult Function(_SetNavigationEvent value)? setNavigationCount,
    required TResult orElse(),
  }) {
    if (setNavigationCount != null) {
      return setNavigationCount(this);
    }
    return orElse();
  }
}

abstract class _SetNavigationEvent implements BottomNavEvent {
  factory _SetNavigationEvent() = _$_SetNavigationEvent;
}

/// @nodoc
mixin _$BottomNavState {
  int get index => throw _privateConstructorUsedError;
  int get cartCount => throw _privateConstructorUsedError;
  bool get isHome => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BottomNavStateCopyWith<BottomNavState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BottomNavStateCopyWith<$Res> {
  factory $BottomNavStateCopyWith(
          BottomNavState value, $Res Function(BottomNavState) then) =
      _$BottomNavStateCopyWithImpl<$Res, BottomNavState>;
  @useResult
  $Res call({int index, int cartCount, bool isHome});
}

/// @nodoc
class _$BottomNavStateCopyWithImpl<$Res, $Val extends BottomNavState>
    implements $BottomNavStateCopyWith<$Res> {
  _$BottomNavStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? cartCount = null,
    Object? isHome = null,
  }) {
    return _then(_value.copyWith(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      cartCount: null == cartCount
          ? _value.cartCount
          : cartCount // ignore: cast_nullable_to_non_nullable
              as int,
      isHome: null == isHome
          ? _value.isHome
          : isHome // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BottomNavStateCopyWith<$Res>
    implements $BottomNavStateCopyWith<$Res> {
  factory _$$_BottomNavStateCopyWith(
          _$_BottomNavState value, $Res Function(_$_BottomNavState) then) =
      __$$_BottomNavStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int index, int cartCount, bool isHome});
}

/// @nodoc
class __$$_BottomNavStateCopyWithImpl<$Res>
    extends _$BottomNavStateCopyWithImpl<$Res, _$_BottomNavState>
    implements _$$_BottomNavStateCopyWith<$Res> {
  __$$_BottomNavStateCopyWithImpl(
      _$_BottomNavState _value, $Res Function(_$_BottomNavState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? cartCount = null,
    Object? isHome = null,
  }) {
    return _then(_$_BottomNavState(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      cartCount: null == cartCount
          ? _value.cartCount
          : cartCount // ignore: cast_nullable_to_non_nullable
              as int,
      isHome: null == isHome
          ? _value.isHome
          : isHome // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_BottomNavState implements _BottomNavState {
  const _$_BottomNavState(
      {required this.index, required this.cartCount, required this.isHome});

  @override
  final int index;
  @override
  final int cartCount;
  @override
  final bool isHome;

  @override
  String toString() {
    return 'BottomNavState(index: $index, cartCount: $cartCount, isHome: $isHome)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BottomNavState &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.cartCount, cartCount) ||
                other.cartCount == cartCount) &&
            (identical(other.isHome, isHome) || other.isHome == isHome));
  }

  @override
  int get hashCode => Object.hash(runtimeType, index, cartCount, isHome);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BottomNavStateCopyWith<_$_BottomNavState> get copyWith =>
      __$$_BottomNavStateCopyWithImpl<_$_BottomNavState>(this, _$identity);
}

abstract class _BottomNavState implements BottomNavState {
  const factory _BottomNavState(
      {required final int index,
      required final int cartCount,
      required final bool isHome}) = _$_BottomNavState;

  @override
  int get index;
  @override
  int get cartCount;
  @override
  bool get isHome;
  @override
  @JsonKey(ignore: true)
  _$$_BottomNavStateCopyWith<_$_BottomNavState> get copyWith =>
      throw _privateConstructorUsedError;
}
