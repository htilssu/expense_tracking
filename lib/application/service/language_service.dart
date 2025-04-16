import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'language_code';
  final SharedPreferences _prefs;

  LanguageService(this._prefs);

  static Future<LanguageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LanguageService(prefs);
  }

  Locale getCurrentLocale() {
    final String? languageCode = _prefs.getString(_languageKey);
    if (languageCode == null) {
      return const Locale('vi'); // Mặc định là tiếng Việt
    }
    return Locale(languageCode);
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(_languageKey, locale.languageCode);
  }

  Future<void> resetToDefault() async {
    await _prefs.remove(_languageKey);
  }
}
