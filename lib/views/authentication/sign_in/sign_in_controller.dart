/* import 'dart:developer';

import 'package:ai_sign_language_recognition/common/values/constants/app_local_storage_constants.dart';
import 'package:ai_sign_language_recognition/common/widgets/flutter_toast.dart';
import 'package:ai_sign_language_recognition/global.dart';
import 'package:ai_sign_language_recognition/pages/sign_in/bloc/sign_in_blocs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInController {
  final BuildContext context;

  const SignInController({required this.context});

  Future<void> handleSignIn(String type) async {
    try {
      if (type == "email") {
        final state = context.read<SignInBloc>().state;
        String emailAddress = state.email;
        String password = state.password;

        if (emailAddress.isEmpty) {
          toastInfo(msg: "Email is empty");
        }

        if (password.isEmpty) {
          toastInfo(msg: "Password is empty");
        }

        try {
          final credentials = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: emailAddress, password: password);

          if (credentials.user == null) {
            log("you dont exist");
            toastInfo(msg: "you dont exist");
          }

          if (!credentials.user!.emailVerified) {
            log("your email is not verified");
            toastInfo(msg: "your email is not verified");
          }

          var user = credentials.user;

          if (user != null) {
            log("you exist");
            toastInfo(msg: "you exist");

            Global.storageService
                .setString(AppConstants.STORAGE_USER_TOKEN_KEY, "12345678");

            Navigator.of(context)
                .pushNamedAndRemoveUntil("/application", (route) => false);
          } else {
            log("user not found");
            toastInfo(msg: "user not found");
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == "user-not-found") {
            log("user not found");
            toastInfo(msg: "user not found");
          } else if (e.code == "wrong-password") {
            log("password is wrong");
            toastInfo(msg: "password is wrong");
          } else if (e.code == "invalid-email") {
            log("invalid email");
            toastInfo(msg: "invalid email");
          }
        }
      }
    } catch (e) {}
  }
}
 */