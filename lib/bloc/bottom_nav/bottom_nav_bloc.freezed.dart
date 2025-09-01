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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BottomNavEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index, BuildContext context) changePage,
    required TResult Function(BuildContext context) updateCartCountEvent,
    required TResult Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)
        navigateToStoreScreenEvent,
    required TResult Function(BuildContext context)
        seeWalletPermissionUpdateEvent,
    required TResult Function(BuildContext context) getPreferencesDataEvent,
    required TResult Function(bool isOpen) setDialogOpen,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index, BuildContext context)? changePage,
    TResult? Function(BuildContext context)? updateCartCountEvent,
    TResult? Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)?
        navigateToStoreScreenEvent,
    TResult? Function(BuildContext context)? seeWalletPermissionUpdateEvent,
    TResult? Function(BuildContext context)? getPreferencesDataEvent,
    TResult? Function(bool isOpen)? setDialogOpen,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index, BuildContext context)? changePage,
    TResult Function(BuildContext context)? updateCartCountEvent,
    TResult Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)?
        navigateToStoreScreenEvent,
    TResult Function(BuildContext context)? seeWalletPermissionUpdateEvent,
    TResult Function(BuildContext context)? getPreferencesDataEvent,
    TResult Function(bool isOpen)? setDialogOpen,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_UpdateCartCountEvent value) updateCartCountEvent,
    required TResult Function(_NavigateToStoreScreenEvent value)
        navigateToStoreScreenEvent,
    required TResult Function(_seeWalletPermissionUpdateEvent value)
        seeWalletPermissionUpdateEvent,
    required TResult Function(_getPreferencesDataEvent value)
        getPreferencesDataEvent,
    required TResult Function(_SetDialogOpenEvent value) setDialogOpen,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_NavigateToStoreScreenEvent value)?
        navigateToStoreScreenEvent,
    TResult? Function(_seeWalletPermissionUpdateEvent value)?
        seeWalletPermissionUpdateEvent,
    TResult? Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
    TResult? Function(_SetDialogOpenEvent value)? setDialogOpen,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_NavigateToStoreScreenEvent value)?
        navigateToStoreScreenEvent,
    TResult Function(_seeWalletPermissionUpdateEvent value)?
        seeWalletPermissionUpdateEvent,
    TResult Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
    TResult Function(_SetDialogOpenEvent value)? setDialogOpen,
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
  $Res call({int index, BuildContext context});
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
    Object? context = null,
  }) {
    return _then(_$ChangePageEventImpl(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as BuildContext,
    ));
  }
}

/// @nodoc

class _$ChangePageEventImpl implements _ChangePageEvent {
  _$ChangePageEventImpl({required this.index, required this.context});

  @override
  final int index;
  @override
  final BuildContext context;

  @override
  String toString() {
    return 'BottomNavEvent.changePage(index: $index, context: $context)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangePageEventImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.context, context) || other.context == context));
  }

