part of 'sign_in_cubit.dart';

final class SignInState extends Equatable {
  const SignInState(
      {this.password = const Password.unvalidated(''),
      this.username = const Username.unvalidated(''),
      this.submissionStatus = SubmissionStatus.idle});

  final Password password;
  final Username username;
  final SubmissionStatus submissionStatus;

  SignInState copyWith({
    Password? password,
    Username? username,
    SubmissionStatus? submissionStatus,
  }) =>
      SignInState(
          password: password ?? this.password,
          username: username ?? this.username,
          submissionStatus: submissionStatus ?? this.submissionStatus);

  @override
  List<Object?> get props => [username, password, submissionStatus];
}

enum SubmissionStatus {
  idle,
  inProgress,
  invalidCredentialsError,
  genericError,
  success;

  bool get isSuccess => this == SubmissionStatus.success;
  bool get isInProgress => this == SubmissionStatus.inProgress;
  bool get isGenericError => this == SubmissionStatus.genericError;
  bool get isInvalidCredentialsError =>
      this == SubmissionStatus.invalidCredentialsError;

  bool get hasSubmissionError => isGenericError || isInvalidCredentialsError;
}
