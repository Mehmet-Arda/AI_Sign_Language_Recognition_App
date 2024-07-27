import 'dart:developer';
import 'dart:js_interop';

import 'package:ai_sign_language_recognition/common/exceptions/auth_exceptions.dart';
import 'package:ai_sign_language_recognition/common/routes/names.dart';
import 'package:ai_sign_language_recognition/common/widgets/auth_custom_form_field.dart';
import 'package:ai_sign_language_recognition/common/widgets/flutter_toast.dart';
import 'package:ai_sign_language_recognition/helpers/loading/loading_screen.dart';
import 'package:ai_sign_language_recognition/models/auth_validation_bloc_form_item.dart';
import 'package:ai_sign_language_recognition/utils/dialogs/error_dialog.dart';
import 'package:ai_sign_language_recognition/utils/dialogs/password_reset_email_sent_dialog.dart';
import 'package:ai_sign_language_recognition/views/authentication/blocs/auth_backend_api_bloc/auth_bloc.dart';
import 'package:ai_sign_language_recognition/views/authentication/blocs/auth_form_validation_bloc/auth_form_validation_bloc.dart';
import 'package:ai_sign_language_recognition/views/authentication/reset_password/bloc/can_resend_email_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  late final TextEditingController _controller;

  late final AuthBloc authBloc;

  late final AuthFormValidationBloc formBloc;

  late final CanResendEmailBloc canResendBloc;

  bool canResend = true;

  @override
  void initState() {
    _controller = TextEditingController();

    authBloc = context.read<AuthBloc>();

    formBloc = context.read<AuthFormValidationBloc>();

    canResendBloc = context.read<CanResendEmailBloc>();

    formBloc.add(const InitEvent());

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state.isLoading) {
              LoadingScreen().show(
                  context: context,
                  text: state.loadingText ?? "Please wait a moment");
            } else {
              LoadingScreen().hide();
            }

            if (state is AuthInitialState) {
              if (context.mounted) {
                // timer?.cancel();
                Navigator.of(context).pushNamed(AppRoutes.SIGN_IN);
              }
            }

            if (state is AuthForgotPasswordState) {
              if (state.hasSentEmail) {
                _controller.clear();
                await showPasswordResetSentDialog(context);
              }

              if (state.exception != null) {
                switch (state.exception) {
                  case InvalidEmailAuthException():
                    showErrorDialog(context, "InvalidEmailAuthException");
                    break;
                  case UserNotFoundAuthException():
                    showErrorDialog(context, "UserNotFoundAuthException");
                    break;
                  case GenericAuthException():
                    showErrorDialog(context, "GenericAuthException");
                }
              }
            }
          },
        ),
        BlocListener<AuthFormValidationBloc, AuthFormValidationState>(
          listener: (context, state) async {
            log(state.runtimeType.toString());
            if (state is FormValidationSuccessOrFailedState) {
              if (state.success) {
                authBloc.add(AuthForgotPasswordEvent(
                  email: state.email.value,
                ));
              } else {
                showErrorDialog(context, "Please enter valid email");
              }
            }
          },
        ),
      ],
      child: BlocBuilder<AuthFormValidationBloc, AuthFormValidationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Forgot Password"),
            ),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                      "If you forgot your password, you can reset here."),
                  AuthCustomFormField(
                    hintText: "Your email adress...",
                    onChange: (val) {
                      formBloc.add(EmailChangedEvent(
                          email: AuthValidationBlocFormItem(value: val!)));
                    },
                    validator: (val) {
                      return state.email.error;
                    },
                    autoCorrect: false,
                    autoFocus: true,
                    textInputType: TextInputType.emailAddress,
                  ),
                  BlocBuilder<CanResendEmailBloc, CanResendEmailState>(
                    builder: (context, state) {
                      canResend = state.canResendEmail;

                      return TextButton(
                        onPressed: () {
                          if (canResend) {
                            formBloc.add(const FormSubmitEvent());

                            canResendBloc.add(const CanResendEmailEvent());
                          } else {

                            toastInfo(msg: "You already sent email, please wait.");


                          }
                        },
                        child: const Text("Send password reset email"),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      authBloc.add(const AuthNavigateToSignInViewEvent());
                    },
                    child: const Text("Back to Sign-In Page"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
