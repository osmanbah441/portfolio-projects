import 'form_input.dart';

final class Password extends FormInput<String, PasswordValidationError> {
  const Password.unvalidated([super.value = '']) : super.pure();
  const Password.validated(super.value) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    return value.isEmpty
        ? PasswordValidationError.empty

        // TODO: remove comment

        // : (value.length < 8)
        //     ? PasswordValidationError.invalid
        : null;
  }
}

enum PasswordValidationError {
  empty,
  invalid;

  String get message => switch (this) {
        PasswordValidationError.empty => 'enter a password.',
        PasswordValidationError.invalid => 'use at least 8 characters.',
      };
}
