import 'dart:async';
import 'dart:developer';

import 'package:ai_sign_language_recognition/models/auth_validation_bloc_form_item.dart';
import 'package:ai_sign_language_recognition/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_form_validation_state.dart';
part 'auth_form_validation_event.dart';

class AuthFormValidationBloc
    extends Bloc<AuthFormValidationEvent, AuthFormValidationState> {
  AuthFormValidationBloc() : super(const AuthFormValidationState()) {
    on<InitEvent>(_initFormEvent);
    on<NameChangedEvent>(_onNameChangedFormEvent);
    on<EmailChangedEvent>(_onEmailChangedFormEvent);
    on<PasswordChangedEvent>(_onPasswordChangedFormEvent);

    on<RePasswordChangedEvent>(_onRePasswordChangedFormEvent);

    on<FormSubmitEvent>(_onFormSubmitEvent);

    on<FormResetEvent>(_onFormResetEvent);
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> _initFormEvent(
      InitEvent event, Emitter<AuthFormValidationState> emit) async {
    
    state.formKey?.currentState!.reset();
    emit(state.copyWith(formKey: _formKey));
  }

  Future<void> _onNameChangedFormEvent(
      NameChangedEvent event, Emitter<AuthFormValidationState> emit) async {
    emit(state.copyWith(
        formKey: _formKey,
        name: AuthValidationBlocFormItem(
            value: event.name.value,
            error: event.name.value.isValidName ? null : "Enter valid name")));
  }

  Future<void> _onEmailChangedFormEvent(
      EmailChangedEvent event, Emitter<AuthFormValidationState> emit) async {
    emit(state.copyWith(
        formKey: _formKey,
        email: AuthValidationBlocFormItem(
            value: event.email.value,
            error:
                event.email.value.isValidEmail ? null : "Enter valid email")));
  }

  Future<void> _onPasswordChangedFormEvent(
      PasswordChangedEvent event, Emitter<AuthFormValidationState> emit) async {
    final String? errorMsg;

    if (!event.password.value.isValidPassword) {
      errorMsg = "Enter valid repassword";
    } else if (event.password.value != state.rePassword.value) {
      errorMsg = "Password and Repassword isnt same";
    } else {
      errorMsg = null;
    }
    emit(state.copyWith(
        formKey: _formKey,
        password: AuthValidationBlocFormItem(
            value: event.password.value, error: errorMsg)));
  }

  Future<void> _onRePasswordChangedFormEvent(RePasswordChangedEvent event,
      Emitter<AuthFormValidationState> emit) async {
    final String? errorMsg;

    if (!event.rePassword.value.isValidPassword) {
      errorMsg =
          "Enter valid repassword Password should contain more than 5 characters";
    } else if (event.rePassword.value != state.password.value) {
      errorMsg = "Password and Repassword isnt same";
    } else {
      errorMsg = null;
    }

    emit(state.copyWith(
        formKey: _formKey,
        rePassword: AuthValidationBlocFormItem(
          value: event.rePassword.value,
          error: errorMsg,
        )));
  }

  FutureOr<void> _onFormSubmitEvent(FormSubmitEvent event, emit) {
    log(state.formKey!.currentState!.validate().toString());

    //log(state.props.toString());
    if (state.formKey!.currentState!.validate()) {
      emit(FormValidationSuccessOrFailedState(
        name: state.name,
        email: state.email,
        password: state.password,
        formKey: state.formKey,
        success: true,
      ));
    } else {
      emit(FormValidationSuccessOrFailedState(
        name: state.name,
        email: state.email,
        password: state.password,
        formKey: state.formKey,
        success: false,
      ));
    }
  }

  Future<void> _onFormResetEvent(
      FormResetEvent event, Emitter<AuthFormValidationState> emit) async {
    state.formKey?.currentState!.reset();
  }
}
