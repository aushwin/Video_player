import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_playerio/app/app.locator.dart';
import 'package:video_playerio/app/app.router.dart';
import 'package:video_playerio/app/auth_service/auth_service.dart';
import 'package:video_playerio/app/models/user.model.dart';
import 'package:video_playerio/app/services/error.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_playerio/app/services/profile.service.dart';

class RegistrationViewModel extends BaseViewModel {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _errorService = locator<ErrorService>();
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();
  final _profileService = locator<ProfileService>();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  late File imageFile;
  late PickedFile? selected;
  bool isSelected = false;
  bool isTouchedName = false, isTouchedEmail = false;
  final _picker = ImagePicker();

  Future<void> pickImage(ImageSource source, context) async {
    try {
      selected = await _picker.getImage(source: source);
      imageFile = File(selected!.path);
      isSelected = true;
      notifyListeners();
    } catch (e) {
      _errorService.parseError(context, 'Image Not Picked !');
    }
  }

  Future selectDate(context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2030));
    if (picked != null) ;
  }

  //! Validation goes here -->
  nameValidate(value) {
    if (value.length >= 1) isTouchedName = true;
    if ((value.isEmpty || value == '') && isTouchedName) {
      return 'Please enter your name';
    }
    return null;
  }

  emailValidate(value) {
    if (value.length >= 1 && !isTouchedEmail) {
      isTouchedEmail = true;
    }

    if (isTouchedEmail && (value!.isEmpty || !value.contains("@")))
      return 'Enter Valid Email';
    return null;
  }

  //* : Completed Error handling and user storing

  onSubmit({context, name, email, dob}) async {
    _errorService.checkConnectivity(context, 'No Internet Connectivity !');
    // _errorService.parseSuccess(context, 'Uploading');
    String filePath = 'images/${DateTime.now()}.png';
    UserModel user =
        new UserModel(dob: dob, email: email, name: name, imageUrl: filePath);
    await uploadFileAndAddUser(context, filePath, user);
    _errorService.parseSuccess(context, 'Image Uploaded');
    log('Completed');
  }

  addUser(user, context) {
    var userJson = user.toJson();
    users.doc(_authService.registeredMobile).set(userJson).then((value) async {
      _errorService.parseSuccess(context, 'User Registered');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
          'user', [user.name, user.email, user.imageUrl, user.dob]);
      _profileService.loadProfile();
      _navigationService.navigateTo(Routes.mainView);
    }).catchError((err) {
      log("$err");
    });
  }

  //! change bucket to production project
  Future uploadFileAndAddUser(context, filePath, user) async {
    try {
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instanceFor(
              bucket: 'gs://videoplayer-4aee2.appspot.com');
      // final FirebaseStorage storage = FirebaseStorage.instanceFor(
      //     bucket: 'gs://recipes-angular-9906e.appspot.com/');

      storage.ref().child(filePath).putFile(imageFile);

      addUser(user, context);
    } on FirebaseException catch (e) {
      log('$e');
      // e.g, e.code == 'canceled'
    }
  }

  // //!Testing
  // onCheck() {
  //   _authService.checkIfUserPresetn('+55');
  // }

  onCheckPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log('${prefs.getStringList('user')}');
  }
}
