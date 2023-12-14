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
    required TResult Function() updateCartCountEvent,
    required TResult Function(int cartCount) cartAnimationEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index)? changePage,
    TResult? Function()? updateCartCountEvent,
    TResult? Function(int cartCount)? cartAnimationEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? changePage,
    TResult Function()? updateCartCountEvent,
    TResult Function(int cartCount)? cartAnimationEvent,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_UpdateCartCountEvent value) updateCartCountEvent,
    required TResult Function(_cartAnimationEvent value) cartAnimationEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_cartAnimationEvent value)? cartAnimationEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_cartAnimationEvent value)? cartAnimationEvent,
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
abstract class _$$ChangePageEventImplCopyWith<$Res> {
  factory _$$ChangePageEventImplCopyWith(_$ChangePageEventImpl value,
          $Res Function(_$ChangePageEventImpl) then) =
      __$$ChangePageEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int index});
}

/// @nodoc
class __$$ChangePageEventImplCopyWithImpl<$Res>
    extends _$BottomNavEventCopyWithImpl<$Res, _$ChangePageEventImpl>
    implements _$$ChangePageEventImplCopyWith<$Res> {
  __$$ChangePageEventImplCopyWithImpl(
      _$ChangePageEventImpl _value, $Res Function(_$ChangePageEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
  }) {
    return _then(_$ChangePageEventImpl(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ChangePageEventImpl implements _ChangePageEvent {
  _$ChangePageEventImpl({required this.index});

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
            other is _$ChangePageEventImpl &&
            (identical(other.index, index) || other.index == index));
  }

  @override
  int get hashCode => Object.hash(runtimeType, index);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangePageEventImplCopyWith<_$ChangePageEventImpl> get copyWith =>
      __$$ChangePageEventImplCopyWithImpl<_$ChangePageEventImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index) changePage,
    required TResult Function() updateCartCountEvent,
    required TResult Function(int cartCount) cartAnimationEvent,
  }) {
    return changePage(index);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index)? changePage,
    TResult? Function()? updateCartCountEvent,
    TResult? Function(int cartCount)? cartAnimationEvent,
  }) {
    return changePage?.call(index);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? changePage,
    TResult Function()? updateCartCountEvent,
    TResult Function(int cartCount)? cartAnimationEvent,
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
    required TResult Function(_UpdateCartCountEvent value) updateCartCountEvent,
    required TResult Function(_cartAnimationEvent value) cartAnimationEvent,
  }) {
    return changePage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_cartAnimationEvent value)? cartAnimationEvent,
  }) {
    return changePage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_cartAnimationEvent value)? cartAnimationEvent,
    required TResult orElse(),
  }) {
    if (changePage != null) {
      return changePage(this);
    }
    return orElse();
  }
}

abstract class _ChangePageEvent implements BottomNavEvent {
  factory _ChangePageEvent({required final int index}) = _$ChangePageEventImpl;

  int get index;
  @JsonKey(ignore: true)
  _$$ChangePageEventImplCopyWith<_$ChangePageEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateCartCountEventImplCopyWith<$Res> {
  factory _$$UpdateCartCountEventImplCopyWith(_$UpdateCartCountEventImpl value,
          $Res Function(_$UpdateCartCountEventImpl) then) =
      __$$UpdateCartCountEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UpdateCartCountEventImplCopyWithImpl<$Res>
    extends _$BottomNavEventCopyWithImpl<$Res, _$UpdateCartCountEventImpl>
    implements _$$UpdateCartCountEventImplCopyWith<$Res> {
  __$$UpdateCartCountEventImplCopyWithImpl(_$UpdateCartCountEventImpl _value,
      $Res Function(_$UpdateCartCountEventImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$UpdateCartCountEventImpl implements _UpdateCartCountEvent {
  const _$UpdateCartCountEventImpl();

  @override
  String toString() {
    return 'BottomNavEvent.updateCartCountEvent()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateCartCountEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index) changePage,
    required TResult Function() updateCartCountEvent,
    required TResult Function(int cartCount) cartAnimationEvent,
  }) {
    return updateCartCountEvent();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index)? changePage,
    TResult? Function()? updateCartCountEvent,
    TResult? Function(int cartCount)? cartAnimationEvent,
  }) {
    return updateCartCountEvent?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? changePage,
    TResult Function()? updateCartCountEvent,
    TResult Function(int cartCount)? cartAnimationEvent,
    required TResult orElse(),
  }) {
    if (updateCartCountEvent != null) {
      return updateCartCountEvent();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_UpdateCartCountEvent value) updateCartCountEvent,
    required TResult Function(_cartAnimationEvent value) cartAnimationEvent,
  }) {
    return updateCartCountEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_cartAnimationEvent value)? cartAnimationEvent,
  }) {
    return updateCartCountEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_cartAnimationEvent value)? cartAnimationEvent,
    required TResult orElse(),
  }) {
    if (updateCartCountEvent != null) {
      return updateCartCountEvent(this);
    }
    return orElse();
  }
}

abstract class _UpdateCartCountEvent implements BottomNavEvent {
  const factory _UpdateCartCountEvent() = _$UpdateCartCountEventImpl;
}

/// @nodoc
abstract class _$$cartAnimationEventImplCopyWith<$Res> {
  factory _$$cartAnimationEventImplCopyWith(_$cartAnimationEventImpl value,
          $Res Function(_$cartAnimationEventImpl) then) =
      __$$cartAnimationEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int cartCount});
}

