part of 'more_details_bloc.dart';

@freezed
class MoreDetailsEvent with _$MoreDetailsEvent {
  factory MoreDetailsEvent.dropDownEvent() = _dropDownEvent;

  factory MoreDetailsEvent.pickLogoImageEvent(
      {required BuildContext context,
      required bool isFromCamera}) = _pickLogoImageEvent;

  factory MoreDetailsEvent.getProfileModelEvent({required ProfileModel profileModel}) = _getProfileModelEvent;

  factory MoreDetailsEvent.navigateToOperationTimeScreenEvent({required BuildContext context}) =
  _navigateToOperationTimeScreenEvent;
}