  @override
  int get hashCode => Object.hash(runtimeType, index, context);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangePageEventImplCopyWith<_$ChangePageEventImpl> get copyWith =>
      __$$ChangePageEventImplCopyWithImpl<_$ChangePageEventImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index, BuildContext context) changePage,
    required TResult Function(BuildContext context) updateCartCountEvent,
    required TResult Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)
        navigateToStoreScreenEvent,
    required TResult Function(BuildContext context)
        seeWalletPermissionUpdateEvent,
    required TResult Function(BuildContext context) getPreferencesDataEvent,
    required TResult Function(bool isOpen) setDialogOpen,
  }) {
    return changePage(index, context);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index, BuildContext context)? changePage,
    TResult? Function(BuildContext context)? updateCartCountEvent,
    TResult? Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)?
        navigateToStoreScreenEvent,
    TResult? Function(BuildContext context)? seeWalletPermissionUpdateEvent,
    TResult? Function(BuildContext context)? getPreferencesDataEvent,
    TResult? Function(bool isOpen)? setDialogOpen,
  }) {
    return changePage?.call(index, context);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index, BuildContext context)? changePage,
    TResult Function(BuildContext context)? updateCartCountEvent,
    TResult Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)?
        navigateToStoreScreenEvent,
    TResult Function(BuildContext context)? seeWalletPermissionUpdateEvent,
    TResult Function(BuildContext context)? getPreferencesDataEvent,
    TResult Function(bool isOpen)? setDialogOpen,
    required TResult orElse(),
  }) {
    if (changePage != null) {
      return changePage(index, context);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_UpdateCartCountEvent value) updateCartCountEvent,
    required TResult Function(_NavigateToStoreScreenEvent value)
        navigateToStoreScreenEvent,
    required TResult Function(_seeWalletPermissionUpdateEvent value)
        seeWalletPermissionUpdateEvent,
    required TResult Function(_getPreferencesDataEvent value)
        getPreferencesDataEvent,
    required TResult Function(_SetDialogOpenEvent value) setDialogOpen,
  }) {
    return changePage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_NavigateToStoreScreenEvent value)?
        navigateToStoreScreenEvent,
    TResult? Function(_seeWalletPermissionUpdateEvent value)?
        seeWalletPermissionUpdateEvent,
    TResult? Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
    TResult? Function(_SetDialogOpenEvent value)? setDialogOpen,
  }) {
    return changePage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_NavigateToStoreScreenEvent value)?
        navigateToStoreScreenEvent,
    TResult Function(_seeWalletPermissionUpdateEvent value)?
        seeWalletPermissionUpdateEvent,
    TResult Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
    TResult Function(_SetDialogOpenEvent value)? setDialogOpen,
    required TResult orElse(),
  }) {
    if (changePage != null) {
      return changePage(this);
    }
    return orElse();
  }
}

abstract class _ChangePageEvent implements BottomNavEvent {
  factory _ChangePageEvent(
      {required final int index,
      required final BuildContext context}) = _$ChangePageEventImpl;

  int get index;
  BuildContext get context;
  @JsonKey(ignore: true)
  _$$ChangePageEventImplCopyWith<_$ChangePageEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateCartCountEventImplCopyWith<$Res> {
  factory _$$UpdateCartCountEventImplCopyWith(_$UpdateCartCountEventImpl value,
          $Res Function(_$UpdateCartCountEventImpl) then) =
      __$$UpdateCartCountEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BuildContext context});
}

/// @nodoc
class __$$UpdateCartCountEventImplCopyWithImpl<$Res>
    extends _$BottomNavEventCopyWithImpl<$Res, _$UpdateCartCountEventImpl>
    implements _$$UpdateCartCountEventImplCopyWith<$Res> {
  __$$UpdateCartCountEventImplCopyWithImpl(_$UpdateCartCountEventImpl _value,
      $Res Function(_$UpdateCartCountEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? context = null,
  }) {
    return _then(_$UpdateCartCountEventImpl(
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as BuildContext,
    ));
  }
}

/// @nodoc

class _$UpdateCartCountEventImpl implements _UpdateCartCountEvent {
  const _$UpdateCartCountEventImpl({required this.context});

  @override
  final BuildContext context;

