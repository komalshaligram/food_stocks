
part of 'bank_info_bloc.dart';

@freezed
class BankInfoState with _$BankInfoState{

  const factory BankInfoState({
    required List<BankDetail>bankList,
    required String bankName,
    required TextEditingController accountNumberController,
    required TextEditingController branchController,
    required bool isShimmering,
    required bool isApiShimmering,
    required bool isUpdate,
    required bool isPaymentFail,

  }) = _BankInfoState;

  factory BankInfoState.initial()=>  BankInfoState(
    bankList: [],
    bankName: '',
    accountNumberController: TextEditingController(),
    branchController: TextEditingController(),
    isShimmering: false,
    isApiShimmering: false,
    isUpdate: false,
    isPaymentFail: false
   
  );

}
