import 'package:ai_sign_language_recognition/models/cloud_db_user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_states.dart';
part "app_events.dart";

class AppBlocs extends Bloc<AppEvent, AppState> {
  AppBlocs() : super(const AppState()) {
    on<AppInitializeEvent>((event, emit) {
      emit(
        state.copyWith(
        index: event.index,
        cloudUserModel: event.cloudUserModel,
      ));
    });
  }
}
