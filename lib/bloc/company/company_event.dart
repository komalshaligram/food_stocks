part of 'company_bloc.dart';

@freezed
class CompanyEvent with _$CompanyEvent {
  const factory CompanyEvent.getCompaniesListEvent(
      {required BuildContext context}) = _GetCompaniesListEvent;

  const factory CompanyEvent.setSearchEvent({required String search}) =
      _SetSearchEvent;
}
