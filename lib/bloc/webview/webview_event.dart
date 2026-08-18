part of 'webview_bloc.dart';

@freezed
class WebViewEvent with _$WebViewEvent {
  const factory WebViewEvent.generalSettings({required BuildContext context, required BuildContext dialogContext, required bool isRetryLoading}) =
      _generalSettings;

  const factory WebViewEvent.updateMaintenanceEvent({required BuildContext context}) = _updateMaintenanceEvent;
}
