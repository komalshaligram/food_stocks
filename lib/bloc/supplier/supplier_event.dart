part of 'supplier_bloc.dart';

@freezed
class SupplierEvent with _$SupplierEvent {
  const factory SupplierEvent.getSuppliersListEvent({
    required BuildContext context,
  }) = _getSuppliersListEvent;

  const factory SupplierEvent.setSearchEvent({
    required String search,
  }) = _setSearchEvent;

  const factory SupplierEvent.refreshListEvent({
    required BuildContext context,
  }) = _refreshListEvent;
}
