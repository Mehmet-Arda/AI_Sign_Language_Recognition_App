import 'package:ai_sign_language_recognition/utils/dialogs/generic_dialog.dart';
import 'package:flutter/widgets.dart';

Future<void> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Log out",
    content: "Are you sure you want to log out?",
    optionsBuilder: () => {
      "Cansel": false,
      "Log out": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
