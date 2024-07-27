part of "app_blocs.dart";

class AppState {
  final int index;

  final CloudUserModel? cloudUserModel;

  const AppState({
    this.index = 0,
    this.cloudUserModel,
  });

  AppState copyWith({
    cloudUserModel,
    index,
  }) {
    return AppState(
      cloudUserModel: cloudUserModel ?? this.cloudUserModel,
      index: index ?? this.index,
    );
  }
}
