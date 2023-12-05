part of 'profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    required File image,
    required bool isUpdate,
    required String selectedBusinessType,
    required BusinessTypeModel businessTypeList,
    required TextEditingController businessNameController,
    required TextEditingController hpController,
    required TextEditingController ownerNameController,
    required TextEditingController idController,
    required TextEditingController contactController,
    required String UserImageUrl,
    required bool isLoading,
    required bool isShimmering,
    required bool isUpdating,
    required bool isFileSizeExceeds,
    required bool isFileUploading,
  }) = _ProfileState;

  factory ProfileState.initial() => ProfileState(
      image: File(''),
      isUpdate: false,
      selectedBusinessType: '',
      businessTypeList: BusinessTypeModel(),
      businessNameController: TextEditingController(),
      hpController: TextEditingController(),
      ownerNameController: TextEditingController(),
      idController: TextEditingController(),
      contactController: TextEditingController(),
      isLoading: false,
      isShimmering: false,
      isUpdating: false,
      isFileSizeExceeds: false,
      isFileUploading: false,
      UserImageUrl: '');
}

