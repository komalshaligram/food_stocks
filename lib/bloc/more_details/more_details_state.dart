part of 'more_details_bloc.dart';

@freezed
class MoreDetailsState with _$MoreDetailsState {
  const factory MoreDetailsState({
    required String selectCity,
    required bool isUpdate,
    required List<String> cityList,
    required List<String> filterList,
    required TextEditingController streetNameController,
    required TextEditingController streetNumberController,
    required TextEditingController emailController,
    required TextEditingController cityController,
    required TextEditingController zipController,
    required bool isLoading,
    required bool isUpdating,
    required bool isShimmering,
    required CityListResModel? cityListResModel,
    required String language,
    required bool approveForSMS,
  }) = _MoreDetailsState;

  factory MoreDetailsState.initial() => MoreDetailsState(
        selectCity: '',
        cityList: [],
        isUpdate: false,
        streetNameController: TextEditingController(),
        streetNumberController: TextEditingController(),
        emailController: TextEditingController(),
        zipController: TextEditingController(),
        isLoading: false,
        isUpdating: false,
        cityController: TextEditingController(),
        filterList: [],
        cityListResModel: const CityListResModel(),
        isShimmering:false,
        language: AppStrings.hebrewString,
        approveForSMS:true
      );
}
