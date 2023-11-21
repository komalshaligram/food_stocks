part of 'menu_bloc.dart';

@freezed
class MenuState with _$MenuState {
  const factory MenuState({
    required List<Content> contentList,
    required bool isShimmering,
  }) = _MenuState;

  factory MenuState.initial() => MenuState(
        contentList: [],
        isShimmering: false,
      );
}
