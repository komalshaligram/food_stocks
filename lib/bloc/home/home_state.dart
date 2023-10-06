part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required String UserImageUrl,
    required String UserCompanyLogoUrl,

  }) = _HomeState;

  factory HomeState.initial()=>  HomeState(
    UserImageUrl: '',
    UserCompanyLogoUrl: '',

  );
}
