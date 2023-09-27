part of 'profile3_bloc.dart';

@freezed
class Profile3State with _$Profile3State{
  const factory Profile3State({
    required String? selectCity,
    required List<String> institutionalList,
   required TextEditingController addressController,
    required TextEditingController emailController,
    required TextEditingController faxController,
    required File image,
    required bool isImagePick,

  }) = _Profile3State;

  factory Profile3State.initial()=> Profile3State(
    selectCity: 'q',
    institutionalList: ['q','b','c','d','e'],
    addressController: TextEditingController(),
    emailController: TextEditingController(),
    faxController: TextEditingController(),
    image: File(''),
    isImagePick: false,

  );

}
