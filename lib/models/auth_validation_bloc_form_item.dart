class AuthValidationBlocFormItem {
  final String value;
  final String? error;

  const AuthValidationBlocFormItem({this.value = "", this.error});

  AuthValidationBlocFormItem copyWith({final String? value, final String? error}) {
    return AuthValidationBlocFormItem(value: value ?? this.value, error: error ?? this.error);
  }
}
