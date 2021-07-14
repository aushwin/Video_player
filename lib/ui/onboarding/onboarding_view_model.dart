import 'dart:developer';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_playerio/app/app.locator.dart';
import 'package:video_playerio/app/app.router.dart';

class OnBoardingViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  int test = 1;
  void onLoginPressed() {
    log('[OnBoardingView] : Success');
    _navigationService.navigateTo(Routes.loginView,
        arguments: LoginViewArguments(newUser: false));
  }

  void onRegisterPressed() {
    log('[OnBoardingView] : Success');
    _navigationService.navigateTo(Routes.loginView,
        arguments: LoginViewArguments(newUser: true));
  }
}
