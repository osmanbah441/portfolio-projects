import 'package:flutter/material.dart';

class GenericErrorSnackBar extends SnackBar {
  const GenericErrorSnackBar({super.key})
      : super(
          content:
              const Center(child: Text('no connect to the internet exception')),
        );
}
