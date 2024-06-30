import 'package:app/api/api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain_models/domain_models.dart';
import '../../form_fields.dart/form_fields.dart';

part 'sign_in_state.dart';

final class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this.userRepository) : super(const SignInState());

  final Api userRepository;

  void onPasswordChanged(String newValue) {
    final newPassword = state.password.shouldValidate
        ? Password.validated(newValue)
        : Password.unvalidated(newValue);

    final newState = state.copyWith(password: newPassword);
    emit(newState);
  }

  void onPasswordUnfocused() {
    final newPassword = Password.validated(state.password.value);
    final newState = state.copyWith(password: newPassword);
    emit(newState);
  }

  void onUsernameChanged(String newValue) {
    final newUsername = state.username.shouldValidate
        ? Username.validated(newValue)
        : Username.unvalidated(newValue);

    final newState = state.copyWith(username: newUsername);
    emit(newState);
  }

  void onUsernameUnfocused() {
    final newUsername = Username.validated(state.username.value);
    final newState = state.copyWith(username: newUsername);
    emit(newState);
  }

  Future<void> onSubmit() async {
    final username = Username.validated(state.username.value);
    final password = Password.validated(state.password.value);
    final isFormValid = FormFields.validate([username, password]);

    final newState = state.copyWith(
      username: username,
      password: password,
      submissionStatus: isFormValid ? SubmissionStatus.inProgress : null,
    );

    emit(newState);

    if (isFormValid) {
      try {
        await userRepository.signIn(username.value, password.value);
        emit(state.copyWith(submissionStatus: SubmissionStatus.success));
      } catch (e) {
        emit(
          state.copyWith(
              submissionStatus: e is InvalidCredentialsError
                  ? SubmissionStatus.invalidCredentialsError
                  : SubmissionStatus.genericError),
        );
      }
    }
  }
}
