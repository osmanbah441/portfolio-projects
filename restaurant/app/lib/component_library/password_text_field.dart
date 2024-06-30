import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    required this.focusNode,
    required this.enabled,
    required this.onChanged,
    required this.errorText,
    this.textInputAction,
    this.onEditingComplete,
  });

  final FocusNode focusNode;
  final bool enabled;
  final Function(String) onChanged;
  final String? errorText;
  final TextInputAction? textInputAction;
  final void Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
      enabled: enabled,
      onChanged: onChanged,
      obscureText: true,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.password),
        labelText: 'Password',
        enabled: enabled,
        errorText: errorText,
      ),
    );
  }
}
