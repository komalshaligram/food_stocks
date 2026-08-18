part of 'webview_bloc.dart';

@freezed
class WebViewState with _$WebViewState {
  const factory WebViewState(
      {required String? userId,
      required bool isShimmering,
      required bool isAppOnMaintenance,
      required String language,
      required bool isDialogOpen,
      required BuildContext? context,
      required bool showClientDataOnApp,
      required String? screenEnglishTitle,
      required String? screenHebrewTitle,
      required String? baseUrl}) = _WebViewState;

  factory WebViewState.initial() => const WebViewState(
      userId: '',
      isShimmering: false,
      isAppOnMaintenance: false,
      language: AppStrings.hebrewString,
      isDialogOpen: false,
      context: null,
      showClientDataOnApp: false,
      screenEnglishTitle: '',
      screenHebrewTitle: '',
      baseUrl: '');
}
