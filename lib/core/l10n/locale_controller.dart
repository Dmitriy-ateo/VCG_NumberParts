import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  static const String _prefKey = 'selected_language_code';

  Locale _locale = const Locale('uk'); // Default to Ukrainian, or system

  Locale get locale => _locale;

  LocaleController() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_prefKey);
      if (savedCode != null && ['uk', 'en', 'sl'].contains(savedCode)) {
        _locale = Locale(savedCode);
        notifyListeners();
      }
    } catch (_) {
      // Use fallback
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;
    if (!['uk', 'en', 'sl'].contains(newLocale.languageCode)) return;

    _locale = newLocale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, newLocale.languageCode);
    } catch (_) {}
  }
}
