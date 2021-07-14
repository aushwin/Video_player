import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_playerio/app/app.locator.dart';
import 'package:video_playerio/app/app.router.dart';
import 'package:video_playerio/app/models/user.model.dart';
import 'package:video_playerio/app/services/error.service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_playerio/app/services/profile.service.dart';

@lazySingleton
class AuthService {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  final _errorService = locator<ErrorService>();
  final _navigationService = locator<NavigationService>();
  final _profileService = locator<ProfileService>();

  var contextRemoval;
  var userFound;
  late UserModel user;
  late String registeredMobile = "+917356530054";
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Color(0xff49DC87)),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  registerUser(String mobileNumber, context) async {
    _errorService.checkConnectivity(
        context, 'Device has no Internet Connection');
    mobileNumber = '+91' + mobileNumber.trim();
    registeredMobile = mobileNumber;
    log(mobileNumber);
    FirebaseAuth _auth = FirebaseAuth.instance;
    await verifyPhoneNumber(_auth, mobileNumber, context);
  }

  verifyPhoneNumber(FirebaseAuth _auth, String mobileNumber, context) async {
    _auth.verifyPhoneNumber(
        phoneNumber: mobileNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential authCredential) async {
          _auth.signInWithCredential(authCredential).then((result) async {
            //!check if a user of that present if yes ... get data and store in storedPrefs;
            await checkIfUserPresetn(mobileNumber);
            log('[Auth Service] : Auto Retrievel Succes ');
            _errorService.parseSuccess(context, 'User Logged In');
          }).catchError((e) {
            log('$e');
          });
        },
        verificationFailed: (FirebaseAuthException authException) {
          print(authException.message);
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          //show dialog to take input from the user
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (contextTemp) {
                contextRemoval = contextTemp;
                return AlertDialog(
                  title: Text("Enter SMS Code"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      PinPut(
                        eachFieldMargin: EdgeInsets.symmetric(horizontal: 4),
                        fieldsCount: 6,
                        controller: _pinPutController,
                        focusNode: _pinPutFocusNode,
                        onSubmit: (String pin) async {
                          FirebaseAuth auth = FirebaseAuth.instance;

                          var smsCode = _pinPutController.text.trim();

                          AuthCredential _credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: smsCode);
                          //* All Exceptions handled
                          try {
                            UserCredential result =
                                await auth.signInWithCredential(_credential);
                            await checkIfUserPresetn(mobileNumber);
                            log('[Auth Service] : Auto Retrievel Succes ');
                            _errorService.parseSuccess(
                                context, 'User Logged In');

                            //!check if a user of that present if yes ... get data and store in storedPrefs;

                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'invalid-verification-code') {
                              _errorService.parseError(
                                  context, 'Invalid Otp Enterd');
                              _pinPutController.clear();
                              Navigator.pop(contextTemp);
                            }
                            if (e.code == 'network-request-failed') {
                              _errorService.parseError(
                                  context, 'Device has no Internet Connection');
                              _pinPutController.clear();
                              Navigator.pop(contextTemp);
                            }
                            log('Failed with error code: ${e.code}');
                            log('${e.message}');
                          }
                        },
                        submittedFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        selectedFieldDecoration: _pinPutDecoration,
                        followingFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Colors.grey.withOpacity(.5),
                          ),
                        ),
                      ),
                      Text(
                        'Never Share your otp with anyone',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                );
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) async {
          verificationId = verificationId;
          print("Timout");
          _errorService.parseError(context, 'Timeout: Resending Otp...');
          _pinPutController.clear();
          _errorService.parseSuccess(context, 'Initiated Resend...');
          await verifyPhoneNumber(_auth, mobileNumber, context);
          Navigator.pop(contextRemoval);
        });
  }

  checkIfUserPresetn(mobileNumber) async {
    var document =
        FirebaseFirestore.instance.collection('users').doc(mobileNumber);
    await document.get().then((value) {
      userFound = value.data();
      if (userFound != null) {
        user = new UserModel.fromJson(userFound);
      }
    });
    if (userFound != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
          'user', [user.name, user.email, user.imageUrl, user.dob]);
      log('[Auth Service] : User Logged In');
      _profileService.loadProfile();
      _navigationService.navigateTo(Routes.mainView);
    } else {
      _navigationService.navigateTo(Routes.registrationView);
    }
  }
}
