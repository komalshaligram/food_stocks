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
    required TResult Function(BuildContext context, int openingIndex,
            int rowIndex, int timeIndex, String time)
        timePickerEvent,
    required TResult Function() defaultValueAddInListEvent,
    required TResult Function(int rowIndex) addMoreTimeZoneEvent,
    required TResult Function(int rowIndex, int timeIndex) deleteTimeZoneEvent,
    required TResult Function(ProfileModel profileModel) getProfileModelEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BuildContext context, int openingIndex, int rowIndex,
            int timeIndex, String time)?
        timePickerEvent,
    TResult? Function()? defaultValueAddInListEvent,
    TResult? Function(int rowIndex)? addMoreTimeZoneEvent,
    TResult? Function(int rowIndex, int timeIndex)? deleteTimeZoneEvent,
    TResult? Function(ProfileModel profileModel)? getProfileModelEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuildContext context, int openingIndex, int rowIndex,
            int timeIndex, String time)?
        timePickerEvent,
    TResult Function()? defaultValueAddInListEvent,
    TResult Function(int rowIndex)? addMoreTimeZoneEvent,
    TResult Function(int rowIndex, int timeIndex)? deleteTimeZoneEvent,
    TResult Function(ProfileModel profileModel)? getProfileModelEvent,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_timePickerEvent value) timePickerEvent,
    required TResult Function(_defaultValueAddInListEvent value)
        defaultValueAddInListEvent,
    required TResult Function(_addMoreTimeZoneEventEvent value)
        addMoreTimeZoneEvent,
    required TResult Function(_deleteTimeZoneEvent value) deleteTimeZoneEvent,
    required TResult Function(_getProfileModelEvent value) getProfileModelEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_timePickerEvent value)? timePickerEvent,
    TResult? Function(_defaultValueAddInListEvent value)?
        defaultValueAddInListEvent,
    TResult? Function(_addMoreTimeZoneEventEvent value)? addMoreTimeZoneEvent,
    TResult? Function(_deleteTimeZoneEvent value)? deleteTimeZoneEvent,
    TResult? Function(_getProfileModelEvent value)? getProfileModelEvent,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_timePickerEvent value)? timePickerEvent,
    TResult Function(_defaultValueAddInListEvent value)?
        defaultValueAddInListEvent,
    TResult Function(_addMoreTimeZoneEventEvent value)? addMoreTimeZoneEvent,
    TResult Function(_deleteTimeZoneEvent value)? deleteTimeZoneEvent,
    TResult Function(_getProfileModelEvent value)? getProfileModelEvent,
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
abstract class _$$_timePickerEventCopyWith<$Res> {
  factory _$$_timePickerEventCopyWith(
          _$_timePickerEvent value, $Res Function(_$_timePickerEvent) then) =
      __$$_timePickerEventCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {BuildContext context,
      int openingIndex,
      int rowIndex,
      int timeIndex,
      String time});
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
    Object? openingIndex = null,
    Object? rowIndex = null,
    Object? timeIndex = null,
    Object? time = null,
  }) {
    return _then(_$_timePickerEvent(
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as BuildContext,
      openingIndex: null == openingIndex
          ? _value.openingIndex
          : openingIndex // ignore: cast_nullable_to_non_nullable
              as int,
      rowIndex: null == rowIndex
          ? _value.rowIndex
          : rowIndex // ignore: cast_nullable_to_non_nullable
              as int,
      timeIndex: null == timeIndex
          ? _value.timeIndex
          : timeIndex // ignore: cast_nullable_to_non_nullable
              as int,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_timePickerEvent implements _timePickerEvent {
  _$_timePickerEvent(
      {required this.context,
      required this.openingIndex,
      required this.rowIndex,
      required this.timeIndex,
      required this.time});

  @override
  final BuildContext context;
  @override
  final int openingIndex;
  @override
  final int rowIndex;
  @override
  final int timeIndex;
  @override
  final String time;

  @override
  String toString() {
    return 'OperationTimeEvent.timePickerEvent(context: $context, openingIndex: $openingIndex, rowIndex: $rowIndex, timeIndex: $timeIndex, time: $time)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_timePickerEvent &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.openingIndex, openingIndex) ||
                other.openingIndex == openingIndex) &&
            (identical(other.rowIndex, rowIndex) ||
                other.rowIndex == rowIndex) &&
            (identical(other.timeIndex, timeIndex) ||
                other.timeIndex == timeIndex) &&
            (identical(other.time, time) || other.time == time));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, context, openingIndex, rowIndex, timeIndex, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_timePickerEventCopyWith<_$_timePickerEvent> get copyWith =>
      __$$_timePickerEventCopyWithImpl<_$_timePickerEvent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BuildContext context, int openingIndex,
            int rowIndex, int timeIndex, String time)
        timePickerEvent,
    required TResult Function() defaultValueAddInListEvent,
    required TResult Function(int rowIndex) addMoreTimeZoneEvent,
    required TResult Function(int rowIndex, int timeIndex) deleteTimeZoneEvent,
    required TResult Function(ProfileModel profileModel) getProfileModelEvent,
  }) {
    return timePickerEvent(context, openingIndex, rowIndex, timeIndex, time);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BuildContext context, int openingIndex, int rowIndex,
            int timeIndex, String time)?
        timePickerEvent,
    TResult? Function()? defaultValueAddInListEvent,
    TResult? Function(int rowIndex)? addMoreTimeZoneEvent,
    TResult? Function(int rowIndex, int timeIndex)? deleteTimeZoneEvent,
    TResult? Function(ProfileModel profileModel)? getProfileModelEvent,
  }) {
    return timePickerEvent?.call(
        context, openingIndex, rowIndex, timeIndex, time);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuildContext context, int openingIndex, int rowIndex,
            int timeIndex, String time)?
        timePickerEvent,
    TResult Function()? defaultValueAddInListEvent,
    TResult Function(int rowIndex)? addMoreTimeZoneEvent,
    TResult Function(int rowIndex, int timeIndex)? deleteTimeZoneEvent,
    TResult Function(ProfileModel profileModel)? getProfileModelEvent,
    required TResult orElse(),
  }) {
    if (timePickerEvent != null) {
      return timePickerEvent(context, openingIndex, rowIndex, timeIndex, time);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_timePickerEvent value) timePickerEvent,
    required TResult Function(_defaultValueAddInListEvent value)
        defaultValueAddInListEvent,
    required TResult Function(_addMoreTimeZoneEventEvent value)
        addMoreTimeZoneEvent,
    required TResult Function(_deleteTimeZoneEvent value) deleteTimeZoneEvent,
    required TResult Function(_getProfileModelEvent value) getProfileModelEvent,
  }) {
    return timePickerEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_timePickerEvent value)? timePickerEvent,
    TResult? Function(_defaultValueAddInListEvent value)?
        defaultValueAddInListEvent,
    TResult? Function(_addMoreTimeZoneEventEvent value)? addMoreTimeZoneEvent,
    TResult? Function(_deleteTimeZoneEvent value)? deleteTimeZoneEvent,
    TResult? Function(_getProfileModelEvent value)? getProfileModelEvent,
  }) {
    return timePickerEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_timePickerEvent value)? timePickerEvent,
    TResult Function(_defaultValueAddInListEvent value)?
        defaultValueAddInListEvent,
    TResult Function(_addMoreTimeZoneEventEvent value)? addMoreTimeZoneEvent,
    TResult Function(_deleteTimeZoneEvent value)? deleteTimeZoneEvent,
    TResult Function(_getProfileModelEvent value)? getProfileModelEvent,
    required TResult orElse(),
  }) {
    if (timePickerEvent != null) {
      return timePickerEvent(this);
    }
    return orElse();
  }
}

