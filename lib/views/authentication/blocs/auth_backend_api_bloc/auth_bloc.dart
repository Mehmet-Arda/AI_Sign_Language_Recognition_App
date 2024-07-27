import 'dart:async';
import 'dart:developer';
import 'package:ai_sign_language_recognition/data/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

import "package:flutter/foundation.dart" show immutable;
import 'package:ai_sign_language_recognition/models/cloud_db_user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';

part "auth_state.dart";

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthRepository authRepository;

  //final _formKey = GlobalKey<FormState>();

  AuthBloc(this.authRepository)
      : super(const AuthUninitializedState(exception: null, isLoading: true)) {
    on<AuthInitializeEvent>(_initAuthEvent);

    on<AuthSignInEvent>(_authSignInEvent);

    on<AuthSignUpEvent>(_authSignUpEvent);

    on<AuthSignOutEvent>(_authSignOutEvent);

    on<AuthSendEmailVerificationEvent>(_authSendEmailVerificationEvent);

    on<AuthNavigateToSignUpViewEvent>(_authNavigateToSignUpViewEvent);

    on<AuthNavigateToSignInViewEvent>(_authNavigateToSignInViewEvent);

    on<AuthCheckEmailVerificationEvent>(_authCheckEmailVerificationEvent);

    on<AuthForgotPasswordEvent>(_authForgotPasswordEvent);
  }

  FutureOr<void> _initAuthEvent(
      AuthInitializeEvent event, Emitter<AuthState> emit) async {
    log("Auth initialize event triggered");

    //emit(const AuthLoadingState(loadingText: "Please wait a moment 123"));

    emit(const AuthInitialState(
      exception: null,
      isLoading: true,
    ));
    await Future.delayed(const Duration(seconds: 3));

    //emit(const AuthLoadingState(loadingText: "Please wait a moment 456"));
    //await Future.delayed(const Duration(seconds: 3));
    await authRepository.initialize();

    log("Firebase Auth Bloc Initialized");

    final user = authRepository.getCurrentUser;

    if (user == null) {
      emit(const AuthInitialState(
        exception: null,
        isLoading: false,
      ));
    } else if (!user.isEmailVerified) {
      emit(const AuthNeedsEmailVerificationState(
        exception: null,
        isLoading: false,
      ));
    } else {
      emit(AuthSignedInState(
        user: user,
        isLoading: false,
      ));
    }
  }

  FutureOr<void> _authSendEmailVerificationEvent(event, emit) async {
    //emit(const AuthLoadingState());

    try {
      await authRepository.sendEmailVerification();
      emit(
        const AuthNeedsEmailVerificationState(
          exception: null,
          isLoading: false,
          canSendEmail: false,
        ),
      );

      await Future.delayed(const Duration(seconds: 5));

      emit(
        const AuthNeedsEmailVerificationState(
          exception: null,
          isLoading: false,
          canSendEmail: true,
        ),
      );
    } on Exception catch (e) {
      emit(AuthNeedsEmailVerificationState(
        exception: e,
        isLoading: false,
      ));
    }
  }

  FutureOr<void> _authCheckEmailVerificationEvent(event, emit) async {
    //emit(const AuthLoadingState());

    await authRepository.refreshCurrentUser();

    final user = authRepository.getCurrentUser;

    if (user != null) {
      if (user.isEmailVerified) {
        emit(AuthSignedInState(
          user: user,
          isLoading: false,
        ));
      } else {
        emit(const AuthNeedsEmailVerificationState(
          exception: null,
          isLoading: false,
        ));
      }
    } else {}
  }

  FutureOr<void> _authForgotPasswordEvent(event, emit) async {
    //emit(const AuthLoadingState());

    emit(const AuthForgotPasswordState(
      hasSentEmail: false,
      isLoading: false,
      exception: null,
    ));

    try {
      await authRepository.sendEmailVerification();
    } on Exception catch (e) {
      emit(AuthNeedsEmailVerificationState(
        exception: e,
        isLoading: false,
      ));
    }
  }

  FutureOr<void> _authNavigateToSignUpViewEvent(event, emit) async {
    //emit(const AuthLoadingState());

    emit(const AuthInitialState(
      exception: null,
      isLoading: false,
    ));
  }

  FutureOr<void> _authNavigateToSignInViewEvent(event, emit) async {
    //emit(const AuthLoadingState());

    emit(const AuthInitialState(
      exception: null,
      isLoading: false,
    ));
  }

  FutureOr<void> _authSignOutEvent(event, emit) async {
    //emit(const AuthLoadingState());

    try {
      await authRepository.signOut();
      emit(const AuthInitialState(
        exception: null,
        isLoading: false,
      ));
    } on Exception catch (e) {
      emit(AuthInitialState(
        exception: e,
        isLoading: false,
      ));
    }
  }

  FutureOr<void> _authSignUpEvent(event, emit) async {
    final name = event.name;
    log(name);
    final email = event.email;
    log(email);
    final password = event.password;
    log(password);

    //emit(const AuthLoadingState());

    try {
      final user = await authRepository.createUser(
        email: email,
        password: password,
      );

      await authRepository.sendEmailVerification();

      emit(const AuthNeedsEmailVerificationState(
        exception: null,
        isLoading: false,
        canSendEmail: false,
      ));

      await Future.delayed(const Duration(seconds: 5));

      emit(const AuthNeedsEmailVerificationState(
        exception: null,
        isLoading: false,
        canSendEmail: true,
      ));
    } on Exception catch (e) {
      emit(
        AuthRegisteringState(
          exception: e,
          isLoading: false,
        ),
      );
    }
  }

  FutureOr<void> _authSignInEvent(event, emit) async {
    final email = event.email;
    log(email);
    final password = event.password;
    log(password);

    //emit(const AuthLoadingState(loadingText: "Please wait a moment 123"));

    await Future.delayed(const Duration(seconds: 3));

    emit(const AuthInitialState(
      exception: null,
      isLoading: false,
    ));

    try {
      final user = await authRepository.signIn(
        email: event.email,
        password: event.password,
      );

      if (!user.isEmailVerified) {
        emit(const AuthInitialState(
          exception: null,
          isLoading: false,
        ));

        emit(const AuthNeedsEmailVerificationState(
          exception: null,
          isLoading: false,
        ));
      } else {
        emit(const AuthInitialState(
          exception: null,
          isLoading: false,
        ));

        emit(AuthSignedInState(
          user: user,
          isLoading: false,
        ));
      }
    } on Exception catch (e) {
      emit(AuthInitialState(
        exception: e,
        isLoading: false,
      ));
    }
  }
}
