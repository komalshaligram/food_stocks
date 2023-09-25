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
  BuildContext get context => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BuildContext context) timePickerEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BuildContext context)? timePickerEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuildContext context)? timePickerEvent,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_timePickerEvent value) timePickerEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_timePickerEvent value)? timePickerEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_timePickerEvent value)? timePickerEvent,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OperationTimeEventCopyWith<OperationTimeEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OperationTimeEventCopyWith<$Res> {
  factory $OperationTimeEventCopyWith(
          OperationTimeEvent value, $Res Function(OperationTimeEvent) then) =
      _$OperationTimeEventCopyWithImpl<$Res, OperationTimeEvent>;
  @useResult
  $Res call({BuildContext context});
}

/// @nodoc
class _$OperationTimeEventCopyWithImpl<$Res, $Val extends OperationTimeEvent>
    implements $OperationTimeEventCopyWith<$Res> {
  _$OperationTimeEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? context = null,
  }) {
    return _then(_value.copyWith(
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as BuildContext,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_timePickerEventCopyWith<$Res>
    implements $OperationTimeEventCopyWith<$Res> {
  factory _$$_timePickerEventCopyWith(
          _$_timePickerEvent value, $Res Function(_$_timePickerEvent) then) =
      __$$_timePickerEventCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({BuildContext context});
}

/// @nodoc
class __$$_timePickerEventCopyWithImpl<$Res>
    extends _$OperationTimeEventCopyWithImpl<$Res, _$_timePickerEvent>
    implements _$$_timePickerEventCopyWith<$Res> {
  __$$_timePickerEventCopyWithImpl(
      _$_timePickerEvent _value, $Res Function(_$_timePickerEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? context = null,
  }) {
    return _then(_$_timePickerEvent(
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as BuildContext,
    ));
  }
}

/// @nodoc

class _$_timePickerEvent implements _timePickerEvent {
  _$_timePickerEvent({required this.context});

  @override
  final BuildContext context;

  @override
  String toString() {
    return 'OperationTimeEvent.timePickerEvent(context: $context)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_timePickerEvent &&
            (identical(other.context, context) || other.context == context));
  }

  @override
  int get hashCode => Object.hash(runtimeType, context);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_timePickerEventCopyWith<_$_timePickerEvent> get copyWith =>
      __$$_timePickerEventCopyWithImpl<_$_timePickerEvent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BuildContext context) timePickerEvent,
  }) {
    return timePickerEvent(context);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BuildContext context)? timePickerEvent,
  }) {
    return timePickerEvent?.call(context);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuildContext context)? timePickerEvent,
    required TResult orElse(),
  }) {
    if (timePickerEvent != null) {
      return timePickerEvent(context);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_timePickerEvent value) timePickerEvent,
  }) {
    return timePickerEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_timePickerEvent value)? timePickerEvent,
  }) {
    return timePickerEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_timePickerEvent value)? timePickerEvent,
    required TResult orElse(),
  }) {
    if (timePickerEvent != null) {
      return timePickerEvent(this);
    }
    return orElse();
  }
}

abstract class _timePickerEvent implements OperationTimeEvent {
  factory _timePickerEvent({required final BuildContext context}) =
      _$_timePickerEvent;

  @override
  BuildContext get context;
  @override
  @JsonKey(ignore: true)
  _$$_timePickerEventCopyWith<_$_timePickerEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OperationTimeState {
  String get time => throw _privateConstructorUsedError;

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
  $Res call({String time});
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
    Object? time = null,
  }) {
    return _then(_value.copyWith(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
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
  $Res call({String time});
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
    Object? time = null,
  }) {
    return _then(_$_OperationTimeState(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_OperationTimeState implements _OperationTimeState {
  const _$_OperationTimeState({required this.time});

  @override
  final String time;

  @override
  String toString() {
    return 'OperationTimeState(time: $time)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_OperationTimeState &&
            (identical(other.time, time) || other.time == time));
  }

  @override
  int get hashCode => Object.hash(runtimeType, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_OperationTimeStateCopyWith<_$_OperationTimeState> get copyWith =>
      __$$_OperationTimeStateCopyWithImpl<_$_OperationTimeState>(
          this, _$identity);
}

abstract class _OperationTimeState implements OperationTimeState {
  const factory _OperationTimeState({required final String time}) =
      _$_OperationTimeState;

  @override
  String get time;
  @override
  @JsonKey(ignore: true)
  _$$_OperationTimeStateCopyWith<_$_OperationTimeState> get copyWith =>
      throw _privateConstructorUsedError;
}
