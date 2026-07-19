import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class SettingsService extends ChangeNotifier {
  static const _keyColor = 'theme_color';
  static const _keyDark = 'dark_mode';
  static const _keyNotifIstirahat = 'notif_istirahat';
  static const _keyNotifMapel = 'notif_mapel';
  static const _keyNotifPiket = 'notif_piket';

  AppThemeColor _color = AppThemeColor.hijau;
  bool _darkMode = false;
  bool _notifIstirahat = true;
  bool _notifMapel = true;
  bool _notifPiket = true;

  AppThemeColor get color => _color;
  bool get darkMode => _darkMode;
  bool get notifIstirahat => _notifIstirahat;
  bool get notifMapel => _notifMapel;
  bool get notifPiket => _notifPiket;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final colorIndex = prefs.getInt(_keyColor) ?? 0;
    _color = AppThemeColor.values[colorIndex.clamp(0, AppThemeColor.values.length - 1)];
    _darkMode = prefs.getBool(_keyDark) ?? false;
    _notifIstirahat = prefs.getBool(_keyNotifIstirahat) ?? true;
    _notifMapel = prefs.getBool(_keyNotifMapel) ?? true;
    _notifPiket = prefs.getBool(_keyNotifPiket) ?? true;
    notifyListeners();
  }

  Future<void> setColor(AppThemeColor color) async {
    _color = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyColor, color.index);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDark, value);
    notifyListeners();
  }

  Future<void> setNotifIstirahat(bool value) async {
    _notifIstirahat = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifIstirahat, value);
    notifyListeners();
  }

  Future<void> setNotifMapel(bool value) async {
    _notifMapel = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifMapel, value);
    notifyListeners();
  }

  Future<void> setNotifPiket(bool value) async {
    _notifPiket = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifPiket, value);
    notifyListeners();
  }
}
