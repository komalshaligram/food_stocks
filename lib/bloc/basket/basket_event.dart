part of 'basket_bloc.dart';

@freezed
class BasketEvent with _$BasketEvent {
  const factory BasketEvent.productUpdateEvent({
    required int productWeight,
    required int listIndex,
    required BuildContext context,
    required String supplierId,
    required String productId,
}) = _productUpdateEvent;

  const factory BasketEvent.deleteListItemEvent({
    required int listIndex,
    required BuildContext context,
  }) = _deleteListItemEvent;

  const factory BasketEvent.getAllCartEvent({
    required BuildContext context
}) = _getAllCartEvent;

  const factory BasketEvent.clearCartEvent({
    required BuildContext context
  }) = _clearCartEvent;
}
