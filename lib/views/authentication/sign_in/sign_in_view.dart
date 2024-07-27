import 'dart:math';

import 'package:ai_sign_language_recognition/models/cloud_db_user_model.dart';
import 'package:ai_sign_language_recognition/views/application/bloc/app_blocs.dart';
import 'package:ai_sign_language_recognition/views/authentication/blocs/auth_backend_api_bloc/auth_bloc.dart';
import 'package:ai_sign_language_recognition/views/authentication/blocs/auth_form_validation_bloc/auth_form_validation_bloc.dart';
import 'package:ai_sign_language_recognition/models/auth_validation_bloc_form_item.dart';
import 'package:ai_sign_language_recognition/common/exceptions/auth_exceptions.dart';
import 'package:ai_sign_language_recognition/common/routes/names.dart';
import 'package:ai_sign_language_recognition/common/values/constants/app_local_storage_constants.dart';
import 'package:ai_sign_language_recognition/common/widgets/auth_custom_form_field.dart';
import 'package:ai_sign_language_recognition/common/widgets/flutter_toast.dart';
import 'package:ai_sign_language_recognition/global.dart';
import 'package:ai_sign_language_recognition/helpers/loading/loading_screen.dart';
import 'package:ai_sign_language_recognition/views/common_widgets.dart';

import 'package:ai_sign_language_recognition/views/authentication/sign_in/sign_in_controller.dart';
import 'package:ai_sign_language_recognition/utils/dialogs/error_dialog.dart';
import 'package:ai_sign_language_recognition/utils/dialogs/loading_dialog.dart';
import 'package:ai_sign_language_recognition/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:developer' as devtools show log;

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  //late final TextEditingController _emailTextController;
  //late final TextEditingController _passwordTextController;
  //CloseDialog? _closeDialogHandle;

  late final AuthBloc authBloc;

  late final AuthFormValidationBloc formBloc;

  //final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    //_emailTextController = TextEditingController();
    //_passwordTextController = TextEditingController();

    //final SignInFormBloc formBloc = context.read<SignInFormBloc>();

    //formBloc.add(const InitEvent());

    authBloc = context.read<AuthBloc>();

    formBloc = context.read<AuthFormValidationBloc>();

    //context.read<AuthBloc>().add(const AuthInitializeEvent());

    authBloc.add(const AuthInitializeEvent());

    formBloc.add(const InitEvent());

    super.initState();
  }

  @override
  void dispose() {
    // _emailTextController.dispose();
    // _passwordTextController.dispose();
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
              // if state.exception != null
              switch (state.exception) {
                case UserNotFoundAuthException():
                  await toastInfo(
                    msg: "User not found",
                  ); //showErrorDialog(context, "User Not Found");
                  break;
                case InvalidEmailAuthException():
                  await toastInfo(
                    msg: "Invalid email",
                  ); //showErrorDialog(context, "User Not Found");
                  break;
                case UserDisabledAuthException():
                  await toastInfo(
                    msg: "User is disabled",
                  ); //showErrorDialog(context, "User Not Found");
                  break;
                case WrongPasswordAuthException():
                  await toastInfo(
                    msg: "Wrong password",
                  ); //showErrorDialog(context, "User Not Found");
                  break;
                case GenericAuthException():
                  await toastInfo(
                    msg: "Some error occured",
                  ); //showErrorDialog(context, "User Not Found");
                  break;
              }
            } else if (state is AuthRegisteringState) {
              if (context.mounted) {
                Navigator.of(context).pushNamed(AppRoutes.SIGN_UP);
              }
            } else if (state is AuthSignedInState) {
              if (context.mounted) {
                Global.storageService.setString(
                  AppConstants.STORAGE_USER_ID,
                  state.user.userId,
                );

                final CloudUserModel _userModel = state.user;

                context.read<AppBlocs>().add(AppInitializeEvent(
                      index: 0,
                      cloudUserModel: _userModel,
                    ));

                Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.APPLICATION, (route) => false);
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
            } else if (state is AuthForgotPasswordState) {
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.RESET_PASSWORD, (route) => false);
              }
            }
          },
        ),
        BlocListener<AuthFormValidationBloc, AuthFormValidationState>(
          listener: (context, state) async {
            devtools.log(state.runtimeType.toString());
            if (state is FormValidationSuccessOrFailedState) {
              if (state.success) {
                authBloc.add(AuthSignInEvent(
                    email: state.email.value, password: state.password.value));
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
                      buildThirdPartyLogin(context),
                      Center(
                          child: reusableText("Or use email account signin")),
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
                                autoFocus: true,
                                textInputType: TextInputType.name,
                              ),

                              /*  buildTextField("enter your email address", "email",
                                 (value) {
                               context.read<SignInBloc>().add(EmailEvent(value));
                             }, _emailTextController), */
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
                                textInputType: TextInputType.emailAddress,
                              ),
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
                                },
                                autoCorrect: false,
                                autoFocus: false,
                                textInputType: TextInputType.visiblePassword,
                              ),

                              /* buildTextField("enter your password", "password",
                                 (value) {
                               context.read<SignInBloc>().add(PasswordEvent(value));
                             }, _passwordTextController), */
                            ],
                          ),
                        ),
                      ),
                      //forgotPassword(),

                      buildLogInAndRegButton(
                          "Forgot password", "forgotpassword", () async {
                        devtools.log("forgot password clicked");
                        authBloc.add(const AuthForgotPasswordEvent());
                        //SignInController(context: context).handleSignIn("email");
                      }),
                      SizedBox(
                        height: 30.h,
                      ),
                      buildLogInAndRegButton("Signin", "signin", () async {
                        devtools.log("signin clicked");
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
                      buildLogInAndRegButton("Register", "register", () {
                        devtools.log("register clicked");

                        authBloc.add(
                          const AuthNavigateToSignUpViewEvent(),
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