abstract class _timePickerEvent implements OperationTimeEvent {
  factory _timePickerEvent(
      {required final BuildContext context,
      required final int openingIndex,
      required final int rowIndex,
      required final int timeIndex,
      required final String time}) = _$_timePickerEvent;

  BuildContext get context;
  int get openingIndex;
  int get rowIndex;
  int get timeIndex;
  String get time;
  @JsonKey(ignore: true)
  _$$_timePickerEventCopyWith<_$_timePickerEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_defaultValueAddInListEventCopyWith<$Res> {
  factory _$$_defaultValueAddInListEventCopyWith(
          _$_defaultValueAddInListEvent value,
          $Res Function(_$_defaultValueAddInListEvent) then) =
      __$$_defaultValueAddInListEventCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_defaultValueAddInListEventCopyWithImpl<$Res>
    extends _$OperationTimeEventCopyWithImpl<$Res,
        _$_defaultValueAddInListEvent>
    implements _$$_defaultValueAddInListEventCopyWith<$Res> {
  __$$_defaultValueAddInListEventCopyWithImpl(
      _$_defaultValueAddInListEvent _value,
      $Res Function(_$_defaultValueAddInListEvent) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_defaultValueAddInListEvent implements _defaultValueAddInListEvent {
  _$_defaultValueAddInListEvent();

  @override
  String toString() {
    return 'OperationTimeEvent.defaultValueAddInListEvent()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_defaultValueAddInListEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BuildContext context, int openingIndex,
            int rowIndex, int timeIndex, String time)
        timePickerEvent,
    required TResult Function() defaultValueAddInListEvent,
    required TResult Function(int rowIndex) addMoreTimeZoneEvent,
    required TResult Function(int rowIndex, int timeIndex) deleteTimeZoneEvent,
    required TResult Function(ProfileModel profileModel) getProfileModelEvent,
  }) {
    return defaultValueAddInListEvent();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BuildContext context, int openingIndex, int rowIndex,
            int timeIndex, String time)?
        timePickerEvent,
    TResult? Function()? defaultValueAddInListEvent,
    TResult? Function(int rowIndex)? addMoreTimeZoneEvent,
    TResult? Function(int rowIndex, int timeIndex)? deleteTimeZoneEvent,
    TResult? Function(ProfileModel profileModel)? getProfileModelEvent,
  }) {
    return defaultValueAddInListEvent?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuildContext context, int openingIndex, int rowIndex,
            int timeIndex, String time)?
        timePickerEvent,
    TResult Function()? defaultValueAddInListEvent,
    TResult Function(int rowIndex)? addMoreTimeZoneEvent,
    TResult Function(int rowIndex, int timeIndex)? deleteTimeZoneEvent,
    TResult Function(ProfileModel profileModel)? getProfileModelEvent,
    required TResult orElse(),
  }) {
    if (defaultValueAddInListEvent != null) {
      return defaultValueAddInListEvent();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_timePickerEvent value) timePickerEvent,
    required TResult Function(_defaultValueAddInListEvent value)
        defaultValueAddInListEvent,
    required TResult Function(_addMoreTimeZoneEventEvent value)
        addMoreTimeZoneEvent,
    required TResult Function(_deleteTimeZoneEvent value) deleteTimeZoneEvent,
    required TResult Function(_getProfileModelEvent value) getProfileModelEvent,
  }) {
    return defaultValueAddInListEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_timePickerEvent value)? timePickerEvent,
    TResult? Function(_defaultValueAddInListEvent value)?
        defaultValueAddInListEvent,
    TResult? Function(_addMoreTimeZoneEventEvent value)? addMoreTimeZoneEvent,
    TResult? Function(_deleteTimeZoneEvent value)? deleteTimeZoneEvent,
    TResult? Function(_getProfileModelEvent value)? getProfileModelEvent,
  }) {
    return defaultValueAddInListEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_timePickerEvent value)? timePickerEvent,
    TResult Function(_defaultValueAddInListEvent value)?
        defaultValueAddInListEvent,
    TResult Function(_addMoreTimeZoneEventEvent value)? addMoreTimeZoneEvent,
    TResult Function(_deleteTimeZoneEvent value)? deleteTimeZoneEvent,
    TResult Function(_getProfileModelEvent value)? getProfileModelEvent,
    required TResult orElse(),
  }) {
    if (defaultValueAddInListEvent != null) {
      return defaultValueAddInListEvent(this);
    }
    return orElse();
  }
}

