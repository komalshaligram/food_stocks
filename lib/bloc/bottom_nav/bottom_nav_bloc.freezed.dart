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
    required TResult Function() animationCartEvent,
    required TResult Function(bool isBottomNavBar) snackbarEvent,
    required TResult Function(BuildContext context, String pushNavigation)
        PushNavigationEvent,
    required TResult Function(BuildContext context, String storeScreen)
        NavigateToStoreScreenEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index)? changePage,
    TResult? Function()? updateCartCountEvent,
    TResult? Function()? animationCartEvent,
    TResult? Function(bool isBottomNavBar)? snackbarEvent,
    TResult? Function(BuildContext context, String pushNavigation)?
        PushNavigationEvent,
    TResult? Function(BuildContext context, String storeScreen)?
        NavigateToStoreScreenEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? changePage,
    TResult Function()? updateCartCountEvent,
    TResult Function()? animationCartEvent,
    TResult Function(bool isBottomNavBar)? snackbarEvent,
    TResult Function(BuildContext context, String pushNavigation)?
        PushNavigationEvent,
    TResult Function(BuildContext context, String storeScreen)?
        NavigateToStoreScreenEvent,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_UpdateCartCountEvent value) updateCartCountEvent,
    required TResult Function(_animationCartEvent value) animationCartEvent,
    required TResult Function(_snackbarEvent value) snackbarEvent,
    required TResult Function(_PushNavigationEvent value) PushNavigationEvent,
    required TResult Function(_NavigateToStoreScreenEvent value)
        NavigateToStoreScreenEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_animationCartEvent value)? animationCartEvent,
    TResult? Function(_snackbarEvent value)? snackbarEvent,
    TResult? Function(_PushNavigationEvent value)? PushNavigationEvent,
    TResult? Function(_NavigateToStoreScreenEvent value)?
        NavigateToStoreScreenEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_animationCartEvent value)? animationCartEvent,
    TResult Function(_snackbarEvent value)? snackbarEvent,
    TResult Function(_PushNavigationEvent value)? PushNavigationEvent,
    TResult Function(_NavigateToStoreScreenEvent value)?
        NavigateToStoreScreenEvent,
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
    required TResult Function() animationCartEvent,
    required TResult Function(bool isBottomNavBar) snackbarEvent,
    required TResult Function(BuildContext context, String pushNavigation)
        PushNavigationEvent,
    required TResult Function(BuildContext context, String storeScreen)
        NavigateToStoreScreenEvent,
  }) {
    return changePage(index);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index)? changePage,
    TResult? Function()? updateCartCountEvent,
    TResult? Function()? animationCartEvent,
    TResult? Function(bool isBottomNavBar)? snackbarEvent,
    TResult? Function(BuildContext context, String pushNavigation)?
        PushNavigationEvent,
    TResult? Function(BuildContext context, String storeScreen)?
        NavigateToStoreScreenEvent,
  }) {
    return changePage?.call(index);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? changePage,
    TResult Function()? updateCartCountEvent,
    TResult Function()? animationCartEvent,
    TResult Function(bool isBottomNavBar)? snackbarEvent,
    TResult Function(BuildContext context, String pushNavigation)?
        PushNavigationEvent,
    TResult Function(BuildContext context, String storeScreen)?
        NavigateToStoreScreenEvent,
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
    required TResult Function(_animationCartEvent value) animationCartEvent,
    required TResult Function(_snackbarEvent value) snackbarEvent,
    required TResult Function(_PushNavigationEvent value) PushNavigationEvent,
    required TResult Function(_NavigateToStoreScreenEvent value)
        NavigateToStoreScreenEvent,
  }) {
    return changePage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_animationCartEvent value)? animationCartEvent,
    TResult? Function(_snackbarEvent value)? snackbarEvent,
    TResult? Function(_PushNavigationEvent value)? PushNavigationEvent,
    TResult? Function(_NavigateToStoreScreenEvent value)?
        NavigateToStoreScreenEvent,
  }) {
    return changePage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_animationCartEvent value)? animationCartEvent,
    TResult Function(_snackbarEvent value)? snackbarEvent,
    TResult Function(_PushNavigationEvent value)? PushNavigationEvent,
    TResult Function(_NavigateToStoreScreenEvent value)?
        NavigateToStoreScreenEvent,
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
    required TResult Function() animationCartEvent,
    required TResult Function(bool isBottomNavBar) snackbarEvent,
    required TResult Function(BuildContext context, String pushNavigation)
        PushNavigationEvent,
    required TResult Function(BuildContext context, String storeScreen)
        NavigateToStoreScreenEvent,
  }) {
    return updateCartCountEvent();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index)? changePage,
    TResult? Function()? updateCartCountEvent,
    TResult? Function()? animationCartEvent,
    TResult? Function(bool isBottomNavBar)? snackbarEvent,
    TResult? Function(BuildContext context, String pushNavigation)?
        PushNavigationEvent,
    TResult? Function(BuildContext context, String storeScreen)?
        NavigateToStoreScreenEvent,
  }) {
    return updateCartCountEvent?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? changePage,
    TResult Function()? updateCartCountEvent,
    TResult Function()? animationCartEvent,
    TResult Function(bool isBottomNavBar)? snackbarEvent,
    TResult Function(BuildContext context, String pushNavigation)?
        PushNavigationEvent,
    TResult Function(BuildContext context, String storeScreen)?
        NavigateToStoreScreenEvent,
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
    required TResult Function(_animationCartEvent value) animationCartEvent,
    required TResult Function(_snackbarEvent value) snackbarEvent,
    required TResult Function(_PushNavigationEvent value) PushNavigationEvent,
    required TResult Function(_NavigateToStoreScreenEvent value)
        NavigateToStoreScreenEvent,
  }) {
    return updateCartCountEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_animationCartEvent value)? animationCartEvent,
    TResult? Function(_snackbarEvent value)? snackbarEvent,
    TResult? Function(_PushNavigationEvent value)? PushNavigationEvent,
    TResult? Function(_NavigateToStoreScreenEvent value)?
        NavigateToStoreScreenEvent,
  }) {
    return updateCartCountEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_animationCartEvent value)? animationCartEvent,
    TResult Function(_snackbarEvent value)? snackbarEvent,
    TResult Function(_PushNavigationEvent value)? PushNavigationEvent,
    TResult Function(_NavigateToStoreScreenEvent value)?
        NavigateToStoreScreenEvent,
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
abstract class _$$animationCartEventImplCopyWith<$Res> {
  factory _$$animationCartEventImplCopyWith(_$animationCartEventImpl value,
          $Res Function(_$animationCartEventImpl) then) =
      __$$animationCartEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$animationCartEventImplCopyWithImpl<$Res>
    extends _$BottomNavEventCopyWithImpl<$Res, _$animationCartEventImpl>
    implements _$$animationCartEventImplCopyWith<$Res> {
  __$$animationCartEventImplCopyWithImpl(_$animationCartEventImpl _value,
      $Res Function(_$animationCartEventImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$animationCartEventImpl implements _animationCartEvent {
  const _$animationCartEventImpl();

  @override
  String toString() {
    return 'BottomNavEvent.animationCartEvent()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$animationCartEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index) changePage,
    required TResult Function() updateCartCountEvent,
    required TResult Function() animationCartEvent,
    required TResult Function(bool isBottomNavBar) snackbarEvent,
    required TResult Function(BuildContext context, String pushNavigation)
        PushNavigationEvent,
    required TResult Function(BuildContext context, String storeScreen)
        NavigateToStoreScreenEvent,
  }) {
    return animationCartEvent();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index)? changePage,
    TResult? Function()? updateCartCountEvent,
    TResult? Function()? animationCartEvent,
    TResult? Function(bool isBottomNavBar)? snackbarEvent,
    TResult? Function(BuildContext context, String pushNavigation)?
        PushNavigationEvent,
    TResult? Function(BuildContext context, String storeScreen)?
        NavigateToStoreScreenEvent,
  }) {
    return animationCartEvent?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? changePage,
    TResult Function()? updateCartCountEvent,
    TResult Function()? animationCartEvent,
    TResult Function(bool isBottomNavBar)? snackbarEvent,
    TResult Function(BuildContext context, String pushNavigation)?
        PushNavigationEvent,
    TResult Function(BuildContext context, String storeScreen)?
        NavigateToStoreScreenEvent,
    required TResult orElse(),
  }) {
    if (animationCartEvent != null) {
      return animationCartEvent();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_UpdateCartCountEvent value) updateCartCountEvent,
    required TResult Function(_animationCartEvent value) animationCartEvent,
    required TResult Function(_snackbarEvent value) snackbarEvent,
    required TResult Function(_PushNavigationEvent value) PushNavigationEvent,
    required TResult Function(_NavigateToStoreScreenEvent value)
        NavigateToStoreScreenEvent,
  }) {
    return animationCartEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_animationCartEvent value)? animationCartEvent,
    TResult? Function(_snackbarEvent value)? snackbarEvent,
    TResult? Function(_PushNavigationEvent value)? PushNavigationEvent,
    TResult? Function(_NavigateToStoreScreenEvent value)?
        NavigateToStoreScreenEvent,
  }) {
    return animationCartEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_animationCartEvent value)? animationCartEvent,
    TResult Function(_snackbarEvent value)? snackbarEvent,
    TResult Function(_PushNavigationEvent value)? PushNavigationEvent,
    TResult Function(_NavigateToStoreScreenEvent value)?
        NavigateToStoreScreenEvent,
    required TResult orElse(),
  }) {
    if (animationCartEvent != null) {
      return animationCartEvent(this);
    }
    return orElse();
  }
}

