import 'package:app/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component_library/component_library.dart';
import 'sign_up_cubit.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({
    super.key,
    required this.userRepository,
    required this.onSignUpSuccess,
    required this.onSignInTap,
  });

  final Api userRepository;
  final VoidCallback onSignUpSuccess;
  final VoidCallback onSignInTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpCubit>(
      create: (_) => SignUpCubit(
        userRepository: userRepository,
      ),
      child: SignUpView(
        onSignUpSuccess: onSignUpSuccess,
        onSignInTap: onSignInTap,
      ),
    );
  }
}

@visibleForTesting
class SignUpView extends StatelessWidget {
  const SignUpView({
    required this.onSignUpSuccess,
    super.key,
    required this.onSignInTap,
  });

  final VoidCallback onSignUpSuccess;
  final VoidCallback onSignInTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
        child: _SignUpForm(
          onSignUpSuccess: onSignUpSuccess,
          onSignInTap: onSignInTap,
        ),
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  const _SignUpForm({
    required this.onSignUpSuccess,
    required this.onSignInTap,
  });

  final VoidCallback onSignUpSuccess;
  final VoidCallback onSignInTap;

  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final _usernameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _passwordConfirmationFocusNode = FocusNode();

  SignUpCubit get _cubit => context.read<SignUpCubit>();

  @override
  void initState() {
    super.initState();
    _setUpEmailFieldFocusListener();
    _setUpUsernameFieldFocusListener();
    _setUpPasswordFieldFocusListener();
    _setUpPasswordConfirmationFieldFocusListener();
  }

  void _setUpEmailFieldFocusListener() {
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        _cubit.onEmailUnfocused();
      }
    });
  }

  void _setUpUsernameFieldFocusListener() {
    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        _cubit.onUsernameUnfocused();
      }
    });
  }

  void _setUpPasswordFieldFocusListener() {
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        _cubit.onPasswordUnfocused();
      }
    });
  }

  void _setUpPasswordConfirmationFieldFocusListener() {
    _passwordConfirmationFocusNode.addListener(() {
      if (!_passwordConfirmationFocusNode.hasFocus) {
        _cubit.onPasswordConfirmationUnfocused();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listenWhen: (oldState, newState) =>
          oldState.submissionStatus != newState.submissionStatus,
      listener: (context, state) {
        if (state.submissionStatus.isSuccess) {
          widget.onSignUpSuccess();
          return;
        }

        if (state.submissionStatus.isError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const GenericErrorSnackBar());
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            EmailTextField(
              emailFocusNode: _emailFocusNode,
              onChanged: _cubit.onEmailChanged,
              enabled: !state.submissionStatus.isInprogress,
              errorText: state.email.error?.message,
              textInputAction: TextInputAction.next,
            ),
            Spacing.mediumSpacingHeight,
            TextField(
              focusNode: _usernameFocusNode,
              onChanged: _cubit.onUsernameChanged,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.person),
                enabled: !state.submissionStatus.isInprogress,
                labelText: 'username',
                errorText: state.username.error?.message,
              ),
            ),
            Spacing.mediumSpacingHeight,
            PasswordTextField(
              focusNode: _passwordFocusNode,
              enabled: !state.submissionStatus.isInprogress,
              onChanged: _cubit.onPasswordChanged,
              textInputAction: TextInputAction.next,
              errorText: state.password.error?.message,
            ),
            Spacing.mediumSpacingHeight,
            PasswordTextField(
              focusNode: _passwordConfirmationFocusNode,
              onChanged: _cubit.onPasswordConfirmationChanged,
              onEditingComplete: _cubit.onSubmit,
              enabled: !state.submissionStatus.isInprogress,
              errorText: state.passwordConfirmation.error?.message,
            ),
            Spacing.mediumSpacingHeight,
            state.submissionStatus.isInprogress
                ? ExpandedElevatedButton.inProgress(label: 'sign up')
                : ExpandedElevatedButton(
                    onTap: _cubit.onSubmit,
                    label: 'sign up',
                    icon: const Icon(Icons.login),
                  ),
            if (!state.submissionStatus.isInprogress) ...[
              Spacing.mediumSpacingHeight,
              const Text('Welcome back! Already have account?'),
              TextButton(
                onPressed: widget.onSignInTap,
                child: const Text("sign in"),
              ),
            ]
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmationFocusNode.dispose();
    super.dispose();
  }
}
