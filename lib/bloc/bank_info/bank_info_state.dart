
part of 'bank_info_bloc.dart';

@freezed
class BankInfoState with _$BankInfoState{

  const factory BankInfoState({
    required List<String>bankList,
    required String bankName,
    required TextEditingController accountNumberController,
    required TextEditingController branchController,

  }) = _BankInfoState;

  factory BankInfoState.initial()=>  BankInfoState(
    bankList: ['a1','b1','c1'],
    bankName: 'a1',
    accountNumberController: TextEditingController(),
    branchController: TextEditingController()
   
  );

}
