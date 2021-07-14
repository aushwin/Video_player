// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../ui/login/login_view.dart';
import '../ui/main/main_view.dart';
import '../ui/onboarding/onboarding_view.dart';
import '../ui/profile/profile_view.dart';
import '../ui/registration/registration_view.dart';

class Routes {
  static const String onBoardingView = '/';
  static const String loginView = '/login-view';
  static const String registrationView = '/registration-view';
  static const String mainView = '/main-view';
  static const String profileView = '/profile-view';
  static const all = <String>{
    onBoardingView,
    loginView,
    registrationView,
    mainView,
    profileView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.onBoardingView, page: OnBoardingView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.registrationView, page: RegistrationView),
    RouteDef(Routes.mainView, page: MainView),
    RouteDef(Routes.profileView, page: ProfileView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    OnBoardingView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => OnBoardingView(),
        settings: data,
      );
    },
    LoginView: (data) {
      var args = data.getArgs<LoginViewArguments>(
        orElse: () => LoginViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginView(newUser: args.newUser),
        settings: data,
      );
    },
    RegistrationView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const RegistrationView(),
        settings: data,
      );
    },
    MainView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => MainView(),
        settings: data,
      );
    },
    ProfileView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ProfileView(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// LoginView arguments holder class
class LoginViewArguments {
  final dynamic newUser;
  LoginViewArguments({this.newUser});
}
