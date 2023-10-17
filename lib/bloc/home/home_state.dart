part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required String UserImageUrl,
    required String UserCompanyLogoUrl,
    required int cartCount,
  }) = _HomeState;

  factory HomeState.initial()=>  HomeState(
    UserImageUrl: '',
        UserCompanyLogoUrl: '',
        cartCount: 12,
      );
}
