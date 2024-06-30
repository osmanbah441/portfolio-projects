import 'form_input.dart';

export 'email.dart';
export 'password.dart';
export 'password_confirmation.dart';
export 'username.dart';

final class FormFields {
  static bool validate(List<FormInput> inputs) =>
      inputs.every((i) => i.isValid);
}

enum SubmissionStatus {
  idle,
  inProgress,
  success,
  error;

  bool get isSuccess => this == SubmissionStatus.success;
  bool get isError => this == SubmissionStatus.error;
  bool get isInprogress => this == SubmissionStatus.inProgress;
}
