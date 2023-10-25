part of 'supplier_bloc.dart';

@freezed
class SupplierEvent with _$SupplierEvent {
  const factory SupplierEvent.getSuppliersListEvent(
      {required BuildContext context}) = _GetSuppliersListEvent;
}
