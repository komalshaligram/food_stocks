part of 'company_bloc.dart';

@freezed
class CompanyEvent with _$CompanyEvent {
  const factory CompanyEvent.getCompaniesListEvent(
      {required BuildContext context}) = _GetCompaniesListEvent;
}
