import 'package:app/api/api.dart';
import 'package:app/domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../form_fields.dart/form_fields.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({
    required this.userRepository,
  }) : super(
          const SignUpState(),
        );

  final Api userRepository;

  void onEmailChanged(String newValue) {
    final newState = state.copyWith(
      email: state.email.shouldValidate
          ? Email.validated(
              newValue,
              isAlreadyRegistered: newValue == state.email.value
                  ? state.email.isAlreadyRegistered
                  : false,
            )
          : Email.unvalidated(newValue),
    );
    emit(newState);
  }

  void onEmailUnfocused() {
    final newState = state.copyWith(
      email: Email.validated(
        state.email.value,
        isAlreadyRegistered: state.email.isAlreadyRegistered,
      ),
    );

    emit(newState);
  }

  void onUsernameChanged(String newValue) {
    final newState = state.copyWith(
      username: state.username.shouldValidate
          ? Username.validated(
              newValue,
              isAlreadyRegistered: newValue == state.username.value
                  ? state.username.isAlreadyRegistered
                  : false,
            )
          : Username.unvalidated(newValue),
    );
    emit(newState);
  }

  void onUsernameUnfocused() {
    final newState = state.copyWith(
      username: Username.validated(
        state.username.value,
        isAlreadyRegistered: state.username.isAlreadyRegistered,
      ),
    );

    emit(newState);
  }

  void onPasswordChanged(String newValue) {
    final newState = state.copyWith(
      password: state.password.shouldValidate
          ? Password.validated(newValue)
          : Password.unvalidated(newValue),
    );

    emit(newState);
  }

  void onPasswordUnfocused() {
    final newState = state.copyWith(
      password: Password.validated(
        state.password.value,
      ),
    );
    emit(newState);
  }

  void onPasswordConfirmationChanged(String newValue) {
    final newState = state.copyWith(
      passwordConfirmation: state.passwordConfirmation.shouldValidate
          ? PasswordConfirmation.validated(
              newValue,
              password: state.password,
            )
          : PasswordConfirmation.unvalidated(newValue),
    );
    emit(newState);
  }

  void onPasswordConfirmationUnfocused() {
    final newState = state.copyWith(
      passwordConfirmation: PasswordConfirmation.validated(
        state.passwordConfirmation.value,
        password: state.password,
      ),
    );
    emit(newState);
  }

  void onSubmit() async {
    final username = Username.validated(
      state.username.value,
      isAlreadyRegistered: state.username.isAlreadyRegistered,
    );

    final email = Email.validated(
      state.email.value,
      isAlreadyRegistered: state.email.isAlreadyRegistered,
    );

    final password = Password.validated(state.password.value);

    final passwordConfirmation = PasswordConfirmation.validated(
      state.passwordConfirmation.value,
      password: password,
    );

    final isFormValid = FormFields.validate([
      username,
      email,
      password,
      passwordConfirmation,
    ]);

    final newState = state.copyWith(
      username: username,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      submissionStatus: isFormValid ? SubmissionStatus.inProgress : null,
    );

    emit(newState);

    if (isFormValid) {
      try {
        await userRepository.signUp(
          username.value,
          email.value,
          password.value,
        );
        final newState = state.copyWith(
          submissionStatus: SubmissionStatus.success,
        );
        emit(newState);
      } catch (error) {
        final newState = state.copyWith(
          submissionStatus: error is! UsernameAlreadyTakenException &&
                  error is! EmailAlreadyRegisteredException
              ? SubmissionStatus.error
              : SubmissionStatus.idle,
          username: error is UsernameAlreadyTakenException
              ? Username.validated(
                  username.value,
                  isAlreadyRegistered: true,
                )
              : state.username,
          email: error is EmailAlreadyRegisteredException
              ? Email.validated(
                  email.value,
                  isAlreadyRegistered: true,
                )
              : state.email,
        );

        emit(newState);
      }
    }
  }
}
