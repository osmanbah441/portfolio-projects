import 'package:app/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component_library/component_library.dart';
import 'forgot_my_password_cubit.dart';

class ForgotMyPasswordDialog extends StatelessWidget {
  const ForgotMyPasswordDialog({required this.api, super.key});

  final Api api;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotMyPasswordCubit>(
      create: (_) => ForgotMyPasswordCubit(api: api),
      child: const ForgotMyPasswordView(),
    );
  }
}

@visibleForTesting
class ForgotMyPasswordView extends StatefulWidget {
  const ForgotMyPasswordView({super.key});

  @override
  State createState() => _ForgotMyPasswordViewState();
}

class _ForgotMyPasswordViewState extends State<ForgotMyPasswordView> {
  final _emailFocusNode = FocusNode();

  ForgotMyPasswordCubit get _cubit => context.read<ForgotMyPasswordCubit>();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        _cubit.onEmailUnfocused();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotMyPasswordCubit, ForgotMyPasswordState>(
      listener: (context, state) {
        if (state.submissionStatus.isSuccess) {
          Navigator.maybePop(context);

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('check your email to reset your password.'),
                duration: Duration(
                  seconds: 8,
                ),
              ),
            );
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Forgot password?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EmailTextField(
                emailFocusNode: _emailFocusNode,
                onChanged: _cubit.onEmailChanged,
                enabled: !state.submissionStatus.isInprogress,
                onEditingComplete: _cubit.onSubmit,
                errorText: state.email.error?.message,
              ),
              if (state.submissionStatus.isError) ...[
                const SizedBox(height: 8),
                const Text('check your internet connection & retry.'),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: state.submissionStatus.isInprogress
                  ? null
                  : () => Navigator.pop(context),
              child: const Text('cancel'),
            ),
            state.submissionStatus.isInprogress
                ? const InProgressTextButton(label: 'confirm')
                : TextButton(
                    onPressed: _cubit.onSubmit,
                    child: const Text('confirm'),
                  )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }
}
