import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/mvp_extensions.dart';
import 'package:flutter_demo/features/auth/login/login_presentation_model.dart';
import 'package:flutter_demo/features/auth/login/login_presenter.dart';
import 'package:flutter_demo/localization/app_localizations_utils.dart';

class LoginPage extends StatefulWidget with HasPresenter<LoginPresenter> {
  const LoginPage({
    required this.presenter,
    super.key,
  });

  @override
  final LoginPresenter presenter;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with PresenterStateMixin<LoginViewModel, LoginPresenter, LoginPage> {
  final double _defaultButtonHeight = 54;
  final double _defaultRadius = 16;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.blue.shade700,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_defaultRadius),
              ),
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: appLocalizations.usernameHint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(_defaultRadius),
                            ),
                          ),
                          onChanged: (text) => presenter.onChangeUsername(text),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: appLocalizations.passwordHint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(_defaultRadius),
                            ),
                          ),
                          onChanged: (text) => presenter.onChangePassword(text),
                        ),
                        const SizedBox(height: 16),
                        stateObserver(
                          builder: (context, state) => SizedBox(
                            width: double.infinity,
                            height: _defaultButtonHeight,
                            child: ElevatedButton(
                              onPressed: () => presenter.onClickLogin(),
                              style: ElevatedButton.styleFrom(
                                primary: state.isLoginEnabled ? Colors.blue : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(_defaultRadius),
                                ),
                              ),
                              child: state.isLoginInProgress
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(appLocalizations.logInAction),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
