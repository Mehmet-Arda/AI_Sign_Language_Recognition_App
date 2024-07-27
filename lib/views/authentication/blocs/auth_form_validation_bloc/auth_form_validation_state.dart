
part of "auth_form_validation_bloc.dart";


class AuthFormValidationState extends Equatable {
  final AuthValidationBlocFormItem name;
  final AuthValidationBlocFormItem email;
  final AuthValidationBlocFormItem password;
  final AuthValidationBlocFormItem rePassword;

  final GlobalKey<FormState>? formKey;

  const AuthFormValidationState(
      {this.name = const AuthValidationBlocFormItem(error: "Enter name"),
      this.email = const AuthValidationBlocFormItem(error: "Enter name"),
      this.password = const AuthValidationBlocFormItem(error: "Enter name"),
      this.rePassword = const AuthValidationBlocFormItem(error: "Enter name"),
      this.formKey});

  AuthFormValidationState copyWith(
      {AuthValidationBlocFormItem? name,
      AuthValidationBlocFormItem? email,
      AuthValidationBlocFormItem? password,
      AuthValidationBlocFormItem? rePassword,
      GlobalKey<FormState>? formKey}) {
    return AuthFormValidationState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      formKey: formKey,
    );
  }

  @override
  List<Object?> get props => [name, email, password, rePassword, formKey];
}

class FormValidationSuccessOrFailedState extends AuthFormValidationState {
  final bool success;

  const FormValidationSuccessOrFailedState({
    super.name,

    required super.email,
    required super.password,

    super.rePassword,
    required super.formKey,
    required this.success,
  });
}
