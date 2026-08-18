part of 'verify_client_data_bloc.dart';

@freezed
class VerifyClientDataState with _$VerifyClientDataState {
  const factory VerifyClientDataState(
      {required TextEditingController businessNameController,
      required TextEditingController contactNameController,
      required TextEditingController streetNameController,
      required TextEditingController streetNumberController,
      required TextEditingController phoneController,
      required TextEditingController deliveryDescriptionController,
      required TextEditingController citySearchController,
      required String selectCity,
      required List<String> cityList,
      required List<String> filterList,
      required CityListResModel? cityListResModel,
      required String wazeUrl,
      required String deliveryLocationImageUrl,
      File? deliveryLocationImageFile,
      required bool isShimmering,
      required bool isLoading,
      required bool isImageUploading,
      required String language,
      String? nextRouteName,
      Map<dynamic, dynamic>? nextRouteArgs}) = _VerifyClientDataState;

  factory VerifyClientDataState.initial() => VerifyClientDataState(
      businessNameController: TextEditingController(),
      contactNameController: TextEditingController(),
      streetNameController: TextEditingController(),
      streetNumberController: TextEditingController(),
      phoneController: TextEditingController(),
      deliveryDescriptionController: TextEditingController(),
      citySearchController: TextEditingController(),
      selectCity: '',
      cityList: [],
      filterList: [],
      cityListResModel: null,
      wazeUrl: '',
      deliveryLocationImageUrl: '',
      isShimmering: true,
      isLoading: false,
      isImageUploading: false,
      language: AppStrings.hebrewString);
}
