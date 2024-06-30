import 'package:equatable/equatable.dart';

import 'form_input.dart';

class Email extends FormInput<String, EmailValidationError>
    with EquatableMixin {
  const Email.unvalidated([
    super.value = '',
  ])  : isAlreadyRegistered = false,
        super.pure();

  const Email.validated(
    super.value, {
    this.isAlreadyRegistered = false,
  }) : super.dirty();

  static final _emailRegex = RegExp(
    '^(([\\w-]+\\.)+[\\w-]+|([a-zA-Z]|[\\w-]{2,}))@((([0-1]?'
    '[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.'
    '([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])'
    ')|([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,4})\$',
  );

  final bool isAlreadyRegistered;

  @override
  EmailValidationError? validator(String value) {
    return value.isEmpty
        ? EmailValidationError.empty
        : (isAlreadyRegistered
            ? EmailValidationError.alreadyRegistered
            : (_emailRegex.hasMatch(value)
                ? null
                : EmailValidationError.invalid));
  }

  @override
  List<Object?> get props => [
        value,
        isAlreadyRegistered,
      ];
}

enum EmailValidationError {
  empty,
  invalid,
  alreadyRegistered;

  String get message => switch (this) {
        EmailValidationError.empty => 'enter your email address.',
        EmailValidationError.invalid => 'invalid email address.',
        EmailValidationError.alreadyRegistered =>
          'this email is already register',
      };
}
