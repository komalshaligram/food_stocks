// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_res_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return _LoginResponse.fromJson(json);
}

/// @nodoc
mixin _$LoginResponse {
  Data? get data => throw _privateConstructorUsedError;
  bool? get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoginResponseCopyWith<LoginResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginResponseCopyWith<$Res> {
  factory $LoginResponseCopyWith(
          LoginResponse value, $Res Function(LoginResponse) then) =
      _$LoginResponseCopyWithImpl<$Res, LoginResponse>;
  @useResult
  $Res call({Data? data, bool? success, String? message});

  $DataCopyWith<$Res>? get data;
}

/// @nodoc
class _$LoginResponseCopyWithImpl<$Res, $Val extends LoginResponse>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? success = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Data?,
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $DataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LoginResponseCopyWith<$Res>
    implements $LoginResponseCopyWith<$Res> {
  factory _$$_LoginResponseCopyWith(
          _$_LoginResponse value, $Res Function(_$_LoginResponse) then) =
      __$$_LoginResponseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Data? data, bool? success, String? message});

  @override
  $DataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$_LoginResponseCopyWithImpl<$Res>
    extends _$LoginResponseCopyWithImpl<$Res, _$_LoginResponse>
    implements _$$_LoginResponseCopyWith<$Res> {
  __$$_LoginResponseCopyWithImpl(
      _$_LoginResponse _value, $Res Function(_$_LoginResponse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? success = freezed,
    Object? message = freezed,
  }) {
    return _then(_$_LoginResponse(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Data?,
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_LoginResponse implements _LoginResponse {
  const _$_LoginResponse({this.data, this.success, this.message});

  factory _$_LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$$_LoginResponseFromJson(json);

  @override
  final Data? data;
  @override
  final bool? success;
  @override
  final String? message;

  @override
  String toString() {
    return 'LoginResponse(data: $data, success: $success, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LoginResponse &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, data, success, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LoginResponseCopyWith<_$_LoginResponse> get copyWith =>
      __$$_LoginResponseCopyWithImpl<_$_LoginResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LoginResponseToJson(
      this,
    );
  }
}

abstract class _LoginResponse implements LoginResponse {
  const factory _LoginResponse(
      {final Data? data,
      final bool? success,
      final String? message}) = _$_LoginResponse;

  factory _LoginResponse.fromJson(Map<String, dynamic> json) =
      _$_LoginResponse.fromJson;

  @override
  Data? get data;
  @override
  bool? get success;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$_LoginResponseCopyWith<_$_LoginResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

Data _$DataFromJson(Map<String, dynamic> json) {
  return _Data.fromJson(json);
}

/// @nodoc
mixin _$Data {
  UserProfile? get userProfile => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DataCopyWith<Data> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataCopyWith<$Res> {
  factory $DataCopyWith(Data value, $Res Function(Data) then) =
      _$DataCopyWithImpl<$Res, Data>;
  @useResult
  $Res call({UserProfile? userProfile});

  $UserProfileCopyWith<$Res>? get userProfile;
}

/// @nodoc
class _$DataCopyWithImpl<$Res, $Val extends Data>
    implements $DataCopyWith<$Res> {
  _$DataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userProfile = freezed,
  }) {
    return _then(_value.copyWith(
      userProfile: freezed == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get userProfile {
    if (_value.userProfile == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.userProfile!, (value) {
      return _then(_value.copyWith(userProfile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_DataCopyWith<$Res> implements $DataCopyWith<$Res> {
  factory _$$_DataCopyWith(_$_Data value, $Res Function(_$_Data) then) =
      __$$_DataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserProfile? userProfile});

  @override
  $UserProfileCopyWith<$Res>? get userProfile;
}

/// @nodoc
class __$$_DataCopyWithImpl<$Res> extends _$DataCopyWithImpl<$Res, _$_Data>
    implements _$$_DataCopyWith<$Res> {
  __$$_DataCopyWithImpl(_$_Data _value, $Res Function(_$_Data) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userProfile = freezed,
  }) {
    return _then(_$_Data(
      userProfile: freezed == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Data implements _Data {
  const _$_Data({this.userProfile});

  factory _$_Data.fromJson(Map<String, dynamic> json) => _$$_DataFromJson(json);

  @override
  final UserProfile? userProfile;

  @override
  String toString() {
    return 'Data(userProfile: $userProfile)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Data &&
            (identical(other.userProfile, userProfile) ||
                other.userProfile == userProfile));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userProfile);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DataCopyWith<_$_Data> get copyWith =>
      __$$_DataCopyWithImpl<_$_Data>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DataToJson(
      this,
    );
  }
}

abstract class _Data implements Data {
  const factory _Data({final UserProfile? userProfile}) = _$_Data;

  factory _Data.fromJson(Map<String, dynamic> json) = _$_Data.fromJson;

  @override
  UserProfile? get userProfile;
  @override
  @JsonKey(ignore: true)
  _$$_DataCopyWith<_$_Data> get copyWith => throw _privateConstructorUsedError;
}

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  int? get userId => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  String? get emailId => throw _privateConstructorUsedError;
  String? get mobileNo => throw _privateConstructorUsedError;
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  int? get gender => throw _privateConstructorUsedError;
  int? get lookingFor => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  bool? get isEdited => throw _privateConstructorUsedError;
  int? get roleId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {int? userId,
      String? firstName,
      String? lastName,
      String? emailId,
      String? mobileNo,
      DateTime? dateOfBirth,
      int? gender,
      int? lookingFor,
      bool? isActive,
      bool? isEdited,
      int? roleId});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? emailId = freezed,
    Object? mobileNo = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? lookingFor = freezed,
    Object? isActive = freezed,
    Object? isEdited = freezed,
    Object? roleId = freezed,
  }) {
    return _then(_value.copyWith(
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      emailId: freezed == emailId
          ? _value.emailId
          : emailId // ignore: cast_nullable_to_non_nullable
              as String?,
      mobileNo: freezed == mobileNo
          ? _value.mobileNo
          : mobileNo // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as int?,
      lookingFor: freezed == lookingFor
          ? _value.lookingFor
          : lookingFor // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      isEdited: freezed == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool?,
      roleId: freezed == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserProfileCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$_UserProfileCopyWith(
          _$_UserProfile value, $Res Function(_$_UserProfile) then) =
      __$$_UserProfileCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? userId,
      String? firstName,
      String? lastName,
      String? emailId,
      String? mobileNo,
      DateTime? dateOfBirth,
      int? gender,
      int? lookingFor,
      bool? isActive,
      bool? isEdited,
      int? roleId});
}

/// @nodoc
class __$$_UserProfileCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$_UserProfile>
    implements _$$_UserProfileCopyWith<$Res> {
  __$$_UserProfileCopyWithImpl(
      _$_UserProfile _value, $Res Function(_$_UserProfile) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? emailId = freezed,
    Object? mobileNo = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? lookingFor = freezed,
    Object? isActive = freezed,
    Object? isEdited = freezed,
    Object? roleId = freezed,
  }) {
    return _then(_$_UserProfile(
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      emailId: freezed == emailId
          ? _value.emailId
          : emailId // ignore: cast_nullable_to_non_nullable
              as String?,
      mobileNo: freezed == mobileNo
          ? _value.mobileNo
          : mobileNo // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as int?,
      lookingFor: freezed == lookingFor
          ? _value.lookingFor
          : lookingFor // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      isEdited: freezed == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool?,
      roleId: freezed == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserProfile implements _UserProfile {
  const _$_UserProfile(
      {this.userId,
      this.firstName,
      this.lastName,
      this.emailId,
      this.mobileNo,
      this.dateOfBirth,
      this.gender,
      this.lookingFor,
      this.isActive,
      this.isEdited,
      this.roleId});

  factory _$_UserProfile.fromJson(Map<String, dynamic> json) =>
      _$$_UserProfileFromJson(json);

  @override
  final int? userId;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? emailId;
  @override
  final String? mobileNo;
  @override
  final DateTime? dateOfBirth;
  @override
  final int? gender;
  @override
  final int? lookingFor;
  @override
  final bool? isActive;
  @override
  final bool? isEdited;
  @override
  final int? roleId;

  @override
  String toString() {
    return 'UserProfile(userId: $userId, firstName: $firstName, lastName: $lastName, emailId: $emailId, mobileNo: $mobileNo, dateOfBirth: $dateOfBirth, gender: $gender, lookingFor: $lookingFor, isActive: $isActive, isEdited: $isEdited, roleId: $roleId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserProfile &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.emailId, emailId) || other.emailId == emailId) &&
            (identical(other.mobileNo, mobileNo) ||
                other.mobileNo == mobileNo) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.lookingFor, lookingFor) ||
                other.lookingFor == lookingFor) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isEdited, isEdited) ||
                other.isEdited == isEdited) &&
            (identical(other.roleId, roleId) || other.roleId == roleId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      firstName,
      lastName,
      emailId,
      mobileNo,
      dateOfBirth,
      gender,
      lookingFor,
      isActive,
      isEdited,
      roleId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserProfileCopyWith<_$_UserProfile> get copyWith =>
      __$$_UserProfileCopyWithImpl<_$_UserProfile>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserProfileToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {final int? userId,
      final String? firstName,
      final String? lastName,
      final String? emailId,
      final String? mobileNo,
      final DateTime? dateOfBirth,
      final int? gender,
      final int? lookingFor,
      final bool? isActive,
      final bool? isEdited,
      final int? roleId}) = _$_UserProfile;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$_UserProfile.fromJson;

  @override
  int? get userId;
  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  String? get emailId;
  @override
  String? get mobileNo;
  @override
  DateTime? get dateOfBirth;
  @override
  int? get gender;
  @override
  int? get lookingFor;
  @override
  bool? get isActive;
  @override
  bool? get isEdited;
  @override
  int? get roleId;
  @override
  @JsonKey(ignore: true)
  _$$_UserProfileCopyWith<_$_UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}