  @override
  String toString() {
    return 'BottomNavEvent.updateCartCountEvent(context: $context)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateCartCountEventImpl &&
            (identical(other.context, context) || other.context == context));
  }

  @override
  int get hashCode => Object.hash(runtimeType, context);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateCartCountEventImplCopyWith<_$UpdateCartCountEventImpl>
      get copyWith =>
          __$$UpdateCartCountEventImplCopyWithImpl<_$UpdateCartCountEventImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index, BuildContext context) changePage,
    required TResult Function(BuildContext context) updateCartCountEvent,
    required TResult Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)
        navigateToStoreScreenEvent,
    required TResult Function(BuildContext context)
        seeWalletPermissionUpdateEvent,
    required TResult Function(BuildContext context) getPreferencesDataEvent,
    required TResult Function(bool isOpen) setDialogOpen,
  }) {
    return updateCartCountEvent(context);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index, BuildContext context)? changePage,
    TResult? Function(BuildContext context)? updateCartCountEvent,
    TResult? Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)?
        navigateToStoreScreenEvent,
    TResult? Function(BuildContext context)? seeWalletPermissionUpdateEvent,
    TResult? Function(BuildContext context)? getPreferencesDataEvent,
    TResult? Function(bool isOpen)? setDialogOpen,
  }) {
    return updateCartCountEvent?.call(context);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index, BuildContext context)? changePage,
    TResult Function(BuildContext context)? updateCartCountEvent,
    TResult Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)?
        navigateToStoreScreenEvent,
    TResult Function(BuildContext context)? seeWalletPermissionUpdateEvent,
    TResult Function(BuildContext context)? getPreferencesDataEvent,
    TResult Function(bool isOpen)? setDialogOpen,
    required TResult orElse(),
  }) {
    if (updateCartCountEvent != null) {
      return updateCartCountEvent(context);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_UpdateCartCountEvent value) updateCartCountEvent,
    required TResult Function(_NavigateToStoreScreenEvent value)
        navigateToStoreScreenEvent,
    required TResult Function(_seeWalletPermissionUpdateEvent value)
        seeWalletPermissionUpdateEvent,
    required TResult Function(_getPreferencesDataEvent value)
        getPreferencesDataEvent,
    required TResult Function(_SetDialogOpenEvent value) setDialogOpen,
  }) {
    return updateCartCountEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_NavigateToStoreScreenEvent value)?
        navigateToStoreScreenEvent,
    TResult? Function(_seeWalletPermissionUpdateEvent value)?
        seeWalletPermissionUpdateEvent,
    TResult? Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
    TResult? Function(_SetDialogOpenEvent value)? setDialogOpen,
  }) {
    return updateCartCountEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_NavigateToStoreScreenEvent value)?
        navigateToStoreScreenEvent,
    TResult Function(_seeWalletPermissionUpdateEvent value)?
        seeWalletPermissionUpdateEvent,
    TResult Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
    TResult Function(_SetDialogOpenEvent value)? setDialogOpen,
    required TResult orElse(),
  }) {
    if (updateCartCountEvent != null) {
      return updateCartCountEvent(this);
    }
    return orElse();
  }
}

abstract class _UpdateCartCountEvent implements BottomNavEvent {
  const factory _UpdateCartCountEvent({required final BuildContext context}) =
      _$UpdateCartCountEventImpl;

  BuildContext get context;
  @JsonKey(ignore: true)
  _$$UpdateCartCountEventImplCopyWith<_$UpdateCartCountEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NavigateToStoreScreenEventImplCopyWith<$Res> {
  factory _$$NavigateToStoreScreenEventImplCopyWith(
          _$NavigateToStoreScreenEventImpl value,
          $Res Function(_$NavigateToStoreScreenEventImpl) then) =
      __$$NavigateToStoreScreenEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {BuildContext context,
      String storeScreen,
      String profileScreen,
      String basketScreen});
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
    Object? profileScreen = null,
    Object? basketScreen = null,
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
      profileScreen: null == profileScreen
          ? _value.profileScreen
          : profileScreen // ignore: cast_nullable_to_non_nullable
              as String,
      basketScreen: null == basketScreen
          ? _value.basketScreen
          : basketScreen // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NavigateToStoreScreenEventImpl implements _NavigateToStoreScreenEvent {
  const _$NavigateToStoreScreenEventImpl(
      {required this.context,
      required this.storeScreen,
      required this.profileScreen,
      required this.basketScreen});

  @override
  final BuildContext context;
  @override
  final String storeScreen;
  @override
  final String profileScreen;
  @override
  final String basketScreen;

