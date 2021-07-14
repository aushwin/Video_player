import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_playerio/app/app.locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:video_playerio/app/services/profile.service.dart';
import 'package:video_playerio/app/services/theme.service.dart';

import 'app/app.router.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _profileService = locator<ProfileService>();
    _profileService.checkSharedPrefs();
    return ChangeNotifierProvider<ThemeService>(
        create: (_) => ThemeService(),
        child: Consumer<ThemeService>(builder: (_, model, __) {
          return MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: model.mode,
            navigatorKey: StackedService.navigatorKey,
            onGenerateRoute: StackedRouter().onGenerateRoute,
          );
        }));
  }
}
