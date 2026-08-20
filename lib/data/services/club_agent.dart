import '../../ui/utils/constants/app_strings.dart';

class ClubAgent {
  ClubAgent._();

  static String _id = AppStrings.clubAgentIdText;
  static String get id => _id;

  static void update(String? veahavtaAgentId) {
    final value = veahavtaAgentId?.trim() ?? '';
    if (value.isNotEmpty) {
      _id = value;
    }
  }

  static bool isClubClient(String? agentId) {
    final value = agentId?.trim() ?? '';
    return value.isNotEmpty && value == _id;
  }
}

String? readVeahavtaAgentId(dynamic response) {
  if (response is Map) {
    final data = response['data'];
    if (data is Map) {
      return data['veahavtaAgentId']?.toString();
    }
  }
  return null;
}
