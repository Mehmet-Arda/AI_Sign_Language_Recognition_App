import 'package:ai_sign_language_recognition/common/routes/routes.dart';
import 'package:ai_sign_language_recognition/common/values/constants/app_local_storage_constants.dart';
import 'package:ai_sign_language_recognition/data/repository/auth_repository.dart';
import 'package:ai_sign_language_recognition/data/repository/cloud_db_repository.dart';
import 'package:ai_sign_language_recognition/firebase_options.dart';
import 'package:ai_sign_language_recognition/global.dart';
import 'package:ai_sign_language_recognition/helpers/loading/loading_screen.dart';
import 'package:ai_sign_language_recognition/views/application/application_view.dart';
import 'package:ai_sign_language_recognition/views/authentication/blocs/auth_backend_api_bloc/auth_bloc.dart';
import 'package:ai_sign_language_recognition/views/authentication/sign_up/sign_up_view.dart';
import 'package:ai_sign_language_recognition/views/authentication/sign_in/sign_in_view.dart';
import 'package:ai_sign_language_recognition/views/welcome/welcome_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  await Global.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FirebaseAuthRepository>(
          create: (context) => FirebaseAuthRepository(),
        ),
        RepositoryProvider<FirebaseCloudDatabaseRepository>(
          create: (context) => FirebaseCloudDatabaseRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [...AppPages(context: context).allBlocProviders()],
        child: ScreenUtilInit(
            builder: (context, child) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                      appBarTheme: const AppBarTheme(
                          iconTheme: IconThemeData(color: Colors.black),
                          elevation: 0,
                          backgroundColor: Colors.white)),
                  onGenerateRoute:
                      AppPages(context: context).generateRouteSettings,
                )),
      ),
    );
  }
}

class InitialView extends StatefulWidget {
  const InitialView({super.key});

 

  @override
  State<InitialView> createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> {
  late final AuthBloc authBloc;
  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    authBloc.add(const AuthInitializeEvent());

    return BlocListener<AuthBloc, AuthState>(
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
                Navigator.of(context).pushNamed(AppRoutes.SIGN_IN);
              }

            } else if (state is AuthRegisteringState) {

              if (context.mounted) {
                Navigator.of(context).pushNamed(AppRoutes.SIGN_UP);
              }

            } else if (state is AuthSignedInState) {

              if (context.mounted) {


                Global.storageService
                    .setString(AppConstants.STORAGE_USER_ID, state.user.userId);

                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.APPLICATION, (route) => false);
              }
              

            } else if (state is AuthNeedsEmailVerificationState) {

                if (context.mounted) {
                Navigator.of(context).pushNamed(AppRoutes.NEEDS_EMAIL_VERIFICATION);
              }
              
                
            }else if(state is AuthForgotPasswordState){
              if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.RESET_PASSWORD,(route) => false);
                }
            }
          },
        );
  }
}
