import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "welcome_event.dart";
part "welcome_state.dart";

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(const WelcomePageDotsIndicatorIndexInitialState()) {
    on<WelcomePageDotsIndicatorIndexChangeEvent>(
        _welcomePageDotsIndicatorIndexChangeEvent);
  }

  void _welcomePageDotsIndicatorIndexChangeEvent(
      WelcomePageDotsIndicatorIndexChangeEvent event,
      Emitter<WelcomeState> emit) {
    emit(WelcomePageDotsIndicatorIndexChangedState(
        indicatorIndex: event.indicatorIndex));
  }
}