abstract class _animationCartEvent implements BottomNavEvent {
  const factory _animationCartEvent() = _$animationCartEventImpl;
}

/// @nodoc
abstract class _$$snackbarEventImplCopyWith<$Res> {
  factory _$$snackbarEventImplCopyWith(
          _$snackbarEventImpl value, $Res Function(_$snackbarEventImpl) then) =
      __$$snackbarEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isBottomNavBar});
}

/// @nodoc
class __$$snackbarEventImplCopyWithImpl<$Res>
    extends _$BottomNavEventCopyWithImpl<$Res, _$snackbarEventImpl>
    implements _$$snackbarEventImplCopyWith<$Res> {
  __$$snackbarEventImplCopyWithImpl(
      _$snackbarEventImpl _value, $Res Function(_$snackbarEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBottomNavBar = null,
  }) {
    return _then(_$snackbarEventImpl(
      isBottomNavBar: null == isBottomNavBar
          ? _value.isBottomNavBar
          : isBottomNavBar // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$snackbarEventImpl implements _snackbarEvent {
  const _$snackbarEventImpl({required this.isBottomNavBar});

  @override
  final bool isBottomNavBar;

  @override
  String toString() {
    return 'BottomNavEvent.snackbarEvent(isBottomNavBar: $isBottomNavBar)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$snackbarEventImpl &&
            (identical(other.isBottomNavBar, isBottomNavBar) ||
                other.isBottomNavBar == isBottomNavBar));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isBottomNavBar);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$snackbarEventImplCopyWith<_$snackbarEventImpl> get copyWith =>
      __$$snackbarEventImplCopyWithImpl<_$snackbarEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index) changePage,
    required TResult Function() updateCartCountEvent,
    required TResult Function() animationCartEvent,
    required TResult Function(bool isBottomNavBar) snackbarEvent,
    required TResult Function(BuildContext context, String pushNavigation)
        PushNavigationEvent,
    required TResult Function(BuildContext context, String storeScreen)
        NavigateToStoreScreenEvent,
  }) {
    return snackbarEvent(isBottomNavBar);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index)? changePage,
    TResult? Function()? updateCartCountEvent,
    TResult? Function()? animationCartEvent,
    TResult? Function(bool isBottomNavBar)? snackbarEvent,
    TResult? Function(BuildContext context, String pushNavigation)?
        PushNavigationEvent,
    TResult? Function(BuildContext context, String storeScreen)?
        NavigateToStoreScreenEvent,
  }) {
    return snackbarEvent?.call(isBottomNavBar);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? changePage,
    TResult Function()? updateCartCountEvent,
    TResult Function()? animationCartEvent,
    TResult Function(bool isBottomNavBar)? snackbarEvent,
    TResult Function(BuildContext context, String pushNavigation)?
        PushNavigationEvent,
    TResult Function(BuildContext context, String storeScreen)?
        NavigateToStoreScreenEvent,
    required TResult orElse(),
  }) {
    if (snackbarEvent != null) {
      return snackbarEvent(isBottomNavBar);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_UpdateCartCountEvent value) updateCartCountEvent,
    required TResult Function(_animationCartEvent value) animationCartEvent,
    required TResult Function(_snackbarEvent value) snackbarEvent,
    required TResult Function(_PushNavigationEvent value) PushNavigationEvent,
    required TResult Function(_NavigateToStoreScreenEvent value)
        NavigateToStoreScreenEvent,
  }) {
    return snackbarEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_animationCartEvent value)? animationCartEvent,
    TResult? Function(_snackbarEvent value)? snackbarEvent,
    TResult? Function(_PushNavigationEvent value)? PushNavigationEvent,
    TResult? Function(_NavigateToStoreScreenEvent value)?
        NavigateToStoreScreenEvent,
  }) {
    return snackbarEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_animationCartEvent value)? animationCartEvent,
    TResult Function(_snackbarEvent value)? snackbarEvent,
    TResult Function(_PushNavigationEvent value)? PushNavigationEvent,
    TResult Function(_NavigateToStoreScreenEvent value)?
        NavigateToStoreScreenEvent,
    required TResult orElse(),
  }) {
    if (snackbarEvent != null) {
      return snackbarEvent(this);
    }
    return orElse();
  }
}