  @override
  String toString() {
    return 'BottomNavEvent.navigateToStoreScreenEvent(context: $context, storeScreen: $storeScreen, profileScreen: $profileScreen, basketScreen: $basketScreen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavigateToStoreScreenEventImpl &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.storeScreen, storeScreen) ||
                other.storeScreen == storeScreen) &&
            (identical(other.profileScreen, profileScreen) ||
                other.profileScreen == profileScreen) &&
            (identical(other.basketScreen, basketScreen) ||
                other.basketScreen == basketScreen));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, context, storeScreen, profileScreen, basketScreen);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NavigateToStoreScreenEventImplCopyWith<_$NavigateToStoreScreenEventImpl>
      get copyWith => __$$NavigateToStoreScreenEventImplCopyWithImpl<
          _$NavigateToStoreScreenEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index, BuildContext context) changePage,
    required TResult Function(BuildContext context) updateCartCountEvent,
    required TResult Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)
        navigateToStoreScreenEvent,
    required TResult Function(BuildContext context)
        seeWalletPermissionUpdateEvent,
    required TResult Function(BuildContext context) getPreferencesDataEvent,
    required TResult Function(bool isOpen) setDialogOpen,
  }) {
    return navigateToStoreScreenEvent(
        context, storeScreen, profileScreen, basketScreen);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index, BuildContext context)? changePage,
    TResult? Function(BuildContext context)? updateCartCountEvent,
    TResult? Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)?
        navigateToStoreScreenEvent,
    TResult? Function(BuildContext context)? seeWalletPermissionUpdateEvent,
    TResult? Function(BuildContext context)? getPreferencesDataEvent,
    TResult? Function(bool isOpen)? setDialogOpen,
  }) {
    return navigateToStoreScreenEvent?.call(
        context, storeScreen, profileScreen, basketScreen);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index, BuildContext context)? changePage,
    TResult Function(BuildContext context)? updateCartCountEvent,
    TResult Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)?
        navigateToStoreScreenEvent,
    TResult Function(BuildContext context)? seeWalletPermissionUpdateEvent,
    TResult Function(BuildContext context)? getPreferencesDataEvent,
    TResult Function(bool isOpen)? setDialogOpen,
    required TResult orElse(),
  }) {
    if (navigateToStoreScreenEvent != null) {
      return navigateToStoreScreenEvent(
          context, storeScreen, profileScreen, basketScreen);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_UpdateCartCountEvent value) updateCartCountEvent,
    required TResult Function(_NavigateToStoreScreenEvent value)
        navigateToStoreScreenEvent,
    required TResult Function(_seeWalletPermissionUpdateEvent value)
        seeWalletPermissionUpdateEvent,
    required TResult Function(_getPreferencesDataEvent value)
        getPreferencesDataEvent,
    required TResult Function(_SetDialogOpenEvent value) setDialogOpen,
  }) {
    return navigateToStoreScreenEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_NavigateToStoreScreenEvent value)?
        navigateToStoreScreenEvent,
    TResult? Function(_seeWalletPermissionUpdateEvent value)?
        seeWalletPermissionUpdateEvent,
    TResult? Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
    TResult? Function(_SetDialogOpenEvent value)? setDialogOpen,
  }) {
    return navigateToStoreScreenEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_NavigateToStoreScreenEvent value)?
        navigateToStoreScreenEvent,
    TResult Function(_seeWalletPermissionUpdateEvent value)?
        seeWalletPermissionUpdateEvent,
    TResult Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
    TResult Function(_SetDialogOpenEvent value)? setDialogOpen,
    required TResult orElse(),
  }) {
    if (navigateToStoreScreenEvent != null) {
      return navigateToStoreScreenEvent(this);
    }
    return orElse();
  }
}

abstract class _NavigateToStoreScreenEvent implements BottomNavEvent {
  const factory _NavigateToStoreScreenEvent(
      {required final BuildContext context,
      required final String storeScreen,
      required final String profileScreen,
      required final String basketScreen}) = _$NavigateToStoreScreenEventImpl;

  BuildContext get context;
  String get storeScreen;
  String get profileScreen;
  String get basketScreen;
  @JsonKey(ignore: true)
  _$$NavigateToStoreScreenEventImplCopyWith<_$NavigateToStoreScreenEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$seeWalletPermissionUpdateEventImplCopyWith<$Res> {
  factory _$$seeWalletPermissionUpdateEventImplCopyWith(
          _$seeWalletPermissionUpdateEventImpl value,
          $Res Function(_$seeWalletPermissionUpdateEventImpl) then) =
      __$$seeWalletPermissionUpdateEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BuildContext context});
}

/// @nodoc
class __$$seeWalletPermissionUpdateEventImplCopyWithImpl<$Res>
    extends _$BottomNavEventCopyWithImpl<$Res,
        _$seeWalletPermissionUpdateEventImpl>
    implements _$$seeWalletPermissionUpdateEventImplCopyWith<$Res> {
  __$$seeWalletPermissionUpdateEventImplCopyWithImpl(
      _$seeWalletPermissionUpdateEventImpl _value,
      $Res Function(_$seeWalletPermissionUpdateEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? context = null,
  }) {
    return _then(_$seeWalletPermissionUpdateEventImpl(
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as BuildContext,
    ));
  }
}

/// @nodoc

