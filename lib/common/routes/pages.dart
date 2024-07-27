import 'dart:developer';

import 'package:ai_sign_language_recognition/main.dart';
import 'package:ai_sign_language_recognition/views/authentication/blocs/auth_backend_api_bloc/auth_bloc.dart';
import 'package:ai_sign_language_recognition/views/authentication/blocs/auth_form_validation_bloc/auth_form_validation_bloc.dart';
import 'package:ai_sign_language_recognition/common/routes/names.dart';
import 'package:ai_sign_language_recognition/data/repository/auth_repository.dart';
import 'package:ai_sign_language_recognition/global.dart';
import 'package:ai_sign_language_recognition/views/application/application_view.dart';
import 'package:ai_sign_language_recognition/views/application/bloc/app_blocs.dart';
import 'package:ai_sign_language_recognition/views/authentication/email_verification/email_verification_view.dart';
import 'package:ai_sign_language_recognition/views/authentication/reset_password/bloc/can_resend_email_bloc.dart';
import 'package:ai_sign_language_recognition/views/authentication/reset_password/reset_password_view.dart';
import 'package:ai_sign_language_recognition/views/authentication/sign_up/sign_up_view.dart';
import 'package:ai_sign_language_recognition/views/authentication/sign_in/sign_in_view.dart';
import 'package:ai_sign_language_recognition/views/welcome/bloc/welcome_bloc.dart';
import 'package:ai_sign_language_recognition/views/welcome/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppPages {
  //static final FirebaseAuthRepository authRepository = FirebaseAuthRepository();

  final BuildContext context;

  const AppPages({required this.context});

  List<PageEntity> routes() {
    final FirebaseAuthRepository firebaseAuthRepository =
        context.read<FirebaseAuthRepository>();

    return [
      //route: AppRoutes.INITIAL

      PageEntity(
        route: AppRoutes.WELCOME,
        page: const WelcomeView(),
        bloc: BlocProvider(create: (_) => WelcomeBloc()),
      ),

      PageEntity(
        route: AppRoutes.INITIAL,
        page: const WelcomeView(),
        bloc: BlocProvider(create: (_) => AuthBloc(firebaseAuthRepository)),
      ),

      PageEntity(
        route: AppRoutes.APPLICATION,
        page: const ApplicationView(),
        bloc: BlocProvider(create: (_) => AppBlocs()),
      ),
      PageEntity(
        route: AppRoutes.SIGN_IN,
        page: const SignInView(),
        bloc: [
          //BlocProvider(create: (_) => AuthBloc(firebaseAuthRepository)),
          BlocProvider(create: (_) => AuthFormValidationBloc()),
        ],
      ),
      PageEntity(
        route: AppRoutes.NEEDS_EMAIL_VERIFICATION,
        page: const VerifyEmailView(),
        bloc: [
          /*  BlocProvider(create: (_) => AuthBloc(firebaseAuthRepository)),
          BlocProvider(create: (_) => AuthFormValidationBloc()), */
        ],
      ),
      PageEntity(
        route: AppRoutes.RESET_PASSWORD,
        page: const ResetPasswordView(),
        bloc: [
          //BlocProvider(create: (_) => AuthBloc(firebaseAuthRepository)),
          // BlocProvider(create: (_) => AuthFormValidationBloc()),
          BlocProvider(create: (_) => CanResendEmailBloc()),
        ],
      ),
      PageEntity(
        route: AppRoutes.SIGN_UP,
        page: const SignUpView(),
        bloc: [
          //BlocProvider(create: (_) => AuthBloc(firebaseAuthRepository)),
          //BlocProvider(create: (_) => AuthFormValidationBloc()),
        ],
      ),
    ];
  }

  List<dynamic> allBlocProviders() {
    List<dynamic> blocProviders = <dynamic>[];

    for (var route in routes()) {
      final dynamic bloc = route.bloc;

      if (bloc is List) {
        bloc.forEach((val) {
          if (!blocProviders.contains(val)) {
            blocProviders.add(val);
          }
        });
        //blocProviders.addAll(bloc);

        /* for (var value in bloc) {
          blocProviders.add(value);
        } */

        //blocProviders.add(bloc[0]);
        //blocProviders.add(bloc[1]);
      } else {
        if (!blocProviders.contains(bloc)) {
          blocProviders.add(bloc);
        }
      }
    }

    log("Bloc Providers");

    log(blocProviders.toString());

    log([...blocProviders].toString());

    return blocProviders;
  }

  MaterialPageRoute generateRouteSettings(RouteSettings settings) {
    log(settings.name.toString());
    if (settings.name != null) {
      var result = routes().where((element) => element.route == settings.name);

      if (result.isNotEmpty) {
        bool deviceFirstOpen = Global.storageService.getDeviceFirstOpen();

        //bool isLoggedIn = Global.storageService.getIsLoggedIn();

        if (result.first.route == AppRoutes.WELCOME && deviceFirstOpen) {
          return MaterialPageRoute(
              builder: (_) => result.first.page, settings: settings);
        } else {

          return MaterialPageRoute(
            builder: (_) => const InitialView(),
            settings: settings,
          );
/* 
          if (isLoggedIn) {

            return MaterialPageRoute(
                builder: (_) => ApplicationView(), settings: settings);

          } else {

            return MaterialPageRoute(
                builder: (_) => SignInView(), settings: settings);
          } */
        }
      }
    }

    return MaterialPageRoute(builder: (_) =>const InitialView(), settings: settings);
  }
}

class PageEntity {
  String route;
  Widget page;
  dynamic bloc;

  PageEntity({required this.route, required this.page, this.bloc});
}
