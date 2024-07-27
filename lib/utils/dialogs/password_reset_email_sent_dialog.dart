import 'package:ai_sign_language_recognition/utils/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: "Password Reset",
    content: "We have now sent you a password reset link. Check your email.",
    optionsBuilder: () => {
      "OK": null,
    },
  );
}