/// @nodoc
class __$$cartAnimationEventImplCopyWithImpl<$Res>
    extends _$BottomNavEventCopyWithImpl<$Res, _$cartAnimationEventImpl>
    implements _$$cartAnimationEventImplCopyWith<$Res> {
  __$$cartAnimationEventImplCopyWithImpl(_$cartAnimationEventImpl _value,
      $Res Function(_$cartAnimationEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cartCount = null,
  }) {
    return _then(_$cartAnimationEventImpl(
      cartCount: null == cartCount
          ? _value.cartCount
          : cartCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$cartAnimationEventImpl implements _cartAnimationEvent {
  const _$cartAnimationEventImpl({required this.cartCount});

  @override
  final int cartCount;

  @override
  String toString() {
    return 'BottomNavEvent.cartAnimationEvent(cartCount: $cartCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$cartAnimationEventImpl &&
            (identical(other.cartCount, cartCount) ||
                other.cartCount == cartCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cartCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$cartAnimationEventImplCopyWith<_$cartAnimationEventImpl> get copyWith =>
      __$$cartAnimationEventImplCopyWithImpl<_$cartAnimationEventImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index) changePage,
    required TResult Function() updateCartCountEvent,
    required TResult Function(int cartCount) cartAnimationEvent,
  }) {
    return cartAnimationEvent(cartCount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index)? changePage,
    TResult? Function()? updateCartCountEvent,
    TResult? Function(int cartCount)? cartAnimationEvent,
  }) {
    return cartAnimationEvent?.call(cartCount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? changePage,
    TResult Function()? updateCartCountEvent,
    TResult Function(int cartCount)? cartAnimationEvent,
    required TResult orElse(),
  }) {
    if (cartAnimationEvent != null) {
      return cartAnimationEvent(cartCount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_UpdateCartCountEvent value) updateCartCountEvent,
    required TResult Function(_cartAnimationEvent value) cartAnimationEvent,
  }) {
    return cartAnimationEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_cartAnimationEvent value)? cartAnimationEvent,
  }) {
    return cartAnimationEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_cartAnimationEvent value)? cartAnimationEvent,
    required TResult orElse(),
  }) {
    if (cartAnimationEvent != null) {
      return cartAnimationEvent(this);
    }
    return orElse();
  }
}

abstract class _cartAnimationEvent implements BottomNavEvent {
  const factory _cartAnimationEvent({required final int cartCount}) =
      _$cartAnimationEventImpl;

  int get cartCount;
  @JsonKey(ignore: true)
  _$$cartAnimationEventImplCopyWith<_$cartAnimationEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BottomNavState {
  int get index => throw _privateConstructorUsedError;
  int get cartCount => throw _privateConstructorUsedError;
  bool get isAnimation => throw _privateConstructorUsedError;

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
  $Res call({int index, int cartCount, bool isAnimation});
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
    Object? isAnimation = null,
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
      isAnimation: null == isAnimation
          ? _value.isAnimation
          : isAnimation // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BottomNavStateImplCopyWith<$Res>
    implements $BottomNavStateCopyWith<$Res> {
  factory _$$BottomNavStateImplCopyWith(_$BottomNavStateImpl value,
          $Res Function(_$BottomNavStateImpl) then) =
      __$$BottomNavStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int index, int cartCount, bool isAnimation});
}

/// @nodoc
class __$$BottomNavStateImplCopyWithImpl<$Res>
    extends _$BottomNavStateCopyWithImpl<$Res, _$BottomNavStateImpl>
    implements _$$BottomNavStateImplCopyWith<$Res> {
  __$$BottomNavStateImplCopyWithImpl(
      _$BottomNavStateImpl _value, $Res Function(_$BottomNavStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? cartCount = null,
    Object? isAnimation = null,
  }) {
    return _then(_$BottomNavStateImpl(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      cartCount: null == cartCount
          ? _value.cartCount
          : cartCount // ignore: cast_nullable_to_non_nullable
              as int,
      isAnimation: null == isAnimation
          ? _value.isAnimation
          : isAnimation // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BottomNavStateImpl implements _BottomNavState {
  const _$BottomNavStateImpl(
      {required this.index,
      required this.cartCount,
      required this.isAnimation});

  @override
  final int index;
  @override
  final int cartCount;
  @override
  final bool isAnimation;

  @override
  String toString() {
    return 'BottomNavState(index: $index, cartCount: $cartCount, isAnimation: $isAnimation)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BottomNavStateImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.cartCount, cartCount) ||
                other.cartCount == cartCount) &&
            (identical(other.isAnimation, isAnimation) ||
                other.isAnimation == isAnimation));
  }

  @override
  int get hashCode => Object.hash(runtimeType, index, cartCount, isAnimation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BottomNavStateImplCopyWith<_$BottomNavStateImpl> get copyWith =>
      __$$BottomNavStateImplCopyWithImpl<_$BottomNavStateImpl>(
          this, _$identity);
}

abstract class _BottomNavState implements BottomNavState {
  const factory _BottomNavState(
      {required final int index,
      required final int cartCount,
      required final bool isAnimation}) = _$BottomNavStateImpl;

  @override
  int get index;
  @override
  int get cartCount;
  @override
  bool get isAnimation;
  @override
  @JsonKey(ignore: true)
  _$$BottomNavStateImplCopyWith<_$BottomNavStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