class _$seeWalletPermissionUpdateEventImpl
    implements _seeWalletPermissionUpdateEvent {
  const _$seeWalletPermissionUpdateEventImpl({required this.context});

  @override
  final BuildContext context;

  @override
  String toString() {
    return 'BottomNavEvent.seeWalletPermissionUpdateEvent(context: $context)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$seeWalletPermissionUpdateEventImpl &&
            (identical(other.context, context) || other.context == context));
  }

  @override
  int get hashCode => Object.hash(runtimeType, context);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$seeWalletPermissionUpdateEventImplCopyWith<
          _$seeWalletPermissionUpdateEventImpl>
      get copyWith => __$$seeWalletPermissionUpdateEventImplCopyWithImpl<
          _$seeWalletPermissionUpdateEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index, BuildContext context) changePage,
    required TResult Function(BuildContext context) updateCartCountEvent,
    required TResult Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)
        navigateToStoreScreenEvent,
    required TResult Function(BuildContext context)
        seeWalletPermissionUpdateEvent,
    required TResult Function(BuildContext context) getPreferencesDataEvent,
    required TResult Function(bool isOpen) setDialogOpen,
  }) {
    return seeWalletPermissionUpdateEvent(context);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index, BuildContext context)? changePage,
    TResult? Function(BuildContext context)? updateCartCountEvent,
    TResult? Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)?
        navigateToStoreScreenEvent,
    TResult? Function(BuildContext context)? seeWalletPermissionUpdateEvent,
    TResult? Function(BuildContext context)? getPreferencesDataEvent,
    TResult? Function(bool isOpen)? setDialogOpen,
  }) {
    return seeWalletPermissionUpdateEvent?.call(context);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index, BuildContext context)? changePage,
    TResult Function(BuildContext context)? updateCartCountEvent,
    TResult Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)?
        navigateToStoreScreenEvent,
    TResult Function(BuildContext context)? seeWalletPermissionUpdateEvent,
    TResult Function(BuildContext context)? getPreferencesDataEvent,
    TResult Function(bool isOpen)? setDialogOpen,
    required TResult orElse(),
  }) {
    if (seeWalletPermissionUpdateEvent != null) {
      return seeWalletPermissionUpdateEvent(context);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_UpdateCartCountEvent value) updateCartCountEvent,
    required TResult Function(_NavigateToStoreScreenEvent value)
        navigateToStoreScreenEvent,
    required TResult Function(_seeWalletPermissionUpdateEvent value)
        seeWalletPermissionUpdateEvent,
    required TResult Function(_getPreferencesDataEvent value)
        getPreferencesDataEvent,
    required TResult Function(_SetDialogOpenEvent value) setDialogOpen,
  }) {
    return seeWalletPermissionUpdateEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_NavigateToStoreScreenEvent value)?
        navigateToStoreScreenEvent,
    TResult? Function(_seeWalletPermissionUpdateEvent value)?
        seeWalletPermissionUpdateEvent,
    TResult? Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
    TResult? Function(_SetDialogOpenEvent value)? setDialogOpen,
  }) {
    return seeWalletPermissionUpdateEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_NavigateToStoreScreenEvent value)?
        navigateToStoreScreenEvent,
    TResult Function(_seeWalletPermissionUpdateEvent value)?
        seeWalletPermissionUpdateEvent,
    TResult Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
    TResult Function(_SetDialogOpenEvent value)? setDialogOpen,
    required TResult orElse(),
  }) {
    if (seeWalletPermissionUpdateEvent != null) {
      return seeWalletPermissionUpdateEvent(this);
    }
    return orElse();
  }
}

abstract class _seeWalletPermissionUpdateEvent implements BottomNavEvent {
  const factory _seeWalletPermissionUpdateEvent(
          {required final BuildContext context}) =
      _$seeWalletPermissionUpdateEventImpl;

  BuildContext get context;
  @JsonKey(ignore: true)
  _$$seeWalletPermissionUpdateEventImplCopyWith<
          _$seeWalletPermissionUpdateEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$getPreferencesDataEventImplCopyWith<$Res> {
  factory _$$getPreferencesDataEventImplCopyWith(
          _$getPreferencesDataEventImpl value,
          $Res Function(_$getPreferencesDataEventImpl) then) =
      __$$getPreferencesDataEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BuildContext context});
}

