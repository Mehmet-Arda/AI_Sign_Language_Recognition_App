part of "auth_bloc.dart";

@immutable
abstract class AuthState extends Equatable {
  final bool isLoading;
  final String? loadingText;

  const AuthState({
    required this.isLoading,
    this.loadingText = "Please wait a moment",
  });

  @override
  List<Object?> get props => [];
}

class AuthUninitializedState extends AuthState {
  const AuthUninitializedState({
    required exception,
    required super.isLoading,
    super.loadingText,
  });
}

/* class AuthLoadingState extends AuthState {
  //final String? loadingText;
  const AuthLoadingState({this.loadingText = "Please wait a moment..."});

  @override
  List<Object?> get props => [loadingText];
} */

class AuthRegisteringState extends AuthState {
  final Exception? exception;

  const AuthRegisteringState({
    required this.exception,
    required super.isLoading,
    super.loadingText,
  });

  @override
  List<Object?> get props => [];
}

class AuthSignedInState extends AuthState {
  final CloudUserModel user;

  const AuthSignedInState({
    required this.user,
    required super.isLoading,
    super.loadingText,
  });
  @override
  List<Object?> get props => [];
}

class AuthForgotPasswordState extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;
  final bool canSendEmail;

  const AuthForgotPasswordState({
    this.canSendEmail = true,
    this.exception,
    required this.hasSentEmail,
    required super.isLoading,
    super.loadingText,
  });
}

class AuthNeedsEmailVerificationState extends AuthState {
  final Exception? exception;
  final bool canSendEmail;


  const AuthNeedsEmailVerificationState({
    this.canSendEmail = true,
    required this.exception,
    required super.isLoading,
    super.loadingText,
  });
  @override
  List<Object?> get props => [];
}


class AuthInitialState extends AuthState with EquatableMixin {
  final Exception? exception;

  const AuthInitialState({
    required this.exception,
    required super.isLoading,
    super.loadingText,
  });

  @override
  List<Object?> get props => [exception];
}

/* class AuthNavigatingToSignUpViewState extends AuthState {
  const AuthNavigatingToSignUpViewState({
    required super.isLoading,
    super.loadingText,
  });

  @override
  List<Object?> get props => [];
}

class AuthNavigatingToSignInViewState extends AuthState {
  const AuthNavigatingToSignInViewState({
    required super.isLoading,
    super.loadingText,
  });

  @override
  List<Object?> get props => [];
}
 */