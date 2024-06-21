part of 'sub_users_bloc.dart';

@freezed
class SubUsersState with _$SubUsersState{
  const factory SubUsersState({
    required bool isShimmering,
    required List<User> subUserList,
    required int pageNum,
    required bool isLoadMore,
    required bool isBottomOfProducts,
    required RefreshController refreshController,
    required bool isPop,



  }) = _SubUsersState;

  factory SubUsersState.initial() => SubUsersState(
    isShimmering: false,
    pageNum: 0,
    isBottomOfProducts: false,
    isLoadMore: false,
    subUserList: [],
    refreshController: RefreshController(),
    isPop: false,
    

  );
}

