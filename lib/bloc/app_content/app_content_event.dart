part of 'app_content_bloc.dart';

@freezed
class AppContentEvent with _$AppContentEvent {
  const factory AppContentEvent.getAppContentDetailsEvent(
      {required BuildContext context,
      required String appContentId}) = _GetAppContentDetailsEvent;
}
