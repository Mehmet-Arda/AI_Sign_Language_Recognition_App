import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthCustomFormField extends StatelessWidget {
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String?)? onChange;
  final bool obscureText;

  final bool autoCorrect;
  final bool autoFocus;

  final TextInputType textInputType;

  const AuthCustomFormField(
      {super.key,
      required this.hintText,
      this.inputFormatters,
      required this.validator,
      required this.autoCorrect,
      required this.autoFocus,
      required this.textInputType,
      this.onChange,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        inputFormatters: inputFormatters,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
        onChanged: onChange,
        obscureText: obscureText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autocorrect: autoCorrect,
        autofocus: autoFocus,
        keyboardType: textInputType,
      ),
    );
  }
}
