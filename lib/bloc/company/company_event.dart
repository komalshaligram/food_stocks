part of 'company_bloc.dart';

@freezed
class CompanyEvent with _$CompanyEvent {
  const factory CompanyEvent.getCompaniesListEvent({
    required BuildContext context,
  }) = _getCompaniesListEvent;

  const factory CompanyEvent.setSearchEvent({
    required String search,
  }) = _setSearchEvent;

  const factory CompanyEvent.refreshListEvent({
    required BuildContext context,
  }) = _refreshListEvent;
}
