part of 'owner1_form_bloc.dart';

@freezed
class Owner1FormState with _$Owner1FormState {
  const factory Owner1FormState(
      {required String agent,
      required List<BusinessType> businessTypeList,
      required String business,
      required TextEditingController owner1NameController,
      required TextEditingController owner1israelIdController,
      required TextEditingController guarantee1NameController,
      required TextEditingController guarantee1idController,
      required TextEditingController guarantee1addressController,
      required TextEditingController guarantee1PhoneController,
      required bool haveMultiple,
      required bool isUpdate,
      required String language,
      required String businessID,
      required String owner}) = _Owner1FormState;

  factory Owner1FormState.initial() => Owner1FormState(
      agent: '',
      business: '',
      businessTypeList: [],
      guarantee1addressController: TextEditingController(),
      guarantee1idController: TextEditingController(),
      guarantee1NameController: TextEditingController(),
      guarantee1PhoneController: TextEditingController(),
      businessID: '',
      owner1israelIdController: TextEditingController(),
      owner1NameController: TextEditingController(),
      haveMultiple: false,
      isUpdate: false,
      language: AppStrings.hebrewString,
      owner: '');
}
