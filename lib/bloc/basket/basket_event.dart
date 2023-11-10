part of 'basket_bloc.dart';

@freezed
class BasketEvent with _$BasketEvent {
  const factory BasketEvent.productUpdateEvent({
    required int productWeight,
    required int listIndex,
    required BuildContext context,
    required String supplierId,
    required String productId,
    required String cartProductId,
}) = _productUpdateEvent;

  const factory BasketEvent.removeCartProductEvent({
    required int listIndex,
    required BuildContext context,
    required String cartProductId,
  }) = _removeCartProductEvent;

  const factory BasketEvent.getAllCartEvent({
    required BuildContext context
}) = _getAllCartEvent;

  const factory BasketEvent.clearCartEvent({
    required BuildContext context
  }) = _clearCartEvent;

  const factory BasketEvent.refreshListEvent({
    required BuildContext context
  }) = _refreshListEvent;
}
