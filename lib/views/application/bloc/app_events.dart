

part of "app_blocs.dart";

abstract class AppEvent {
  const AppEvent();
}

class AppInitializeEvent extends AppEvent {
  final int? index;
  final CloudUserModel? cloudUserModel;
  const AppInitializeEvent({
    this.index,
    this.cloudUserModel,
  }) : super();
}
