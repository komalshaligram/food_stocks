part of 'profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    required File image,
    required bool isUpdate,
    required String selectedBusinessType,
    required BusinessTypeModel businessTypeList,
    required TextEditingController businessNameController,
    required TextEditingController businessIdController,
    required TextEditingController ownerNameController,
    required TextEditingController israelIdController,
    required TextEditingController contactController,
    required String UserImageUrl,
    required bool isLoading,
    required bool isShimmering,
    required bool isUpdating,
    required bool isFileSizeExceeds,
    required bool isFileUploading,
    required bool isUploadingProcess,
    required String language,
  }) = _ProfileState;

  factory ProfileState.initial() => ProfileState(
      image: File(''),
      isUpdate: false,
      selectedBusinessType: '',
      businessTypeList: BusinessTypeModel(),
      businessNameController: TextEditingController(),
      businessIdController: TextEditingController(),
      ownerNameController: TextEditingController(),
      israelIdController: TextEditingController(),
      contactController: TextEditingController(),
      isLoading: false,
      isShimmering: false,
      isUpdating: false,
      isFileSizeExceeds: false,
      isFileUploading: false,
      UserImageUrl: '',
      isUploadingProcess: false,
    language: 'he'
  );
}

