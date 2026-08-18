part of 'supplier_brand_bloc.dart';

@freezed
class SupplierBrandState with _$SupplierBrandState {
  const factory SupplierBrandState(
      {@Default([]) List<BrandData> brandsList,
      @Default(false) bool isShimmering,
      required RefreshController refreshController}) = _SupplierBrandState;

  factory SupplierBrandState.initial() => SupplierBrandState(refreshController: RefreshController());
}
