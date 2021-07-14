import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_playerio/app/app.locator.dart';
import 'package:video_playerio/app/app.router.dart';
import 'package:video_playerio/app/models/user.model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

@lazySingleton
class ProfileService {
  final _navigationService = locator<NavigationService>();
  late var userDataPresent;
  late UserModel userData;

  checkSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userDataPresent = prefs.get('user');
    if (userDataPresent != null) {
      loadProfile();
      _navigationService.navigateTo(Routes.mainView);
    } else {
      _navigationService.navigateTo(Routes.onBoardingView);
    }
  }

  loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userDataPresent = prefs.get('user');

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instanceFor(
            bucket: 'gs://videoplayer-4aee2.appspot.com');

    userData = new UserModel(
        name: userDataPresent[0],
        email: userDataPresent[1],
        imageUrl: userDataPresent[2],
        dob: userDataPresent[3]);
    var url = await storage.ref().child(userData.imageUrl).getDownloadURL();
    userData.imageUrl = url;
  }
}
