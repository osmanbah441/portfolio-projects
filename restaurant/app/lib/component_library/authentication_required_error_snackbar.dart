import 'package:flutter/material.dart';

class AuthenticationRequiredErrorSnackBar extends SnackBar {
  const AuthenticationRequiredErrorSnackBar({super.key})
      : super(
          content: const _AuthenticationRequiredErrorSnackBarMessage(),
        );
}

class _AuthenticationRequiredErrorSnackBarMessage extends StatelessWidget {
  const _AuthenticationRequiredErrorSnackBarMessage();

  @override
  Widget build(BuildContext context) {
    return const Text('authentication is requried error message');
  }
}
