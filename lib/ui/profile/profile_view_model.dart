import 'package:firebase_storage/firebase_storage.dart';
import 'package:stacked/stacked.dart';
import 'package:video_playerio/app/app.locator.dart';
import 'package:video_playerio/app/models/user.model.dart';
import 'package:video_playerio/app/services/profile.service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileViewModel extends BaseViewModel {
  final _profileService = locator<ProfileService>();
  late UserModel user;
  init() async {
    user = _profileService.userData;
  }
}
