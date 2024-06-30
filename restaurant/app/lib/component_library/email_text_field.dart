import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    required this.emailFocusNode,
    required this.onChanged,
    required this.enabled,
    required this.errorText,
    this.onEditingComplete,
    this.textInputAction,
  });

  final FocusNode emailFocusNode;
  final Function(String) onChanged;
  final bool enabled;
  final String? errorText;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: emailFocusNode,
      enabled: enabled,
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.alternate_email),
        enabled: enabled,
        labelText: 'Email',
        errorText: errorText,
      ),
    );
  }
}
