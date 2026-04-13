part of 'my_clients_bloc.dart';

@freezed
class MyClientsState with _$MyClientsState {
  const factory MyClientsState({
    required bool isShimmering,
    required List<AgentStore> clientsList,
    required List<AgentStore> filteredClientsList,
    required String language,
    required bool isLoading,
    required bool isBottomOfProducts,
    required RefreshController refreshController,
    required TextEditingController searchController,
    required String searchQuery,
  }) = _MyClientsState;

  factory MyClientsState.initial() => MyClientsState(
        isShimmering: false,
        clientsList: const [],
        filteredClientsList: const [],
        language: '',
        isLoading: false,
        isBottomOfProducts: false,
        refreshController: RefreshController(),
        searchController: TextEditingController(),
        searchQuery: '',
      );
}
