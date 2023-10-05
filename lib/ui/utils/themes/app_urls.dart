class AppUrls {
  static const String baseUrl = 'http://192.168.1.80:3001/api';
  static const String existingUserLoginUrl = '/v1/auth/verifyContactAndSendOTP';
  static const String loginOTPUrl = '/v1/auth/clientLogin';
  static const String newUserLoginUrl = '/v1/auth/verifyContactAndSendOTP';
  static const String FileUploadUrl = '/v1/auth/upload';
  static const String OperationTimeUrl = '/v1/clients/createClient';
  static const String businessTypesUrl = '/v1/settings/clientTypes';
  static const String getProfileDetailsUrl = '/v1/admin/getAllClients';
  static const String updateProfileDetailsUrl = '/v1/clients/updateClient';
  static const String formsListUrl = '/v1/settings/ClientForms';
  static const String filesListUrl = '/v1/settings/ClientFiles';
}