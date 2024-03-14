part of 'form_data_bloc.dart';

@freezed
class FormDataState with _$FormDataState{

  const factory FormDataState({
  required List<String>agentList,
    required String agent,
    required List<String> BusinessTypeList,
    required String business,
    required bool isDisable,
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
  }) = _FormDataState;

  factory FormDataState.initial()=>  FormDataState(
    agentList: ['a1','b1','c1'],
    agent: 'a1',
    business: '15',
    BusinessTypeList: ['15','17','21','30','40'],
    isDisable: true,
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
    owner2NameController: TextEditingController()
  );

}