part of 'basket_bloc.dart';

@freezed
class BasketEvent with _$BasketEvent {
  const factory BasketEvent.started() = _Started;
}
