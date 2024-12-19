part of 'form_data_bloc.dart';

@freezed
class FormDataState with _$FormDataState{

  const factory FormDataState({
  required List<Agent> agentList,
    required String agent,
    required List<BusinessType> businessTypeList,
    required String business,
    required TextEditingController owner1NameController,
    required TextEditingController owner2NameController,
    required TextEditingController owner1israelIdController,
    required TextEditingController owner2israelIdController,
    required TextEditingController guarantee1NameController,
    required TextEditingController guarantee2NameController,
    required TextEditingController guarantee1idController,
    required TextEditingController guarantee2idController,
    required TextEditingController guarantee1addressController,
    required TextEditingController guarantee2addressController,
    required TextEditingController guarantee1PhoneController,
    required TextEditingController guarantee2PhoneController,
    required TextEditingController agentCodeController,
    required bool isShimmering,
    required bool isAgentListShimmering,
    required bool haveMultiple,
    required bool isUpdate,
    required String language,
    required List<String> ownerList,
    required String owner,

  }) = _FormDataState;

  factory FormDataState.initial()=>  FormDataState(
    agentList: [],
    agent: '',
    business: '',
    businessTypeList: [],
    guarantee1addressController: TextEditingController(),
    guarantee1idController: TextEditingController(),
    guarantee1NameController: TextEditingController(),
    guarantee1PhoneController: TextEditingController(),
    guarantee2addressController: TextEditingController(),
    guarantee2idController: TextEditingController(),
    guarantee2NameController: TextEditingController(),
    guarantee2PhoneController: TextEditingController(),
    owner1israelIdController: TextEditingController(),
    owner1NameController: TextEditingController(),
    owner2israelIdController: TextEditingController(),
    owner2NameController: TextEditingController(),
    isShimmering: false,
    haveMultiple: false,
    isAgentListShimmering: false,
    isUpdate: false,
    language: AppStrings.hebrewString,
      ownerList :['1','2'],
      owner:'1',
    agentCodeController: TextEditingController()
  );

}