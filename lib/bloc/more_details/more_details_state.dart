part of 'more_details_bloc.dart';

@freezed
class MoreDetailsState with _$MoreDetailsState {
  const factory MoreDetailsState({
    required String selectCity,
    required bool isUpdate,
    required List<String> cityList,
    required List<String> filterList,
    required TextEditingController addressController,
    required TextEditingController emailController,
    required TextEditingController faxController,
    required TextEditingController cityController,
    required File image,
    required bool isLoading,
    required bool isUpdating,
    required bool isShimmering,
    required CityListResModel? cityListResModel,
    required String companyLogo,
    required bool isFileSizeExceeds,
    required bool isUploadProcess,
    required String language,
  }) = _MoreDetailsState;

  factory MoreDetailsState.initial() => MoreDetailsState(
    selectCity: '',
        cityList: [],
        isUpdate: false,
        addressController: TextEditingController(),
        emailController: TextEditingController(),
        faxController: TextEditingController(),
        image: File(''),
        isLoading: false,
        isUpdating: false,
        cityController: TextEditingController(),
        filterList: [],
        cityListResModel: CityListResModel(),
        companyLogo: '',
        isFileSizeExceeds: false,
        isShimmering: false,
        isUploadProcess: false,
    language: 'he',
      );
}
