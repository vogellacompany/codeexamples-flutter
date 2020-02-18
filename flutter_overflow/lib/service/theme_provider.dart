import 'package:flutter/material.dart';

var darkTheme = ThemeData.dark();
var lightTheme = ThemeData.light();

class ThemeProvider with ChangeNotifier {
  SOTheme _theme = SOTheme.light;

  SOTheme get theme => _theme;

  ThemeData get themeData {
    switch (_theme) {
      case SOTheme.dark:
        return darkTheme;
      case SOTheme.light:
        return lightTheme;
      default:
        return null;
    }
  }

  set theme(SOTheme theme) {
    _theme = theme;
    notifyListeners();
  }

  void toggle() {
    if (_theme == SOTheme.dark) {
      theme = SOTheme.light;
    } else {
      theme = SOTheme.dark;
    }
  }

  bool get isDark => _theme == SOTheme.dark;
}

enum SOTheme { dark, light }
