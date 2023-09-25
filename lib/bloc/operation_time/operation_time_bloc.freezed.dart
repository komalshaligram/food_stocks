// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'operation_time_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$OperationTimeEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() dropDownEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? dropDownEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? dropDownEvent,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_dropDownEvent value) dropDownEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_dropDownEvent value)? dropDownEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_dropDownEvent value)? dropDownEvent,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OperationTimeEventCopyWith<$Res> {
  factory $OperationTimeEventCopyWith(
          OperationTimeEvent value, $Res Function(OperationTimeEvent) then) =
      _$OperationTimeEventCopyWithImpl<$Res, OperationTimeEvent>;
}

/// @nodoc
class _$OperationTimeEventCopyWithImpl<$Res, $Val extends OperationTimeEvent>
    implements $OperationTimeEventCopyWith<$Res> {
  _$OperationTimeEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_dropDownEventCopyWith<$Res> {
  factory _$$_dropDownEventCopyWith(
          _$_dropDownEvent value, $Res Function(_$_dropDownEvent) then) =
      __$$_dropDownEventCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_dropDownEventCopyWithImpl<$Res>
    extends _$OperationTimeEventCopyWithImpl<$Res, _$_dropDownEvent>
    implements _$$_dropDownEventCopyWith<$Res> {
  __$$_dropDownEventCopyWithImpl(
      _$_dropDownEvent _value, $Res Function(_$_dropDownEvent) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_dropDownEvent implements _dropDownEvent {
  _$_dropDownEvent();

  @override
  String toString() {
    return 'OperationTimeEvent.dropDownEvent()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_dropDownEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() dropDownEvent,
  }) {
    return dropDownEvent();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? dropDownEvent,
  }) {
    return dropDownEvent?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? dropDownEvent,
    required TResult orElse(),
  }) {
    if (dropDownEvent != null) {
      return dropDownEvent();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_dropDownEvent value) dropDownEvent,
  }) {
    return dropDownEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_dropDownEvent value)? dropDownEvent,
  }) {
    return dropDownEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_dropDownEvent value)? dropDownEvent,
    required TResult orElse(),
  }) {
    if (dropDownEvent != null) {
      return dropDownEvent(this);
    }
    return orElse();
  }
}

abstract class _dropDownEvent implements OperationTimeEvent {
  factory _dropDownEvent() = _$_dropDownEvent;
}

/// @nodoc
mixin _$OperationTimeState {
  String? get selectCity => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OperationTimeStateCopyWith<OperationTimeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OperationTimeStateCopyWith<$Res> {
  factory $OperationTimeStateCopyWith(
          OperationTimeState value, $Res Function(OperationTimeState) then) =
      _$OperationTimeStateCopyWithImpl<$Res, OperationTimeState>;
  @useResult
  $Res call({String? selectCity});
}

/// @nodoc
class _$OperationTimeStateCopyWithImpl<$Res, $Val extends OperationTimeState>
    implements $OperationTimeStateCopyWith<$Res> {
  _$OperationTimeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectCity = freezed,
  }) {
    return _then(_value.copyWith(
      selectCity: freezed == selectCity
          ? _value.selectCity
          : selectCity // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_OperationTimeStateCopyWith<$Res>
    implements $OperationTimeStateCopyWith<$Res> {
  factory _$$_OperationTimeStateCopyWith(_$_OperationTimeState value,
          $Res Function(_$_OperationTimeState) then) =
      __$$_OperationTimeStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? selectCity});
}

/// @nodoc
class __$$_OperationTimeStateCopyWithImpl<$Res>
    extends _$OperationTimeStateCopyWithImpl<$Res, _$_OperationTimeState>
    implements _$$_OperationTimeStateCopyWith<$Res> {
  __$$_OperationTimeStateCopyWithImpl(
      _$_OperationTimeState _value, $Res Function(_$_OperationTimeState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectCity = freezed,
  }) {
    return _then(_$_OperationTimeState(
      selectCity: freezed == selectCity
          ? _value.selectCity
          : selectCity // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_OperationTimeState implements _OperationTimeState {
  const _$_OperationTimeState({required this.selectCity});

  @override
  final String? selectCity;

  @override
  String toString() {
    return 'OperationTimeState(selectCity: $selectCity)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_OperationTimeState &&
            (identical(other.selectCity, selectCity) ||
                other.selectCity == selectCity));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectCity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_OperationTimeStateCopyWith<_$_OperationTimeState> get copyWith =>
      __$$_OperationTimeStateCopyWithImpl<_$_OperationTimeState>(
          this, _$identity);
}

abstract class _OperationTimeState implements OperationTimeState {
  const factory _OperationTimeState({required final String? selectCity}) =
      _$_OperationTimeState;

  @override
  String? get selectCity;
  @override
  @JsonKey(ignore: true)
  _$$_OperationTimeStateCopyWith<_$_OperationTimeState> get copyWith =>
      throw _privateConstructorUsedError;
}