abstract class _snackbarEvent implements BottomNavEvent {
  const factory _snackbarEvent({required final bool isBottomNavBar}) =
      _$snackbarEventImpl;

  bool get isBottomNavBar;
  @JsonKey(ignore: true)
  _$$snackbarEventImplCopyWith<_$snackbarEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PushNavigationEventImplCopyWith<$Res> {
  factory _$$PushNavigationEventImplCopyWith(_$PushNavigationEventImpl value,
          $Res Function(_$PushNavigationEventImpl) then) =
      __$$PushNavigationEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BuildContext context, String pushNavigation});
}

/// @nodoc
class __$$PushNavigationEventImplCopyWithImpl<$Res>
    extends _$BottomNavEventCopyWithImpl<$Res, _$PushNavigationEventImpl>
    implements _$$PushNavigationEventImplCopyWith<$Res> {
  __$$PushNavigationEventImplCopyWithImpl(_$PushNavigationEventImpl _value,
      $Res Function(_$PushNavigationEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? context = null,
    Object? pushNavigation = null,
  }) {
    return _then(_$PushNavigationEventImpl(
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as BuildContext,
      pushNavigation: null == pushNavigation
          ? _value.pushNavigation
          : pushNavigation // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PushNavigationEventImpl implements _PushNavigationEvent {
  const _$PushNavigationEventImpl(
      {required this.context, required this.pushNavigation});

  @override
  final BuildContext context;
  @override
  final String pushNavigation;

  @override
  String toString() {
    return 'BottomNavEvent.PushNavigationEvent(context: $context, pushNavigation: $pushNavigation)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PushNavigationEventImpl &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.pushNavigation, pushNavigation) ||
                other.pushNavigation == pushNavigation));
  }

  @override
  int get hashCode => Object.hash(runtimeType, context, pushNavigation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PushNavigationEventImplCopyWith<_$PushNavigationEventImpl> get copyWith =>
      __$$PushNavigationEventImplCopyWithImpl<_$PushNavigationEventImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index) changePage,
    required TResult Function() updateCartCountEvent,
    required TResult Function() animationCartEvent,
    required TResult Function(bool isBottomNavBar) snackbarEvent,
    required TResult Function(BuildContext context, String pushNavigation)
        PushNavigationEvent,
    required TResult Function(BuildContext context, String storeScreen)
        NavigateToStoreScreenEvent,
  }) {
    return PushNavigationEvent(context, pushNavigation);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index)? changePage,
    TResult? Function()? updateCartCountEvent,
    TResult? Function()? animationCartEvent,
    TResult? Function(bool isBottomNavBar)? snackbarEvent,
    TResult? Function(BuildContext context, String pushNavigation)?
        PushNavigationEvent,
    TResult? Function(BuildContext context, String storeScreen)?
        NavigateToStoreScreenEvent,
  }) {
    return PushNavigationEvent?.call(context, pushNavigation);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? changePage,
    TResult Function()? updateCartCountEvent,
    TResult Function()? animationCartEvent,
    TResult Function(bool isBottomNavBar)? snackbarEvent,
    TResult Function(BuildContext context, String pushNavigation)?
        PushNavigationEvent,
    TResult Function(BuildContext context, String storeScreen)?
        NavigateToStoreScreenEvent,
    required TResult orElse(),
  }) {
    if (PushNavigationEvent != null) {
      return PushNavigationEvent(context, pushNavigation);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_UpdateCartCountEvent value) updateCartCountEvent,
    required TResult Function(_animationCartEvent value) animationCartEvent,
    required TResult Function(_snackbarEvent value) snackbarEvent,
    required TResult Function(_PushNavigationEvent value) PushNavigationEvent,
    required TResult Function(_NavigateToStoreScreenEvent value)
        NavigateToStoreScreenEvent,
  }) {
    return PushNavigationEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_animationCartEvent value)? animationCartEvent,
    TResult? Function(_snackbarEvent value)? snackbarEvent,
    TResult? Function(_PushNavigationEvent value)? PushNavigationEvent,
    TResult? Function(_NavigateToStoreScreenEvent value)?
        NavigateToStoreScreenEvent,
  }) {
    return PushNavigationEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_animationCartEvent value)? animationCartEvent,
    TResult Function(_snackbarEvent value)? snackbarEvent,
    TResult Function(_PushNavigationEvent value)? PushNavigationEvent,
    TResult Function(_NavigateToStoreScreenEvent value)?
        NavigateToStoreScreenEvent,
    required TResult orElse(),
  }) {
    if (PushNavigationEvent != null) {
      return PushNavigationEvent(this);
    }
    return orElse();
  }
}

