part of 'app_content_bloc.dart';

@freezed
class AppContentState with _$AppContentState {
  const factory AppContentState({
    required Datum appContentDetails,
    required bool isShimmering,
  }) = _AppContentState;

  factory AppContentState.initial() => AppContentState(
        appContentDetails: Datum(),
        isShimmering: false,
      );
}