/// @nodoc
class __$$getPreferencesDataEventImplCopyWithImpl<$Res>
    extends _$BottomNavEventCopyWithImpl<$Res, _$getPreferencesDataEventImpl>
    implements _$$getPreferencesDataEventImplCopyWith<$Res> {
  __$$getPreferencesDataEventImplCopyWithImpl(
      _$getPreferencesDataEventImpl _value,
      $Res Function(_$getPreferencesDataEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? context = null,
  }) {
    return _then(_$getPreferencesDataEventImpl(
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as BuildContext,
    ));
  }
}

/// @nodoc

class _$getPreferencesDataEventImpl implements _getPreferencesDataEvent {
  const _$getPreferencesDataEventImpl({required this.context});

  @override
  final BuildContext context;

  @override
  String toString() {
    return 'BottomNavEvent.getPreferencesDataEvent(context: $context)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$getPreferencesDataEventImpl &&
            (identical(other.context, context) || other.context == context));
  }

  @override
  int get hashCode => Object.hash(runtimeType, context);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$getPreferencesDataEventImplCopyWith<_$getPreferencesDataEventImpl>
      get copyWith => __$$getPreferencesDataEventImplCopyWithImpl<
          _$getPreferencesDataEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index, BuildContext context) changePage,
    required TResult Function(BuildContext context) updateCartCountEvent,
    required TResult Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)
        navigateToStoreScreenEvent,
    required TResult Function(BuildContext context)
        seeWalletPermissionUpdateEvent,
    required TResult Function(BuildContext context) getPreferencesDataEvent,
    required TResult Function(bool isOpen) setDialogOpen,
  }) {
    return getPreferencesDataEvent(context);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index, BuildContext context)? changePage,
    TResult? Function(BuildContext context)? updateCartCountEvent,
    TResult? Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)?
        navigateToStoreScreenEvent,
    TResult? Function(BuildContext context)? seeWalletPermissionUpdateEvent,
    TResult? Function(BuildContext context)? getPreferencesDataEvent,
    TResult? Function(bool isOpen)? setDialogOpen,
  }) {
    return getPreferencesDataEvent?.call(context);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index, BuildContext context)? changePage,
    TResult Function(BuildContext context)? updateCartCountEvent,
    TResult Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)?
        navigateToStoreScreenEvent,
    TResult Function(BuildContext context)? seeWalletPermissionUpdateEvent,
    TResult Function(BuildContext context)? getPreferencesDataEvent,
    TResult Function(bool isOpen)? setDialogOpen,
    required TResult orElse(),
  }) {
    if (getPreferencesDataEvent != null) {
      return getPreferencesDataEvent(context);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_UpdateCartCountEvent value) updateCartCountEvent,
    required TResult Function(_NavigateToStoreScreenEvent value)
        navigateToStoreScreenEvent,
    required TResult Function(_seeWalletPermissionUpdateEvent value)
        seeWalletPermissionUpdateEvent,
    required TResult Function(_getPreferencesDataEvent value)
        getPreferencesDataEvent,
    required TResult Function(_SetDialogOpenEvent value) setDialogOpen,
  }) {
    return getPreferencesDataEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_NavigateToStoreScreenEvent value)?
        navigateToStoreScreenEvent,
    TResult? Function(_seeWalletPermissionUpdateEvent value)?
        seeWalletPermissionUpdateEvent,
    TResult? Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
    TResult? Function(_SetDialogOpenEvent value)? setDialogOpen,
  }) {
    return getPreferencesDataEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_NavigateToStoreScreenEvent value)?
        navigateToStoreScreenEvent,
    TResult Function(_seeWalletPermissionUpdateEvent value)?
        seeWalletPermissionUpdateEvent,
    TResult Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
    TResult Function(_SetDialogOpenEvent value)? setDialogOpen,
    required TResult orElse(),
  }) {
    if (getPreferencesDataEvent != null) {
      return getPreferencesDataEvent(this);
    }
    return orElse();
  }
}

abstract class _getPreferencesDataEvent implements BottomNavEvent {
  const factory _getPreferencesDataEvent(
      {required final BuildContext context}) = _$getPreferencesDataEventImpl;

  BuildContext get context;
  @JsonKey(ignore: true)
  _$$getPreferencesDataEventImplCopyWith<_$getPreferencesDataEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SetDialogOpenEventImplCopyWith<$Res> {
  factory _$$SetDialogOpenEventImplCopyWith(_$SetDialogOpenEventImpl value,
          $Res Function(_$SetDialogOpenEventImpl) then) =
      __$$SetDialogOpenEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isOpen});
}

