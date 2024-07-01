part of 'credit_card_details_bloc.dart';

@freezed
class CreditCardDetailsEvent with _$CreditCardDetailsEvent {
  factory CreditCardDetailsEvent.splashLoaded({required String pushNavigation}) =
  _SplashLoadedEvent;
}