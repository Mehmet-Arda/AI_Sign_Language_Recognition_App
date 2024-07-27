part of "auth_bloc.dart";

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthInitializeEvent extends AuthEvent {
  const AuthInitializeEvent();
}

class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [];
}

class AuthSignOutEvent extends AuthEvent {
  const AuthSignOutEvent();
}

class AuthSignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthSignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [];
}

class AuthForgotPasswordEvent extends AuthEvent {
  final String? email;
  const AuthForgotPasswordEvent({this.email});
}


class AuthCheckEmailVerificationEvent extends AuthEvent{

  const AuthCheckEmailVerificationEvent();
  
}

class AuthNavigateToSignUpViewEvent extends AuthEvent {
  const AuthNavigateToSignUpViewEvent();
}

class AuthNavigateToSignInViewEvent extends AuthEvent {
  const AuthNavigateToSignInViewEvent();
}

class AuthSendEmailVerificationEvent extends AuthEvent {
  const AuthSendEmailVerificationEvent();
}
