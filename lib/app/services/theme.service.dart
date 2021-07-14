import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ThemeService with ChangeNotifier {
  ThemeMode _mode;
  ThemeMode get mode => _mode;
  ThemeService({ThemeMode mode = ThemeMode.light}) : _mode = mode;

  void toggleMode() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
