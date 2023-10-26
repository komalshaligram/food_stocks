part of 'product_sale_bloc.dart';

@freezed
class ProductSaleEvent with _$ProductSaleEvent {
  const factory ProductSaleEvent.getProductSalesListEvent(
      {required BuildContext context}) = _GetProductSalesListEvent;
}
