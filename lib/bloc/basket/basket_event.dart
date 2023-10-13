part of 'basket_bloc.dart';

@freezed
class BasketEvent with _$BasketEvent {
  const factory BasketEvent.productIncrementEvent({
    required int productWeight,
    required int listIndex,
}) = _productIncrementEvent;

  const factory BasketEvent.productDecrementEvent({
    required int productWeight,
    required int listIndex,
}) = _productDecrementEvent;

  const factory BasketEvent.deleteListItemEvent({
    required int listIndex,
    required BuildContext context,
  }) = _deleteListItemEvent;
}
