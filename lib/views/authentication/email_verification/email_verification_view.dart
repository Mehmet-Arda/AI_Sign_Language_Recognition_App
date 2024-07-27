import 'dart:async';

import 'package:ai_sign_language_recognition/common/exceptions/auth_exceptions.dart';
import 'package:ai_sign_language_recognition/common/routes/names.dart';
import 'package:ai_sign_language_recognition/common/values/constants/app_local_storage_constants.dart';
import 'package:ai_sign_language_recognition/common/widgets/flutter_toast.dart';
import 'package:ai_sign_language_recognition/global.dart';
import 'package:ai_sign_language_recognition/helpers/loading/loading_screen.dart';
import 'package:ai_sign_language_recognition/views/authentication/blocs/auth_backend_api_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  Timer? timer;
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      context.read<AuthBloc>().add(const AuthCheckEmailVerificationEvent());
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
              context: context,
              text: state.loadingText ?? "Please wait a moment");
        } else {
          LoadingScreen().hide();
        }
        if (state is AuthInitialState) {
          if (state.exception != null) {
            //UserNotSignedInAuthException

            toastInfo(msg: "UserNotSignedInAuthException");
          } else {
            if (context.mounted) {
              timer?.cancel();
              Navigator.of(context).pushNamed(AppRoutes.SIGN_IN);
            }
          }
        } else if (state is AuthSignedInState) {
          if (context.mounted) {
            timer?.cancel();

            Global.storageService
                .setString(AppConstants.STORAGE_USER_ID, state.user.userId);

            Navigator.of(context).pushNamed(AppRoutes.APPLICATION);
          }
        } else if (state is AuthNeedsEmailVerificationState) {
          if (state.exception != null) {
            switch (state.exception) {
              case UserNotFoundAuthException():
                toastInfo(msg: "UserNotFoundAuthException");
            }
          }
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthNeedsEmailVerificationState) {
            canResendEmail = state.canSendEmail;
          }
          return Scaffold(
            appBar: AppBar(
              title: Text("Email verification"), //context.loc.verify_email
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                        "Verification email has been send. Please check your email."),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: canResendEmail ? Colors.green : Colors.grey),
                    child: TextButton(
                      onPressed: () async {
                        if (canResendEmail) {
                          context.read<AuthBloc>().add(
                                const AuthSendEmailVerificationEvent(),
                              );
                        } else {
                          toastInfo(
                            msg:
                                "You already have send email, please wait to resend email",
                          );
                        }
                      },
                      child: Text("Resend verification email"),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      context.read<AuthBloc>().add(
                            const AuthSignOutEvent(),
                          );
                    },
                    child: Text("Return Sign-In Page / Cancel"),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
