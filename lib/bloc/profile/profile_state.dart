/*

part of 'profile_bloc.dart';



@freezed
class ProfileState with _$ProfileState{


  const factory ProfileState({
    required File image,
    required bool isImagePick,
    required String? selectedBusiness,
    required List<String> institutionalList,
    required TextEditingController businessNameController,
    required TextEditingController hpController,
    required TextEditingController ownerController,
    required TextEditingController idController,
    required TextEditingController contactController,

  }) = _ProfileState;

  factory ProfileState.initial()=> ProfileState(
    image: File(''),
    isImagePick: false,
    selectedBusiness: 'q',
    institutionalList: ['q','b','c','d','e'],
    businessNameController: TextEditingController(),
    hpController: TextEditingController(),
    ownerController: TextEditingController(),
    idController: TextEditingController(),
    contactController: TextEditingController(),
  );



}
*/
