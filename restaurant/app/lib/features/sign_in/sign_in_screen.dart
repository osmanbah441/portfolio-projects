import 'package:app/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component_library/component_library.dart';
import 'sign_in_cubit.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({
    super.key,
    required this.userRepository,
    required this.onSignInSuccess,
    required this.onSignUpTap,
    required this.onForgotPasswordTap,
  });

  final Api userRepository;
  final VoidCallback onSignInSuccess;
  final VoidCallback onSignUpTap;
  final VoidCallback onForgotPasswordTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(userRepository),
      child: SigninScreenView(
        onSignInSuccess: onSignInSuccess,
        onSignUpTap: onSignUpTap,
        onForgotPasswordTap: onForgotPasswordTap,
      ),
    );
  }
}

@visibleForTesting
class SigninScreenView extends StatefulWidget {
  const SigninScreenView({
    super.key,
    required this.onSignInSuccess,
    required this.onSignUpTap,
    required this.onForgotPasswordTap,
  });

  final VoidCallback onSignInSuccess;
  final VoidCallback onSignUpTap;
  final VoidCallback onForgotPasswordTap;

  @override
  State<SigninScreenView> createState() => _SigninScreenViewState();
}

class _SigninScreenViewState extends State<SigninScreenView> {
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();

  SignInCubit get _cubit => context.read<SignInCubit>();

  @override
  void initState() {
    super.initState();
    _setupPasswordFocusNode();
    _setupEmailFocusNode();
  }

  void _setupEmailFocusNode() => _usernameFocusNode.addListener(() {
        if (!_usernameFocusNode.hasFocus) {
          _cubit.onUsernameUnfocused();
        }
      });

  void _setupPasswordFocusNode() => _passwordFocusNode.addListener(() {
        if (!_passwordFocusNode.hasFocus) {
          _cubit.onPasswordUnfocused();
        }
      });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus,
      listener: (context, state) {
        if (state.submissionStatus.isSuccess) {
          widget.onSignInSuccess();
          return;
        }

        if (state.submissionStatus.hasSubmissionError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              state.submissionStatus.isInvalidCredentialsError
                  ? const SnackBar(
                      content: Center(
                        child: Text('invalid username or password'),
                      ),
                    )
                  : const GenericErrorSnackBar(),
            );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  focusNode: _usernameFocusNode,
                  textInputAction: TextInputAction.next,
                  onChanged: _cubit.onUsernameChanged,
                  enabled: !state.submissionStatus.isInProgress,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.person),
                    enabled: !state.submissionStatus.isInProgress,
                    labelText: 'username',
                    errorText: state.username.error?.message,
                  ),
                ),
                Spacing.mediumSpacingHeight,
                PasswordTextField(
                  focusNode: _passwordFocusNode,
                  enabled: !state.submissionStatus.isInProgress,
                  onEditingComplete: _cubit.onSubmit,
                  onChanged: _cubit.onPasswordChanged,
                  errorText: state.password.error?.message,
                ),
                Spacing.mediumSpacingHeight,
                TextButton(
                  onPressed: state.submissionStatus.isInProgress
                      ? null
                      : widget.onForgotPasswordTap,
                  child: const Text('Forgot Password'),
                ),
                Spacing.mediumSpacingHeight,
                state.submissionStatus.isInProgress
                    ? ExpandedElevatedButton.inProgress(
                        label: 'Loading',
                      )
                    : ExpandedElevatedButton(
                        onTap: _cubit.onSubmit,
                        label: 'sign in',
                        icon: const Icon(Icons.login),
                      ),
                if (!state.submissionStatus.isInProgress) ...[
                  Spacing.mediumSpacingHeight,
                  const Text('Welcome! No account yet?'),
                  TextButton(
                    onPressed: widget.onSignUpTap,
                    child: const Text("create account"),
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }
}