abstract class _PushNavigationEvent implements BottomNavEvent {
  const factory _PushNavigationEvent(
      {required final BuildContext context,
      required final String pushNavigation}) = _$PushNavigationEventImpl;

  BuildContext get context;
  String get pushNavigation;
  @JsonKey(ignore: true)
  _$$PushNavigationEventImplCopyWith<_$PushNavigationEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NavigateToStoreScreenEventImplCopyWith<$Res> {
  factory _$$NavigateToStoreScreenEventImplCopyWith(
          _$NavigateToStoreScreenEventImpl value,
          $Res Function(_$NavigateToStoreScreenEventImpl) then) =
      __$$NavigateToStoreScreenEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BuildContext context, String storeScreen});
}

/// @nodoc
class __$$NavigateToStoreScreenEventImplCopyWithImpl<$Res>
    extends _$BottomNavEventCopyWithImpl<$Res, _$NavigateToStoreScreenEventImpl>
    implements _$$NavigateToStoreScreenEventImplCopyWith<$Res> {
  __$$NavigateToStoreScreenEventImplCopyWithImpl(
      _$NavigateToStoreScreenEventImpl _value,
      $Res Function(_$NavigateToStoreScreenEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? context = null,
    Object? storeScreen = null,
  }) {
    return _then(_$NavigateToStoreScreenEventImpl(
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as BuildContext,
      storeScreen: null == storeScreen
          ? _value.storeScreen
          : storeScreen // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NavigateToStoreScreenEventImpl implements _NavigateToStoreScreenEvent {
  const _$NavigateToStoreScreenEventImpl(
      {required this.context, required this.storeScreen});

  @override
  final BuildContext context;
  @override
  final String storeScreen;

  @override
  String toString() {
    return 'BottomNavEvent.NavigateToStoreScreenEvent(context: $context, storeScreen: $storeScreen)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavigateToStoreScreenEventImpl &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.storeScreen, storeScreen) ||
                other.storeScreen == storeScreen));
  }

  @override
  int get hashCode => Object.hash(runtimeType, context, storeScreen);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NavigateToStoreScreenEventImplCopyWith<_$NavigateToStoreScreenEventImpl>
      get copyWith => __$$NavigateToStoreScreenEventImplCopyWithImpl<
          _$NavigateToStoreScreenEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index) changePage,
    required TResult Function() updateCartCountEvent,
    required TResult Function() animationCartEvent,
    required TResult Function(bool isBottomNavBar) snackbarEvent,
    required TResult Function(BuildContext context, String pushNavigation)
        PushNavigationEvent,
    required TResult Function(BuildContext context, String storeScreen)
        NavigateToStoreScreenEvent,
  }) {
    return NavigateToStoreScreenEvent(context, storeScreen);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index)? changePage,
    TResult? Function()? updateCartCountEvent,
    TResult? Function()? animationCartEvent,
    TResult? Function(bool isBottomNavBar)? snackbarEvent,
    TResult? Function(BuildContext context, String pushNavigation)?
        PushNavigationEvent,
    TResult? Function(BuildContext context, String storeScreen)?
        NavigateToStoreScreenEvent,
  }) {
    return NavigateToStoreScreenEvent?.call(context, storeScreen);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index)? changePage,
    TResult Function()? updateCartCountEvent,
    TResult Function()? animationCartEvent,
    TResult Function(bool isBottomNavBar)? snackbarEvent,
    TResult Function(BuildContext context, String pushNavigation)?
        PushNavigationEvent,
    TResult Function(BuildContext context, String storeScreen)?
        NavigateToStoreScreenEvent,
    required TResult orElse(),
  }) {
    if (NavigateToStoreScreenEvent != null) {
      return NavigateToStoreScreenEvent(context, storeScreen);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_UpdateCartCountEvent value) updateCartCountEvent,
    required TResult Function(_animationCartEvent value) animationCartEvent,
    required TResult Function(_snackbarEvent value) snackbarEvent,
    required TResult Function(_PushNavigationEvent value) PushNavigationEvent,
    required TResult Function(_NavigateToStoreScreenEvent value)
        NavigateToStoreScreenEvent,
  }) {
    return NavigateToStoreScreenEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_animationCartEvent value)? animationCartEvent,
    TResult? Function(_snackbarEvent value)? snackbarEvent,
    TResult? Function(_PushNavigationEvent value)? PushNavigationEvent,
    TResult? Function(_NavigateToStoreScreenEvent value)?
        NavigateToStoreScreenEvent,
  }) {
    return NavigateToStoreScreenEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_animationCartEvent value)? animationCartEvent,
    TResult Function(_snackbarEvent value)? snackbarEvent,
    TResult Function(_PushNavigationEvent value)? PushNavigationEvent,
    TResult Function(_NavigateToStoreScreenEvent value)?
        NavigateToStoreScreenEvent,
    required TResult orElse(),
  }) {
    if (NavigateToStoreScreenEvent != null) {
      return NavigateToStoreScreenEvent(this);
    }
    return orElse();
  }
}

