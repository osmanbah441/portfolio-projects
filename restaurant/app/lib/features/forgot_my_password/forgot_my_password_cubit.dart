import 'package:app/api/api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../form_fields.dart/form_fields.dart';

part 'forgot_my_password_state.dart';

class ForgotMyPasswordCubit extends Cubit<ForgotMyPasswordState> {
  ForgotMyPasswordCubit({
    required this.api,
  }) : super(const ForgotMyPasswordState());

  final Api api;

  void onEmailChanged(String newValue) {
    final newEmail = state.email.shouldValidate
        ? Email.validated(newValue)
        : Email.unvalidated(newValue);

    final newState = state.copyWith(email: newEmail);
    emit(newState);
  }

  void onEmailUnfocused() {
    final newEmail = Email.validated(state.email.value);
    final newState = state.copyWith(email: newEmail);
    emit(newState);
  }

  void onSubmit() async {
    final email = Email.validated(state.email.value);
    final isValid = FormFields.validate([email]);
    final newState = state.copyWith(
      email: email,
      submissionStatus: isValid ? SubmissionStatus.inProgress : null,
    );
    emit(newState);

    if (isValid) {
      try {
        await api.requestPasswordResetEmail(email.value);
        final newState = state.copyWith(
          submissionStatus: SubmissionStatus.success,
        );
        emit(newState);
      } catch (_) {
        final newState = state.copyWith(
          submissionStatus: SubmissionStatus.error,
        );
        emit(newState);
      }
    }
  }
}
