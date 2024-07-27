import 'dart:developer';

import 'package:ai_sign_language_recognition/common/exceptions/auth_exceptions.dart';
import 'package:ai_sign_language_recognition/common/routes/names.dart';
import 'package:ai_sign_language_recognition/common/values/constants/app_local_storage_constants.dart';
import 'package:ai_sign_language_recognition/common/widgets/auth_custom_form_field.dart';
import 'package:ai_sign_language_recognition/common/widgets/flutter_toast.dart';
import 'package:ai_sign_language_recognition/global.dart';
import 'package:ai_sign_language_recognition/helpers/loading/loading_screen.dart';
import 'package:ai_sign_language_recognition/models/auth_validation_bloc_form_item.dart';
import 'package:ai_sign_language_recognition/views/authentication/blocs/auth_backend_api_bloc/auth_bloc.dart';
import 'package:ai_sign_language_recognition/views/authentication/blocs/auth_form_validation_bloc/auth_form_validation_bloc.dart';
import 'package:ai_sign_language_recognition/views/common_widgets.dart';

import 'package:ai_sign_language_recognition/views/authentication/sign_up/register_controller.dart';
import 'package:ai_sign_language_recognition/utils/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:developer' as devtools show log;

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  late final AuthBloc authBloc;

  late final AuthFormValidationBloc formBloc;

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();

    formBloc = context.read<AuthFormValidationBloc>();

    //context.read<AuthBloc>().add(const AuthInitializeEvent());
    //authBloc.add(const AuthInitializeEvent());
    formBloc.add(const InitEvent());

    super.initState();
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

            if (state is AuthRegisteringState) {
              switch (state.exception) {
                case UserAlreadyRegisteredAuthException():
                  await toastInfo(
                    msg: "UserAlreadyRegisteredAuthException",
                  ); //showErrorDialog(context, "User Not Found");
                  break;
                case InvalidEmailAuthException():
                  await toastInfo(
                    msg: "InvalidEmailAuthException",
                  ); //showErrorDialog(context, "User Not Found");
                  break;
                case InvalidPasswordAuthException():
                  await toastInfo(
                    msg: "InvalidPasswordAuthException",
                  ); //showErrorDialog(context, "User Not Found");
                  break;
                case WeakPasswordAuthException():
                  await toastInfo(
                    msg: "WeakPasswordAuthException",
                  ); //showErrorDialog(context, "User Not Found");
                  break;

                case UserNotSignedInAuthException():
                  await toastInfo(
                    msg: "UserNotSignedInAuthException",
                  ); //showErrorDialog(context, "User Not Found");
                  break;
                case GenericAuthException():
                  await toastInfo(
                    msg: "GenericAuthException",
                  ); //showErrorDialog(context, "User Not Found");
                  break;
              }
            } else if (state is AuthNeedsEmailVerificationState) {
              if (state.exception != null) {
                // if state.exception != null
                switch (state.exception) {
                  case UserNotFoundAuthException():
                    await toastInfo(
                      msg: "User not found email verification exception",
                    ); //showErrorDialog(context, "User Not Found");
                    break;
                }
              } else {
                if (context.mounted) {
                  Navigator.of(context).pushNamed(
                    AppRoutes.NEEDS_EMAIL_VERIFICATION,
                  );
                }
              }
            } else if (state is AuthInitialState) {
              if (context.mounted) {
                Navigator.of(context).pushNamed(AppRoutes.SIGN_IN);
              }
            }
          },
        ),
        BlocListener<AuthFormValidationBloc, AuthFormValidationState>(
          listener: (context, state) async {
            devtools.log(state.runtimeType.toString());
            if (state is FormValidationSuccessOrFailedState) {
              if (state.success) {
                authBloc.add(AuthSignUpEvent(
                  name: state.name.value,
                  email: state.email.value,
                  password: state.password.value,
                ));
              } else {
                showErrorDialog(context, "Please enter valid values");
              }
            }
          },
        ),
      ],
      child: Container(
        child: BlocBuilder<AuthFormValidationBloc, AuthFormValidationState>(
          builder: (context, state) {
            //devtools.log(state.formKey.toString());

            //devtools.log(state.runtimeType.toString());
            return Container(
              color: Colors.white,
              child: SafeArea(
                  child: Scaffold(
                backgroundColor: Colors.white,
                appBar: buildAppBar("Sign In"),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 66.h),
                        padding: EdgeInsets.only(left: 25.h),
                        child: Form(
                          key: state.formKey,
                          child: Column(
                            children: [
                              reusableText("Name"),
                              SizedBox(
                                height: 5.h,
                              ),
                              AuthCustomFormField(
                                hintText: "Name",
                                onChange: (val) {
                                  formBloc.add(NameChangedEvent(
                                      name: AuthValidationBlocFormItem(
                                          value: val!)));
                                },
                                validator: (val) {
                                  return state.name.error;
                                },
                                autoCorrect: false,
                                autoFocus: false,
                                textInputType: TextInputType.name,
                              ),
                              reusableText("Email"),
                              SizedBox(
                                height: 5.h,
                              ),
                              AuthCustomFormField(
                                  hintText: "Email",
                                  onChange: (val) {
                                    formBloc.add(EmailChangedEvent(
                                        email: AuthValidationBlocFormItem(
                                            value: val!)));
                                  },
                                  validator: (val) {
                                    //devtools.log(state.email.error == null ?" valid email" :  state.email.error.toString());
                                    return state.email.error;
                                  },
                                  autoCorrect: false,
                                  autoFocus: false,
                                  textInputType: TextInputType.emailAddress),
                              reusableText("Password"),
                              SizedBox(
                                height: 5.h,
                              ),
                              AuthCustomFormField(
                                hintText: "Password",
                                onChange: (val) {
                                  formBloc.add(PasswordChangedEvent(
                                      password: AuthValidationBlocFormItem(
                                          value: val!)));
                                },
                                validator: (val) {
                                  return state.password.error;
                                },autoCorrect: false,
                                autoFocus: false,
                                textInputType: TextInputType.visiblePassword,
                              ),
                              reusableText("Re-Password"),
                              SizedBox(
                                height: 5.h,
                              ),
                              AuthCustomFormField(
                                hintText: "Re-Password",
                                onChange: (val) {
                                  formBloc.add(
                                    RePasswordChangedEvent(
                                      rePassword: AuthValidationBlocFormItem(
                                        value: val!,
                                      ),
                                    ),
                                  );
                                },
                                validator: (val) {
                                  return state.rePassword.error;
                                },autoCorrect: false,
                                autoFocus: false,
                                textInputType: TextInputType.name,
                              ),
                            ],
                          ),
                        ),
                      ),
                      forgotPassword(),
                      buildLogInAndRegButton("Sign UP", "signup", () async {
                        devtools.log("sign up clicked");
                        formBloc.add(const FormSubmitEvent());
                        //SignInController(context: context).handleSignIn("email");
                      }),
                      SizedBox(
                        height: 30.h,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            formBloc.add(const FormResetEvent());
                          },
                          child: const Text("RESET")),
                      SizedBox(
                        height: 30.h,
                      ),
                      buildLogInAndRegButton(
                          "Already have a account?", "signin", () {
                        devtools.log("sign in return button clicked");

                        authBloc.add(
                          const AuthNavigateToSignInViewEvent(),
                        );

                        //Navigator.of(context).pushNamed("/register");
                      })
                    ],
                  ),
                ),
              )),
            );
          },
        ),
      ),
    );
  }
}
