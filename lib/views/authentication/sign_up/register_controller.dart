/* import 'dart:developer';

import 'package:ai_sign_language_recognition/common/widgets/flutter_toast.dart';
import 'package:ai_sign_language_recognition/pages/register/blocs/register.blocs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterLogic {
  final BuildContext context;

  const RegisterLogic({required this.context});

  Future<void> handleEmailRegister() async {
    final state = context.read<RegisterBlocs>().state;

    String userName = state.userName;
    String email = state.email;
    String password = state.password;
    String rePassword = state.rePassword;

    if (userName.isEmpty) {
      log("username empty");
      toastInfo(msg: "Username is empty");

      return;
    }

    if (email.isEmpty) {
      log("email empty");
      toastInfo(msg: "email is empty");
      return;
    }

    if (password.isEmpty) {
      log("password empty");
      toastInfo(msg: "password is empty");
      return;
    }

    if (rePassword.isEmpty) {
      log("rePassword empty");
      toastInfo(msg: "rePassword is empty");
      return;
    }

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        await credential.user?.sendEmailVerification();
        await credential.user?.updateDisplayName(userName);

        log("An email has been sent yo your registered email address");

        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
      } else if (e.code == "email-already-in-use") {
      } else if (e.code == "invalid-email") {}
    }
  }
}
 */