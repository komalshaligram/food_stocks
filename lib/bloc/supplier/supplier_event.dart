part of 'supplier_bloc.dart';

@freezed
class SupplierEvent with _$SupplierEvent {
  const factory SupplierEvent.getSuppliersListEvent(
      {required BuildContext context}) = _GetSuppliersListEvent;

  const factory SupplierEvent.setSearchEvent({required String search}) =
      _SetSearchEvent;

  const factory SupplierEvent.refreshListEvent(
      {required BuildContext context}) = _RefreshListEvent;
}