abstract class _defaultValueAddInListEvent implements OperationTimeEvent {
  factory _defaultValueAddInListEvent() = _$_defaultValueAddInListEvent;
}

/// @nodoc
abstract class _$$_addMoreTimeZoneEventEventCopyWith<$Res> {
  factory _$$_addMoreTimeZoneEventEventCopyWith(
          _$_addMoreTimeZoneEventEvent value,
          $Res Function(_$_addMoreTimeZoneEventEvent) then) =
      __$$_addMoreTimeZoneEventEventCopyWithImpl<$Res>;
  @useResult
  $Res call({int rowIndex});
}

/// @nodoc
class __$$_addMoreTimeZoneEventEventCopyWithImpl<$Res>
    extends _$OperationTimeEventCopyWithImpl<$Res, _$_addMoreTimeZoneEventEvent>
    implements _$$_addMoreTimeZoneEventEventCopyWith<$Res> {
  __$$_addMoreTimeZoneEventEventCopyWithImpl(
      _$_addMoreTimeZoneEventEvent _value,
      $Res Function(_$_addMoreTimeZoneEventEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rowIndex = null,
  }) {
    return _then(_$_addMoreTimeZoneEventEvent(
      rowIndex: null == rowIndex
          ? _value.rowIndex
          : rowIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_addMoreTimeZoneEventEvent implements _addMoreTimeZoneEventEvent {
  _$_addMoreTimeZoneEventEvent({required this.rowIndex});

  @override
  final int rowIndex;

  @override
  String toString() {
    return 'OperationTimeEvent.addMoreTimeZoneEvent(rowIndex: $rowIndex)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_addMoreTimeZoneEventEvent &&
            (identical(other.rowIndex, rowIndex) ||
                other.rowIndex == rowIndex));
  }

  @override
  int get hashCode => Object.hash(runtimeType, rowIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_addMoreTimeZoneEventEventCopyWith<_$_addMoreTimeZoneEventEvent>
      get copyWith => __$$_addMoreTimeZoneEventEventCopyWithImpl<
          _$_addMoreTimeZoneEventEvent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BuildContext context, int openingIndex,
            int rowIndex, int timeIndex, String time)
        timePickerEvent,
    required TResult Function() defaultValueAddInListEvent,
    required TResult Function(int rowIndex) addMoreTimeZoneEvent,
    required TResult Function(int rowIndex, int timeIndex) deleteTimeZoneEvent,
    required TResult Function(ProfileModel profileModel) getProfileModelEvent,
  }) {
    return addMoreTimeZoneEvent(rowIndex);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BuildContext context, int openingIndex, int rowIndex,
            int timeIndex, String time)?
        timePickerEvent,
    TResult? Function()? defaultValueAddInListEvent,
    TResult? Function(int rowIndex)? addMoreTimeZoneEvent,
    TResult? Function(int rowIndex, int timeIndex)? deleteTimeZoneEvent,
    TResult? Function(ProfileModel profileModel)? getProfileModelEvent,
  }) {
    return addMoreTimeZoneEvent?.call(rowIndex);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuildContext context, int openingIndex, int rowIndex,
            int timeIndex, String time)?
        timePickerEvent,
    TResult Function()? defaultValueAddInListEvent,
    TResult Function(int rowIndex)? addMoreTimeZoneEvent,
    TResult Function(int rowIndex, int timeIndex)? deleteTimeZoneEvent,
    TResult Function(ProfileModel profileModel)? getProfileModelEvent,
    required TResult orElse(),
  }) {
    if (addMoreTimeZoneEvent != null) {
      return addMoreTimeZoneEvent(rowIndex);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_timePickerEvent value) timePickerEvent,
    required TResult Function(_defaultValueAddInListEvent value)
        defaultValueAddInListEvent,
    required TResult Function(_addMoreTimeZoneEventEvent value)
        addMoreTimeZoneEvent,
    required TResult Function(_deleteTimeZoneEvent value) deleteTimeZoneEvent,
    required TResult Function(_getProfileModelEvent value) getProfileModelEvent,
  }) {
    return addMoreTimeZoneEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_timePickerEvent value)? timePickerEvent,
    TResult? Function(_defaultValueAddInListEvent value)?
        defaultValueAddInListEvent,
    TResult? Function(_addMoreTimeZoneEventEvent value)? addMoreTimeZoneEvent,
    TResult? Function(_deleteTimeZoneEvent value)? deleteTimeZoneEvent,
    TResult? Function(_getProfileModelEvent value)? getProfileModelEvent,
  }) {
    return addMoreTimeZoneEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_timePickerEvent value)? timePickerEvent,
    TResult Function(_defaultValueAddInListEvent value)?
        defaultValueAddInListEvent,
    TResult Function(_addMoreTimeZoneEventEvent value)? addMoreTimeZoneEvent,
    TResult Function(_deleteTimeZoneEvent value)? deleteTimeZoneEvent,
    TResult Function(_getProfileModelEvent value)? getProfileModelEvent,
    required TResult orElse(),
  }) {
    if (addMoreTimeZoneEvent != null) {
      return addMoreTimeZoneEvent(this);
    }
    return orElse();
  }
}

