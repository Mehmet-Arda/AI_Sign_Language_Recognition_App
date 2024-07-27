
part of "auth_form_validation_bloc.dart";

abstract class AuthFormValidationEvent extends Equatable {
  const AuthFormValidationEvent();

  @override
  List<Object?> get props => [];
}

class InitEvent extends AuthFormValidationEvent {
  const InitEvent();
}

class NameChangedEvent extends AuthFormValidationEvent {
  const NameChangedEvent({required this.name});

  final AuthValidationBlocFormItem name;

  @override
  List<Object?> get props => [name];
}

class EmailChangedEvent extends AuthFormValidationEvent {
  const EmailChangedEvent({required this.email});

  final AuthValidationBlocFormItem email;

  @override
  List<Object?> get props => [email];
}

class PasswordChangedEvent extends AuthFormValidationEvent {
  const PasswordChangedEvent({required this.password});

  final AuthValidationBlocFormItem password;

  @override
  List<Object?> get props => [password];
}


class RePasswordChangedEvent extends AuthFormValidationEvent {

  const RePasswordChangedEvent({required this.rePassword});

  final AuthValidationBlocFormItem rePassword;

  @override
  List<Object?> get props => [rePassword];
}




class FormSubmitEvent extends AuthFormValidationEvent {
  const FormSubmitEvent();
}

class FormResetEvent extends AuthFormValidationEvent {
  const FormResetEvent();
}