abstract class _NavigateToStoreScreenEvent implements BottomNavEvent {
  const factory _NavigateToStoreScreenEvent(
      {required final BuildContext context,
      required final String storeScreen}) = _$NavigateToStoreScreenEventImpl;

  BuildContext get context;
  String get storeScreen;
  @JsonKey(ignore: true)
  _$$NavigateToStoreScreenEventImplCopyWith<_$NavigateToStoreScreenEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BottomNavState {
  int get index => throw _privateConstructorUsedError;
  int get cartCount => throw _privateConstructorUsedError;
  bool get isAnimation => throw _privateConstructorUsedError;
  String get pushNotificationPath => throw _privateConstructorUsedError;
  bool get duringCelebration => throw _privateConstructorUsedError;
  String get isStoreScreen => throw _privateConstructorUsedError;
  bool get isGuestUser => throw _privateConstructorUsedError;

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
  $Res call(
      {int index,
      int cartCount,
      bool isAnimation,
      String pushNotificationPath,
      bool duringCelebration,
      String isStoreScreen,
      bool isGuestUser});
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
    Object? pushNotificationPath = null,
    Object? duringCelebration = null,
    Object? isStoreScreen = null,
    Object? isGuestUser = null,
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
      pushNotificationPath: null == pushNotificationPath
          ? _value.pushNotificationPath
          : pushNotificationPath // ignore: cast_nullable_to_non_nullable
              as String,
      duringCelebration: null == duringCelebration
          ? _value.duringCelebration
          : duringCelebration // ignore: cast_nullable_to_non_nullable
              as bool,
      isStoreScreen: null == isStoreScreen
          ? _value.isStoreScreen
          : isStoreScreen // ignore: cast_nullable_to_non_nullable
              as String,
      isGuestUser: null == isGuestUser
          ? _value.isGuestUser
          : isGuestUser // ignore: cast_nullable_to_non_nullable
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
  $Res call(
      {int index,
      int cartCount,
      bool isAnimation,
      String pushNotificationPath,
      bool duringCelebration,
      String isStoreScreen,
      bool isGuestUser});
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
    Object? pushNotificationPath = null,
    Object? duringCelebration = null,
    Object? isStoreScreen = null,
    Object? isGuestUser = null,
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
      pushNotificationPath: null == pushNotificationPath
          ? _value.pushNotificationPath
          : pushNotificationPath // ignore: cast_nullable_to_non_nullable
              as String,
      duringCelebration: null == duringCelebration
          ? _value.duringCelebration
          : duringCelebration // ignore: cast_nullable_to_non_nullable
              as bool,
      isStoreScreen: null == isStoreScreen
          ? _value.isStoreScreen
          : isStoreScreen // ignore: cast_nullable_to_non_nullable
              as String,
      isGuestUser: null == isGuestUser
          ? _value.isGuestUser
          : isGuestUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BottomNavStateImpl implements _BottomNavState {
  const _$BottomNavStateImpl(
      {required this.index,
      required this.cartCount,
      required this.isAnimation,
      required this.pushNotificationPath,
      required this.duringCelebration,
      required this.isStoreScreen,
      required this.isGuestUser});

  @override
  final int index;
  @override
  final int cartCount;
  @override
  final bool isAnimation;
  @override
  final String pushNotificationPath;
  @override
  final bool duringCelebration;
  @override
  final String isStoreScreen;
  @override
  final bool isGuestUser;

  @override
  String toString() {
    return 'BottomNavState(index: $index, cartCount: $cartCount, isAnimation: $isAnimation, pushNotificationPath: $pushNotificationPath, duringCelebration: $duringCelebration, isStoreScreen: $isStoreScreen, isGuestUser: $isGuestUser)';
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
                other.isAnimation == isAnimation) &&
            (identical(other.pushNotificationPath, pushNotificationPath) ||
                other.pushNotificationPath == pushNotificationPath) &&
            (identical(other.duringCelebration, duringCelebration) ||
                other.duringCelebration == duringCelebration) &&
            (identical(other.isStoreScreen, isStoreScreen) ||
                other.isStoreScreen == isStoreScreen) &&
            (identical(other.isGuestUser, isGuestUser) ||
                other.isGuestUser == isGuestUser));
  }

  @override
  int get hashCode => Object.hash(runtimeType, index, cartCount, isAnimation,
      pushNotificationPath, duringCelebration, isStoreScreen, isGuestUser);

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
      required final bool isAnimation,
      required final String pushNotificationPath,
      required final bool duringCelebration,
      required final String isStoreScreen,
      required final bool isGuestUser}) = _$BottomNavStateImpl;

  @override
  int get index;
  @override
  int get cartCount;
  @override
  bool get isAnimation;
  @override
  String get pushNotificationPath;
  @override
  bool get duringCelebration;
  @override
  String get isStoreScreen;
  @override
  bool get isGuestUser;
  @override
  @JsonKey(ignore: true)
  _$$BottomNavStateImplCopyWith<_$BottomNavStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