/// @nodoc
class __$$SetDialogOpenEventImplCopyWithImpl<$Res>
    extends _$BottomNavEventCopyWithImpl<$Res, _$SetDialogOpenEventImpl>
    implements _$$SetDialogOpenEventImplCopyWith<$Res> {
  __$$SetDialogOpenEventImplCopyWithImpl(_$SetDialogOpenEventImpl _value,
      $Res Function(_$SetDialogOpenEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOpen = null,
  }) {
    return _then(_$SetDialogOpenEventImpl(
      isOpen: null == isOpen
          ? _value.isOpen
          : isOpen // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SetDialogOpenEventImpl implements _SetDialogOpenEvent {
  const _$SetDialogOpenEventImpl({required this.isOpen});

  @override
  final bool isOpen;

  @override
  String toString() {
    return 'BottomNavEvent.setDialogOpen(isOpen: $isOpen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetDialogOpenEventImpl &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isOpen);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SetDialogOpenEventImplCopyWith<_$SetDialogOpenEventImpl> get copyWith =>
      __$$SetDialogOpenEventImplCopyWithImpl<_$SetDialogOpenEventImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index, BuildContext context) changePage,
    required TResult Function(BuildContext context) updateCartCountEvent,
    required TResult Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)
        navigateToStoreScreenEvent,
    required TResult Function(BuildContext context)
        seeWalletPermissionUpdateEvent,
    required TResult Function(BuildContext context) getPreferencesDataEvent,
    required TResult Function(bool isOpen) setDialogOpen,
  }) {
    return setDialogOpen(isOpen);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int index, BuildContext context)? changePage,
    TResult? Function(BuildContext context)? updateCartCountEvent,
    TResult? Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)?
        navigateToStoreScreenEvent,
    TResult? Function(BuildContext context)? seeWalletPermissionUpdateEvent,
    TResult? Function(BuildContext context)? getPreferencesDataEvent,
    TResult? Function(bool isOpen)? setDialogOpen,
  }) {
    return setDialogOpen?.call(isOpen);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index, BuildContext context)? changePage,
    TResult Function(BuildContext context)? updateCartCountEvent,
    TResult Function(BuildContext context, String storeScreen,
            String profileScreen, String basketScreen)?
        navigateToStoreScreenEvent,
    TResult Function(BuildContext context)? seeWalletPermissionUpdateEvent,
    TResult Function(BuildContext context)? getPreferencesDataEvent,
    TResult Function(bool isOpen)? setDialogOpen,
    required TResult orElse(),
  }) {
    if (setDialogOpen != null) {
      return setDialogOpen(isOpen);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangePageEvent value) changePage,
    required TResult Function(_UpdateCartCountEvent value) updateCartCountEvent,
    required TResult Function(_NavigateToStoreScreenEvent value)
        navigateToStoreScreenEvent,
    required TResult Function(_seeWalletPermissionUpdateEvent value)
        seeWalletPermissionUpdateEvent,
    required TResult Function(_getPreferencesDataEvent value)
        getPreferencesDataEvent,
    required TResult Function(_SetDialogOpenEvent value) setDialogOpen,
  }) {
    return setDialogOpen(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangePageEvent value)? changePage,
    TResult? Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult? Function(_NavigateToStoreScreenEvent value)?
        navigateToStoreScreenEvent,
    TResult? Function(_seeWalletPermissionUpdateEvent value)?
        seeWalletPermissionUpdateEvent,
    TResult? Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
    TResult? Function(_SetDialogOpenEvent value)? setDialogOpen,
  }) {
    return setDialogOpen?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangePageEvent value)? changePage,
    TResult Function(_UpdateCartCountEvent value)? updateCartCountEvent,
    TResult Function(_NavigateToStoreScreenEvent value)?
        navigateToStoreScreenEvent,
    TResult Function(_seeWalletPermissionUpdateEvent value)?
        seeWalletPermissionUpdateEvent,
    TResult Function(_getPreferencesDataEvent value)? getPreferencesDataEvent,
    TResult Function(_SetDialogOpenEvent value)? setDialogOpen,
    required TResult orElse(),
  }) {
    if (setDialogOpen != null) {
      return setDialogOpen(this);
    }
    return orElse();
  }
}