abstract class _addMoreTimeZoneEventEvent implements OperationTimeEvent {
  factory _addMoreTimeZoneEventEvent({required final int rowIndex}) =
      _$_addMoreTimeZoneEventEvent;

  int get rowIndex;
  @JsonKey(ignore: true)
  _$$_addMoreTimeZoneEventEventCopyWith<_$_addMoreTimeZoneEventEvent>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_deleteTimeZoneEventCopyWith<$Res> {
  factory _$$_deleteTimeZoneEventCopyWith(_$_deleteTimeZoneEvent value,
          $Res Function(_$_deleteTimeZoneEvent) then) =
      __$$_deleteTimeZoneEventCopyWithImpl<$Res>;
  @useResult
  $Res call({int rowIndex, int timeIndex});
}

/// @nodoc
class __$$_deleteTimeZoneEventCopyWithImpl<$Res>
    extends _$OperationTimeEventCopyWithImpl<$Res, _$_deleteTimeZoneEvent>
    implements _$$_deleteTimeZoneEventCopyWith<$Res> {
  __$$_deleteTimeZoneEventCopyWithImpl(_$_deleteTimeZoneEvent _value,
      $Res Function(_$_deleteTimeZoneEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rowIndex = null,
    Object? timeIndex = null,
  }) {
    return _then(_$_deleteTimeZoneEvent(
      rowIndex: null == rowIndex
          ? _value.rowIndex
          : rowIndex // ignore: cast_nullable_to_non_nullable
              as int,
      timeIndex: null == timeIndex
          ? _value.timeIndex
          : timeIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_deleteTimeZoneEvent implements _deleteTimeZoneEvent {
  _$_deleteTimeZoneEvent({required this.rowIndex, required this.timeIndex});

  @override
  final int rowIndex;
  @override
  final int timeIndex;

  @override
  String toString() {
    return 'OperationTimeEvent.deleteTimeZoneEvent(rowIndex: $rowIndex, timeIndex: $timeIndex)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_deleteTimeZoneEvent &&
            (identical(other.rowIndex, rowIndex) ||
                other.rowIndex == rowIndex) &&
            (identical(other.timeIndex, timeIndex) ||
                other.timeIndex == timeIndex));
  }

  @override
  int get hashCode => Object.hash(runtimeType, rowIndex, timeIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_deleteTimeZoneEventCopyWith<_$_deleteTimeZoneEvent> get copyWith =>
      __$$_deleteTimeZoneEventCopyWithImpl<_$_deleteTimeZoneEvent>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BuildContext context, int openingIndex,
            int rowIndex, int timeIndex, String time)
        timePickerEvent,
    required TResult Function() defaultValueAddInListEvent,
    required TResult Function(int rowIndex) addMoreTimeZoneEvent,
    required TResult Function(int rowIndex, int timeIndex) deleteTimeZoneEvent,
    required TResult Function(ProfileModel profileModel) getProfileModelEvent,
  }) {
    return deleteTimeZoneEvent(rowIndex, timeIndex);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BuildContext context, int openingIndex, int rowIndex,
            int timeIndex, String time)?
        timePickerEvent,
    TResult? Function()? defaultValueAddInListEvent,
    TResult? Function(int rowIndex)? addMoreTimeZoneEvent,
    TResult? Function(int rowIndex, int timeIndex)? deleteTimeZoneEvent,
    TResult? Function(ProfileModel profileModel)? getProfileModelEvent,
  }) {
    return deleteTimeZoneEvent?.call(rowIndex, timeIndex);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuildContext context, int openingIndex, int rowIndex,
            int timeIndex, String time)?
        timePickerEvent,
    TResult Function()? defaultValueAddInListEvent,
    TResult Function(int rowIndex)? addMoreTimeZoneEvent,
    TResult Function(int rowIndex, int timeIndex)? deleteTimeZoneEvent,
    TResult Function(ProfileModel profileModel)? getProfileModelEvent,
    required TResult orElse(),
  }) {
    if (deleteTimeZoneEvent != null) {
      return deleteTimeZoneEvent(rowIndex, timeIndex);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_timePickerEvent value) timePickerEvent,
    required TResult Function(_defaultValueAddInListEvent value)
        defaultValueAddInListEvent,
    required TResult Function(_addMoreTimeZoneEventEvent value)
        addMoreTimeZoneEvent,
    required TResult Function(_deleteTimeZoneEvent value) deleteTimeZoneEvent,
    required TResult Function(_getProfileModelEvent value) getProfileModelEvent,
  }) {
    return deleteTimeZoneEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_timePickerEvent value)? timePickerEvent,
    TResult? Function(_defaultValueAddInListEvent value)?
        defaultValueAddInListEvent,
    TResult? Function(_addMoreTimeZoneEventEvent value)? addMoreTimeZoneEvent,
    TResult? Function(_deleteTimeZoneEvent value)? deleteTimeZoneEvent,
    TResult? Function(_getProfileModelEvent value)? getProfileModelEvent,
  }) {
    return deleteTimeZoneEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_timePickerEvent value)? timePickerEvent,
    TResult Function(_defaultValueAddInListEvent value)?
        defaultValueAddInListEvent,
    TResult Function(_addMoreTimeZoneEventEvent value)? addMoreTimeZoneEvent,
    TResult Function(_deleteTimeZoneEvent value)? deleteTimeZoneEvent,
    TResult Function(_getProfileModelEvent value)? getProfileModelEvent,
    required TResult orElse(),
  }) {
    if (deleteTimeZoneEvent != null) {
      return deleteTimeZoneEvent(this);
    }
    return orElse();
  }
}

