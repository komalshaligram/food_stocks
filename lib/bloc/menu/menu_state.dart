part of 'menu_bloc.dart';

@freezed
class MenuState with _$MenuState {
  const factory MenuState(/*{required bool isHebrewLanguage}*/) = _MenuState;

  factory MenuState.initial() => MenuState(/*isHebrewLanguage: false*/);
}
