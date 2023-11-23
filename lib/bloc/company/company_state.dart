part of 'company_bloc.dart';

@freezed
class CompanyState with _$CompanyState {
  const factory CompanyState({
    required List<Brand> companiesList,
    required bool isShimmering,
    required int pageNum,
    required bool isLoadMore,
    required bool isBottomOfCompanies,
  }) = _CompanyState;

  factory CompanyState.initial() => CompanyState(
        companiesList: [],
        isShimmering: false,
        pageNum: 0,
        isLoadMore: false,
        isBottomOfCompanies: false,
      );
}
