part of 'company_bloc.dart';

@freezed
class CompanyState with _$CompanyState {
  const factory CompanyState({
    required List<Brand> companiesList,
    required String search,
    required bool isShimmering,
    required int pageNum,
    required bool isLoadMore,
    required bool isBottomOfCompanies,
    required RefreshController refreshController,
    required String language,

  }) = _CompanyState;

  factory CompanyState.initial() => CompanyState(
    companiesList: [],
        search: '',
        isShimmering: false,
        pageNum: 0,
        isLoadMore: false,
        isBottomOfCompanies: false,
        refreshController: RefreshController(),
        language: '',
      );
}
