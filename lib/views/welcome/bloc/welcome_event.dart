part of "welcome_bloc.dart";

@immutable
sealed class WelcomeEvent {
  const WelcomeEvent();
}

final class WelcomePageDotsIndicatorIndexChangeEvent extends WelcomeEvent {
  final int indicatorIndex;

  const WelcomePageDotsIndicatorIndexChangeEvent({required this.indicatorIndex});
}
