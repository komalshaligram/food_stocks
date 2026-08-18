part of 'owner2_form_bloc.dart';

@freezed
class Owner2FormState with _$Owner2FormState {
  const factory Owner2FormState(
      {required TextEditingController owner2NameController,
      required TextEditingController owner2israelIdController,
      required TextEditingController guarantee2NameController,
      required TextEditingController guarantee2idController,
      required TextEditingController guarantee2addressController,
      required TextEditingController guarantee2PhoneController,
      required bool isUpdate,
      required String language,
      required TermsConditionReqModel termsConditionReqModel}) = _Owner2FormState;

  factory Owner2FormState.initial() => Owner2FormState(
      owner2israelIdController: TextEditingController(),
      guarantee2addressController: TextEditingController(),
      guarantee2idController: TextEditingController(),
      guarantee2NameController: TextEditingController(),
      guarantee2PhoneController: TextEditingController(),
      owner2NameController: TextEditingController(),
      isUpdate: false,
      termsConditionReqModel: const TermsConditionReqModel(),
      language: AppStrings.hebrewString);
}
