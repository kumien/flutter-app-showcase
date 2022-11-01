import 'package:flutter_demo/core/utils/bloc_extensions.dart';
import 'package:flutter_demo/features/auth/login/login_initial_params.dart';

/// Model used by presenter, contains fields that are relevant to presenters and implements ViewModel to expose data to view (page)
class LoginPresentationModel implements LoginViewModel {
  /// Creates the initial state
  LoginPresentationModel.initial(
    // ignore: avoid_unused_constructor_parameters
    LoginInitialParams initialParams,
  )   : username = initialParams.username ?? '',
        password = initialParams.password ?? '',
        loginStatus = FutureStatus.notStarted;

  /// Used for the copyWith method
  LoginPresentationModel._({
    required this.username,
    required this.password,
    required this.loginStatus,
  });

  final String username;
  final String password;
  final FutureStatus loginStatus;

  @override
  bool get isLoginEnabled => username.isNotEmpty && password.isNotEmpty;

  @override
  bool get isLoginInProgress => loginStatus == FutureStatus.pending;

  LoginPresentationModel copyWith({
    String? username,
    String? password,
    FutureStatus? loginStatus,
  }) {
    return LoginPresentationModel._(
      username: username ?? this.username,
      password: password ?? this.password,
      loginStatus: loginStatus ?? this.loginStatus,
    );
  }
}

/// Interface to expose fields used by the view (page).
abstract class LoginViewModel {
  bool get isLoginEnabled;

  bool get isLoginInProgress;
}
