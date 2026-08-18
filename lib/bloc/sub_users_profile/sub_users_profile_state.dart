part of 'sub_users_profile_bloc.dart';

@freezed
class SubUsersProfileState with _$SubUsersProfileState {
  const factory SubUsersProfileState(
      {required bool isShimmering,
      required bool isUpdate,
      required String subUserProfileImage,
      required bool isUploadingProcess,
      required bool isFileUploading,
      required File image,
      required String language,
      required TextEditingController israelIdController,
      required TextEditingController nameController,
      required TextEditingController phoneNumberController,
      required TextEditingController emailController,
      required bool isLoading,
      required bool isEnable,
      required String subUserId,
      required bool isDeleteProcess}) = _SubUsersProfileState;

  factory SubUsersProfileState.initial() => SubUsersProfileState(
      isShimmering: false,
      language: AppStrings.hebrewString,
      image: File(''),
      isUpdate: false,
      isUploadingProcess: false,
      subUserProfileImage: '',
      isFileUploading: false,
      emailController: TextEditingController(),
      nameController: TextEditingController(),
      phoneNumberController: TextEditingController(),
      israelIdController: TextEditingController(),
      isLoading: false,
      isEnable: false,
      subUserId: '',
      isDeleteProcess: false);
}
