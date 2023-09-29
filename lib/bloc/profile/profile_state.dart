part of 'profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    required File image,
    required String selectedBusinessType,
    required BusinessTypeModel businessTypeList,
    required TextEditingController businessNameController,
    required TextEditingController hpController,
    required TextEditingController ownerNameController,
    required TextEditingController idController,
    required TextEditingController contactController,
  }) = _ProfileState;

  factory ProfileState.initial() => ProfileState(
        image: File(''),
        selectedBusinessType: '',
        businessTypeList: BusinessTypeModel(),
        businessNameController: TextEditingController(),
        hpController: TextEditingController(),
        ownerNameController: TextEditingController(),
        idController: TextEditingController(),
        contactController: TextEditingController(),
      );
}
