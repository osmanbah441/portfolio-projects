import 'package:equatable/equatable.dart';
import 'form_input.dart';
import 'password.dart';

class PasswordConfirmation
    extends FormInput<String, PasswordConfirmationValidationError>
    with EquatableMixin {
  const PasswordConfirmation.unvalidated([
    super.value = '',
  ])  : password = const Password.unvalidated(),
        super.pure();

  const PasswordConfirmation.validated(
    super.value, {
    required this.password,
  }) : super.dirty();

  final Password password;

  @override
  PasswordConfirmationValidationError? validator(String value) {
    return value.isEmpty
        ? PasswordConfirmationValidationError.empty
        : (value == password.value
            ? null
            : PasswordConfirmationValidationError.invalid);
  }

  @override
  List<Object?> get props => [
        value,
        password,
      ];
}

enum PasswordConfirmationValidationError {
  empty,
  invalid;

  String get message => switch (this) {
        PasswordConfirmationValidationError.empty => 'enter a password.',
        PasswordConfirmationValidationError.invalid => 'password mismatch',
      };
}