abstract class _deleteTimeZoneEvent implements OperationTimeEvent {
  factory _deleteTimeZoneEvent(
      {required final int rowIndex,
      required final int timeIndex}) = _$_deleteTimeZoneEvent;

  int get rowIndex;
  int get timeIndex;
  @JsonKey(ignore: true)
  _$$_deleteTimeZoneEventCopyWith<_$_deleteTimeZoneEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_getProfileModelEventCopyWith<$Res> {
  factory _$$_getProfileModelEventCopyWith(_$_getProfileModelEvent value,
          $Res Function(_$_getProfileModelEvent) then) =
      __$$_getProfileModelEventCopyWithImpl<$Res>;
  @useResult
  $Res call({ProfileModel profileModel});

  $ProfileModelCopyWith<$Res> get profileModel;
}

/// @nodoc
class __$$_getProfileModelEventCopyWithImpl<$Res>
    extends _$OperationTimeEventCopyWithImpl<$Res, _$_getProfileModelEvent>
    implements _$$_getProfileModelEventCopyWith<$Res> {
  __$$_getProfileModelEventCopyWithImpl(_$_getProfileModelEvent _value,
      $Res Function(_$_getProfileModelEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileModel = null,
  }) {
    return _then(_$_getProfileModelEvent(
      profileModel: null == profileModel
          ? _value.profileModel
          : profileModel // ignore: cast_nullable_to_non_nullable
              as ProfileModel,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileModelCopyWith<$Res> get profileModel {
    return $ProfileModelCopyWith<$Res>(_value.profileModel, (value) {
      return _then(_value.copyWith(profileModel: value));
    });
  }
}

/// @nodoc

class _$_getProfileModelEvent implements _getProfileModelEvent {
  _$_getProfileModelEvent({required this.profileModel});

  @override
  final ProfileModel profileModel;

  @override
  String toString() {
    return 'OperationTimeEvent.getProfileModelEvent(profileModel: $profileModel)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_getProfileModelEvent &&
            (identical(other.profileModel, profileModel) ||
                other.profileModel == profileModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileModel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_getProfileModelEventCopyWith<_$_getProfileModelEvent> get copyWith =>
      __$$_getProfileModelEventCopyWithImpl<_$_getProfileModelEvent>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BuildContext context, int openingIndex,
            int rowIndex, int timeIndex, String time)
        timePickerEvent,
    required TResult Function() defaultValueAddInListEvent,
    required TResult Function(int rowIndex) addMoreTimeZoneEvent,
    required TResult Function(int rowIndex, int timeIndex) deleteTimeZoneEvent,
    required TResult Function(ProfileModel profileModel) getProfileModelEvent,
  }) {
    return getProfileModelEvent(profileModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BuildContext context, int openingIndex, int rowIndex,
            int timeIndex, String time)?
        timePickerEvent,
    TResult? Function()? defaultValueAddInListEvent,
    TResult? Function(int rowIndex)? addMoreTimeZoneEvent,
    TResult? Function(int rowIndex, int timeIndex)? deleteTimeZoneEvent,
    TResult? Function(ProfileModel profileModel)? getProfileModelEvent,
  }) {
    return getProfileModelEvent?.call(profileModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuildContext context, int openingIndex, int rowIndex,
            int timeIndex, String time)?
        timePickerEvent,
    TResult Function()? defaultValueAddInListEvent,
    TResult Function(int rowIndex)? addMoreTimeZoneEvent,
    TResult Function(int rowIndex, int timeIndex)? deleteTimeZoneEvent,
    TResult Function(ProfileModel profileModel)? getProfileModelEvent,
    required TResult orElse(),
  }) {
    if (getProfileModelEvent != null) {
      return getProfileModelEvent(profileModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_timePickerEvent value) timePickerEvent,
    required TResult Function(_defaultValueAddInListEvent value)
        defaultValueAddInListEvent,
    required TResult Function(_addMoreTimeZoneEventEvent value)
        addMoreTimeZoneEvent,
    required TResult Function(_deleteTimeZoneEvent value) deleteTimeZoneEvent,
    required TResult Function(_getProfileModelEvent value) getProfileModelEvent,
  }) {
    return getProfileModelEvent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_timePickerEvent value)? timePickerEvent,
    TResult? Function(_defaultValueAddInListEvent value)?
        defaultValueAddInListEvent,
    TResult? Function(_addMoreTimeZoneEventEvent value)? addMoreTimeZoneEvent,
    TResult? Function(_deleteTimeZoneEvent value)? deleteTimeZoneEvent,
    TResult? Function(_getProfileModelEvent value)? getProfileModelEvent,
  }) {
    return getProfileModelEvent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_timePickerEvent value)? timePickerEvent,
    TResult Function(_defaultValueAddInListEvent value)?
        defaultValueAddInListEvent,
    TResult Function(_addMoreTimeZoneEventEvent value)? addMoreTimeZoneEvent,
    TResult Function(_deleteTimeZoneEvent value)? deleteTimeZoneEvent,
    TResult Function(_getProfileModelEvent value)? getProfileModelEvent,
    required TResult orElse(),
  }) {
    if (getProfileModelEvent != null) {
      return getProfileModelEvent(this);
    }
    return orElse();
  }
}

