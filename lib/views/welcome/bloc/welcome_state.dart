part of "welcome_bloc.dart";

@immutable
sealed class WelcomeState {
  const WelcomeState();
}

final class WelcomePageDotsIndicatorIndexInitialState extends WelcomeState {
  const WelcomePageDotsIndicatorIndexInitialState();
}

final class WelcomePageDotsIndicatorIndexChangedState extends WelcomeState {
  final int indicatorIndex;

  const WelcomePageDotsIndicatorIndexChangedState({required this.indicatorIndex});
}
