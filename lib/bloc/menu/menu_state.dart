part of 'menu_bloc.dart';

@freezed
class MenuState with _$MenuState {
  const factory MenuState({
    required List<Content> contentList,
    required bool isShimmering,
    required int pageNum,
    required bool isLoadMore,
    required bool isBottomOfAppContents,
    required RefreshController refreshController,

  }) = _MenuState;

  factory MenuState.initial() => MenuState(
    contentList: [],
        isShimmering: false,
        pageNum: 0,
        isLoadMore: false,
        isBottomOfAppContents: false,
        refreshController: RefreshController(),
      );
}