abstract class _getProfileModelEvent implements OperationTimeEvent {
  factory _getProfileModelEvent({required final ProfileModel profileModel}) =
      _$_getProfileModelEvent;

  ProfileModel get profileModel;
  @JsonKey(ignore: true)
  _$$_getProfileModelEventCopyWith<_$_getProfileModelEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OperationTimeState {
  String get time => throw _privateConstructorUsedError;
  List<OperationTimeModel> get OperationTimeList =>
      throw _privateConstructorUsedError;
  bool get isRefresh => throw _privateConstructorUsedError;

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
  $Res call(
      {String time,
      List<OperationTimeModel> OperationTimeList,
      bool isRefresh});
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
    Object? OperationTimeList = null,
    Object? isRefresh = null,
  }) {
    return _then(_value.copyWith(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      OperationTimeList: null == OperationTimeList
          ? _value.OperationTimeList
          : OperationTimeList // ignore: cast_nullable_to_non_nullable
              as List<OperationTimeModel>,
      isRefresh: null == isRefresh
          ? _value.isRefresh
          : isRefresh // ignore: cast_nullable_to_non_nullable
              as bool,
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
  $Res call(
      {String time,
      List<OperationTimeModel> OperationTimeList,
      bool isRefresh});
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
    Object? OperationTimeList = null,
    Object? isRefresh = null,
  }) {
    return _then(_$_OperationTimeState(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      OperationTimeList: null == OperationTimeList
          ? _value._OperationTimeList
          : OperationTimeList // ignore: cast_nullable_to_non_nullable
              as List<OperationTimeModel>,
      isRefresh: null == isRefresh
          ? _value.isRefresh
          : isRefresh // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_OperationTimeState implements _OperationTimeState {
  const _$_OperationTimeState(
      {required this.time,
      required final List<OperationTimeModel> OperationTimeList,
      required this.isRefresh})
      : _OperationTimeList = OperationTimeList;

  @override
  final String time;
  final List<OperationTimeModel> _OperationTimeList;
  @override
  List<OperationTimeModel> get OperationTimeList {
    if (_OperationTimeList is EqualUnmodifiableListView)
      return _OperationTimeList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_OperationTimeList);
  }

  @override
  final bool isRefresh;

  @override
  String toString() {
    return 'OperationTimeState(time: $time, OperationTimeList: $OperationTimeList, isRefresh: $isRefresh)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_OperationTimeState &&
            (identical(other.time, time) || other.time == time) &&
            const DeepCollectionEquality()
                .equals(other._OperationTimeList, _OperationTimeList) &&
            (identical(other.isRefresh, isRefresh) ||
                other.isRefresh == isRefresh));
  }

  @override
  int get hashCode => Object.hash(runtimeType, time,
      const DeepCollectionEquality().hash(_OperationTimeList), isRefresh);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_OperationTimeStateCopyWith<_$_OperationTimeState> get copyWith =>
      __$$_OperationTimeStateCopyWithImpl<_$_OperationTimeState>(
          this, _$identity);
}

abstract class _OperationTimeState implements OperationTimeState {
  const factory _OperationTimeState(
      {required final String time,
      required final List<OperationTimeModel> OperationTimeList,
      required final bool isRefresh}) = _$_OperationTimeState;

  @override
  String get time;
  @override
  List<OperationTimeModel> get OperationTimeList;
  @override
  bool get isRefresh;
  @override
  @JsonKey(ignore: true)
  _$$_OperationTimeStateCopyWith<_$_OperationTimeState> get copyWith =>
      throw _privateConstructorUsedError;
}
