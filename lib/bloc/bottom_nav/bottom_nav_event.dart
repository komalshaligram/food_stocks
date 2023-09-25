part of 'bottom_nav_bloc.dart';


@freezed
class BottomNavEvent with _$BottomNavEvent {
  factory BottomNavEvent.changePage({required int index}) = _ChangePageEvent;
  factory BottomNavEvent.changeCartCount() = _ChangeCartCountEvent;
}
