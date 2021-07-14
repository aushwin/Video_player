import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_player/video_player.dart';
import 'package:video_playerio/app/app.locator.dart';
import 'package:video_playerio/app/app.router.dart';
import 'package:video_playerio/app/services/error.service.dart';
import 'package:video_playerio/app/services/theme.service.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class MainViewModel extends BaseViewModel {
  final _errorService = locator<ErrorService>();
  final _navigationService = locator<NavigationService>();
  final _themeService = locator<ThemeService>();
  late List<File> files;
  late List<String> fileName;
  late String path;
  var videoPlayerController;
  var chewiController;
  late int indeX;
  init() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  loadVideo({index = 0}) async {
    indeX = index;
    videoPlayerController = VideoPlayerController.file(files[index]);
    await videoPlayerController.initialize();
    chewiController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: true,
    );
    notifyListeners();
  }

  nextVideo(index, context) {
    if (index < files.length) {
      loadVideo(index: index = index + 1);
    } else {
      _errorService.parseError(context, 'You are at the last video');
    }
  }

  prevVideo(index, context) {
    if (index > 0) {
      loadVideo(index: index = index - 1);
    } else {
      _errorService.parseError(context, 'You are the the first video');
    }
  }

  pickFile(context) async {
    if (videoPlayerController != null) {
      videoPlayerController = null;
      chewiController = null;
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
      files.forEach((element) {
        print(element);
      });
      loadVideo();
      _errorService.parseSuccess(context, 'Files Loaded');
    } else {
      // User canceled the picker
    }
  }

  printFile() {
    files.forEach((element) {
      print(element);
    });
  }

  onLogut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _navigationService.navigateTo(Routes.onBoardingView);
  }

  onViewProfile() {
    _navigationService.navigateTo(Routes.profileView);
  }

  onSwitchTheme(context) {
    // _themeService.toggleMode();
    Provider.of<ThemeService>(context, listen: false).toggleMode();
  }
}
