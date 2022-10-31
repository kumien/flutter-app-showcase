import 'package:bloc/bloc.dart';
import 'package:flutter_demo/core/utils/bloc_extensions.dart';
import 'package:flutter_demo/core/utils/either_extensions.dart';
import 'package:flutter_demo/features/auth/domain/model/log_in_failure.dart';
import 'package:flutter_demo/features/auth/domain/use_cases/log_in_use_case.dart';
import 'package:flutter_demo/features/auth/login/login_navigator.dart';
import 'package:flutter_demo/features/auth/login/login_presentation_model.dart';
import 'package:flutter_demo/localization/app_localizations_utils.dart';

class LoginPresenter extends Cubit<LoginViewModel> {
  LoginPresenter(
    LoginPresentationModel super.model,
    this.logInUseCase,
    this.navigator,
  );

  final LoginNavigator navigator;
  final LogInUseCase logInUseCase;

  LoginPresentationModel get _model => state as LoginPresentationModel;

  void onChangeUsername(String username) =>
      emit(_model.copyWith(username: username));

  void onChangePassword(String password) =>
      emit(_model.copyWith(password: password));

  Future<void> onClickLogin() async {
    if (_model.isLoginEnabled) {
      emit(_model.copyWith(loginStatus: FutureStatus.pending));
      await logInUseCase
          .execute(
            username: _model.username,
            password: _model.password,
          )
          .asyncFold(
            (fail) => _onLoginFailure(fail),
            (success) => _onLoginSuccess(),
          );
    }
  }

  void _onLoginSuccess() {
    emit(_model.copyWith(loginStatus: FutureStatus.notStarted));
    navigator.showAlert(
      title: appLocalizations.loginSuccessTitle,
      message: appLocalizations.loginSuccessMessage,
    );
  }

  void _onLoginFailure(LogInFailure fail) {
    emit(_model.copyWith(loginStatus: FutureStatus.notStarted));
    navigator.showError(fail.displayableFailure());
  }
}
