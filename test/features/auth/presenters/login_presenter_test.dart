import 'package:flutter_demo/core/domain/model/user.dart';
import 'package:flutter_demo/features/auth/domain/model/log_in_failure.dart';
import 'package:flutter_demo/features/auth/login/login_initial_params.dart';
import 'package:flutter_demo/features/auth/login/login_presentation_model.dart';
import 'package:flutter_demo/features/auth/login/login_presenter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_utils/test_utils.dart';
import '../mocks/auth_mock_definitions.dart';

void main() {
  late LoginPresentationModel model;
  late LoginPresenter presenter;
  late MockLoginNavigator navigator;
  late MockLogInUseCase logInUseCase;

  test(
    'Login button should be disabled at start',
    () {
      // GIVEN
      // WHEN
      // THEN
      expect(presenter.state.isLoginEnabled, false);
    },
  );

  test(
    'Login button should be disabled when only username is provided',
    () {
      // GIVEN
      // WHEN
      presenter.onChangeUsername('test');
      // THEN
      expect(presenter.state.isLoginEnabled, false);
    },
  );

  test(
    'Login button should be enabled when username and password are provided',
    () {
      // GIVEN
      // WHEN
      presenter.onChangeUsername('test');
      presenter.onChangePassword('test');
      // THEN
      expect(presenter.state.isLoginEnabled, true);
    },
  );

  test(
    'LoginUseCase should not be executed when username and password were not provided',
    () async {
      // GIVEN
      when(
        () => logInUseCase.execute(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => failFuture(const LogInFailure.unknown()));

      // WHEN
      presenter.onChangeUsername('test');
      await presenter.onClickLogin();

      // THEN
      verifyNever(
        () => logInUseCase.execute(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      );
    },
  );

  test(
    'Show error dialog when credentials are not correct',
    () async {
      // GIVEN
      when(
        () => logInUseCase.execute(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => failFuture(const LogInFailure.unknown()));
      when(() => navigator.showError(any())).thenAnswer((_) => Future.value());

      // WHEN
      presenter.onChangeUsername('test');
      presenter.onChangePassword('test');
      await presenter.onClickLogin();

      // THEN
      verify(() => navigator.showError(any()));
    },
  );

  test(
    'Show alert dialog when credentials are correct',
    () async {
      // GIVEN
      when(
        () => logInUseCase.execute(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => successFuture(const User.anonymous()));
      when(
        () => navigator.showAlert(
          title: any(named: 'title'),
          message: any(named: 'message'),
        ),
      ).thenAnswer((_) => Future.value());

      // WHEN
      presenter.onChangeUsername('test');
      presenter.onChangePassword('test');
      await presenter.onClickLogin();

      // THEN
      verify(
        () => navigator.showAlert(
          title: any(named: 'title'),
          message: any(named: 'message'),
        ),
      );
    },
  );

  setUp(() {
    model = LoginPresentationModel.initial(const LoginInitialParams());
    logInUseCase = MockLogInUseCase();
    navigator = MockLoginNavigator();
    presenter = LoginPresenter(
      model,
      logInUseCase,
      navigator,
    );
  });
}
