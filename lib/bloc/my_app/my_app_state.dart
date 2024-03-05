
part of 'my_app_bloc.dart';

@freezed
class MyAppState with _$MyAppState{

  const factory MyAppState() = _MyAppState;

  factory MyAppState.initial()=> const MyAppState();

}