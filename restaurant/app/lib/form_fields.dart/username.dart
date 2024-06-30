import 'package:equatable/equatable.dart';
import 'form_input.dart';

class Username extends FormInput<String, UsernameValidationError>
    with EquatableMixin {
  const Username.unvalidated([
    super.value = '',
  ])  : isAlreadyRegistered = false,
        super.pure();

  const Username.validated(
    super.value, {
    this.isAlreadyRegistered = false,
  }) : super.dirty();

  static final _usernameRegex = RegExp(
    r'^(?=.{1,20}$)(?![_])(?!.*[_.]{2})[a-zA-Z0-9_]+(?<![_])$',
  );

  final bool isAlreadyRegistered;

  @override
  UsernameValidationError? validator(String value) {
    return value.isEmpty
        ? UsernameValidationError.empty
        : (isAlreadyRegistered
            ? UsernameValidationError.alreadyTaken
            : (_usernameRegex.hasMatch(value)
                ? null
                : UsernameValidationError.invalid));
  }

  @override
  List<Object?> get props => [
        value,
        isAlreadyRegistered,
      ];
}

enum UsernameValidationError {
  empty,
  invalid,
  alreadyTaken;

  String get message => switch (this) {
        UsernameValidationError.empty => 'enter your username address.',
        UsernameValidationError.invalid => 'invalid username address.',
        UsernameValidationError.alreadyTaken =>
          'this username is already register',
      };
}
