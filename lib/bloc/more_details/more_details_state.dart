part of 'more_details_bloc.dart';

@freezed
class MoreDetailsState with _$MoreDetailsState{
  const factory MoreDetailsState({
    required String? selectCity,
    required List<String> institutionalList,
   required TextEditingController addressController,
    required TextEditingController emailController,
    required TextEditingController faxController,
    required File image,
    required bool isImagePick,

  }) = _MoreDetailsState;

  factory MoreDetailsState.initial()=> MoreDetailsState(
    selectCity: 'Acre',
    institutionalList: ['Acre','Arad','Dimona','Hadera','Ness'],
    addressController: TextEditingController(),
    emailController: TextEditingController(),
    faxController: TextEditingController(),
    image: File(''),
    isImagePick: false,

  );

}
