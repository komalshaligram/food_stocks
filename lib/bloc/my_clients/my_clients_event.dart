part of 'my_clients_bloc.dart';

@freezed
class MyClientsEvent with _$MyClientsEvent {
  factory MyClientsEvent.getAgentClientsListEvent({required BuildContext context}) = _getAgentClientsListEvent;

  const factory MyClientsEvent.switchAccountEvent({
    required BuildContext context,
    required String clientsId,
    required String clientName,
    required String? businessName,
  }) = _switchAccountEvent;

  const factory MyClientsEvent.updateAgentClientsNoMinimumEvent({
    required BuildContext context,
    required String clientsId,
    required String supplierId,
    required bool isNoMinimum,
  }) = _updateAgentClientsNoMinimumEvent;

  const factory MyClientsEvent.refreshListEvent({required BuildContext context}) = _refreshListEvent;

  const factory MyClientsEvent.searchClients({required String query}) = _SearchClients;
}
