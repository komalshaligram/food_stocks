part of 'supplier_brand_bloc.dart';

@freezed
class SupplierBrandEvent with _$SupplierBrandEvent {
  const factory SupplierBrandEvent.initEvent({required List<BrandData> brandList}) = _initEvent;
  const factory SupplierBrandEvent.refreshEvent({required List<BrandData> brandList}) = _refreshEvent;
}
