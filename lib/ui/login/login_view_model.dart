import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:video_playerio/app/app.locator.dart';
import 'package:video_playerio/app/auth_service/auth_service.dart';

class LoginViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  bool _isValidate = false;
  late bool isNewUser;
  bool get isValidate => _isValidate;
  formValidation(value) {
    if (value == null || value.isEmpty) {
      _isValidate = false;
      return 'Please enter your mobile number';
    } else if (value.length != 10) {
      log('${value.length}');
      _isValidate = false;
      return 'Please enter a valid Mobile number';
    }
    if (value.length == 10) {
      _isValidate = true;
      log('$isValidate');
      return null;
    }
  }

  onSubmit(context, fieldController) {
    _authService.registerUser(fieldController.text, context);
    log('[LoginView Success :]');
  }
}
