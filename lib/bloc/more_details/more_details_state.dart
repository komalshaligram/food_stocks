part of 'more_details_bloc.dart';

@freezed
class MoreDetailsState with _$MoreDetailsState{
  const factory MoreDetailsState({
    required String? selectCity,
    required List<String> cityList,
    required List<String> filterList,
   required TextEditingController addressController,
    required TextEditingController emailController,
    required TextEditingController faxController,
    required TextEditingController cityController,
    required File image,
    required bool isRefresh,
    required String city,

    required bool isImagePick,

  }) = _MoreDetailsState;

  factory MoreDetailsState.initial()=> MoreDetailsState(
    selectCity: 'Acre',
    cityList: ['Acre','Arad','Dimona','Hadera','Ness'],
    addressController: TextEditingController(),
    emailController: TextEditingController(),
    faxController: TextEditingController(),
    image: File(''),
    isImagePick: false,
    cityController: TextEditingController(),
    filterList: [],
    isRefresh: false,
    city: '',


  );

}