abstract class _SetDialogOpenEvent implements BottomNavEvent {
  const factory _SetDialogOpenEvent({required final bool isOpen}) =
      _$SetDialogOpenEventImpl;

  bool get isOpen;
  @JsonKey(ignore: true)
  _$$SetDialogOpenEventImplCopyWith<_$SetDialogOpenEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
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
  String get arg => throw _privateConstructorUsedError;
  bool get isSubUserSeeWallet => throw _privateConstructorUsedError;
  bool get isRefreshing => throw _privateConstructorUsedError;
  List<BottomNavModel> get navList => throw _privateConstructorUsedError;

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
      bool isGuestUser,
      String arg,
      bool isSubUserSeeWallet,
      bool isRefreshing,
      List<BottomNavModel> navList});
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
    Object? arg = null,
    Object? isSubUserSeeWallet = null,
    Object? isRefreshing = null,
    Object? navList = null,
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
      arg: null == arg
          ? _value.arg
          : arg // ignore: cast_nullable_to_non_nullable
              as String,
      isSubUserSeeWallet: null == isSubUserSeeWallet
          ? _value.isSubUserSeeWallet
          : isSubUserSeeWallet // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      navList: null == navList
          ? _value.navList
          : navList // ignore: cast_nullable_to_non_nullable
              as List<BottomNavModel>,
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
      bool isGuestUser,
      String arg,
      bool isSubUserSeeWallet,
      bool isRefreshing,
      List<BottomNavModel> navList});
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
    Object? arg = null,
    Object? isSubUserSeeWallet = null,
    Object? isRefreshing = null,
    Object? navList = null,
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
      arg: null == arg
          ? _value.arg
          : arg // ignore: cast_nullable_to_non_nullable
              as String,
      isSubUserSeeWallet: null == isSubUserSeeWallet
          ? _value.isSubUserSeeWallet
          : isSubUserSeeWallet // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      navList: null == navList
          ? _value._navList
          : navList // ignore: cast_nullable_to_non_nullable
              as List<BottomNavModel>,
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
      required this.isGuestUser,
      required this.arg,
      required this.isSubUserSeeWallet,
      required this.isRefreshing,
      required final List<BottomNavModel> navList})
      : _navList = navList;

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
  final String arg;
  @override
  final bool isSubUserSeeWallet;
  @override
  final bool isRefreshing;
  final List<BottomNavModel> _navList;
  @override
  List<BottomNavModel> get navList {
    if (_navList is EqualUnmodifiableListView) return _navList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_navList);
  }

  @override
  String toString() {
    return 'BottomNavState(index: $index, cartCount: $cartCount, isAnimation: $isAnimation, pushNotificationPath: $pushNotificationPath, duringCelebration: $duringCelebration, isStoreScreen: $isStoreScreen, isGuestUser: $isGuestUser, arg: $arg, isSubUserSeeWallet: $isSubUserSeeWallet, isRefreshing: $isRefreshing, navList: $navList)';
  }

  @override
  bool operator ==(Object other) {
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
                other.isGuestUser == isGuestUser) &&
            (identical(other.arg, arg) || other.arg == arg) &&
            (identical(other.isSubUserSeeWallet, isSubUserSeeWallet) ||
                other.isSubUserSeeWallet == isSubUserSeeWallet) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            const DeepCollectionEquality().equals(other._navList, _navList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      index,
      cartCount,
      isAnimation,
      pushNotificationPath,
      duringCelebration,
      isStoreScreen,
      isGuestUser,
      arg,
      isSubUserSeeWallet,
      isRefreshing,
      const DeepCollectionEquality().hash(_navList));

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
      required final bool isGuestUser,
      required final String arg,
      required final bool isSubUserSeeWallet,
      required final bool isRefreshing,
      required final List<BottomNavModel> navList}) = _$BottomNavStateImpl;

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
  String get arg;
  @override
  bool get isSubUserSeeWallet;
  @override
  bool get isRefreshing;
  @override
  List<BottomNavModel> get navList;
  @override
  @JsonKey(ignore: true)
  _$$BottomNavStateImplCopyWith<_$BottomNavStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
