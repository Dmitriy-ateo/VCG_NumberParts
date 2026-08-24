import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppStrings {
  final String appTitle;
  final String welcomeTitle;
  final String welcomeSubtitle;
  
  // Game 1
  final String gameNumberBondsTitle;
  final String gameNumberBondsSubtitle;
  final String badgeGrades;
  final String badgeLives;
  final String badgeWood;
  final String playButton;

  // Language Picker
  final String chooseLanguage;
  final String languageUk;
  final String languageEn;
  final String languageSl;

  // Generic
  final String comingSoon;

  const AppStrings({
    required this.appTitle,
    required this.welcomeTitle,
    required this.welcomeSubtitle,
    required this.gameNumberBondsTitle,
    required this.gameNumberBondsSubtitle,
    required this.badgeGrades,
    required this.badgeLives,
    required this.badgeWood,
    required this.playButton,
    required this.chooseLanguage,
    required this.languageUk,
    required this.languageEn,
    required this.languageSl,
    required this.comingSoon,
  });
}

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const Map<String, AppStrings> _localizedValues = {
    'uk': AppStrings(
      appTitle: 'NumberParts',
      welcomeTitle: 'Привіт, маленький математику! 🦊',
      welcomeSubtitle: 'Вибирай гру та розвивай свої супернавички лічби разом з дерев\'яними картками!',
      gameNumberBondsTitle: 'Склад Числа',
      gameNumberBondsSubtitle: 'Знаходь та з\'єднуй пари відкритих карток, щоб зібрати число рівня і очистити піраміду!',
      badgeGrades: '1–2 Класи',
      badgeLives: '3 Життя',
      badgeWood: 'Дерев\'яні картки',
      playButton: 'Грати!',
      chooseLanguage: 'Обери мову 🌍',
      languageUk: 'Українська',
      languageEn: 'English',
      languageSl: 'Slovenščina',
      comingSoon: 'Незабаром',
    ),
    'en': AppStrings(
      appTitle: 'NumberParts',
      welcomeTitle: 'Hello, little math explorer! 🦊',
      welcomeSubtitle: 'Pick a game and build your super counting powers with tactile wooden cards!',
      gameNumberBondsTitle: 'Number Bonds',
      gameNumberBondsSubtitle: 'Find and pair free wooden cards to match the target sum and clear the pile!',
      badgeGrades: 'Grades 1–2',
      badgeLives: '3 Lives',
      badgeWood: 'Tactile Wood',
      playButton: 'Play Now!',
      chooseLanguage: 'Choose Language 🌍',
      languageUk: 'Українська',
      languageEn: 'English',
      languageSl: 'Slovenščina',
      comingSoon: 'Coming Soon',
    ),
    'sl': AppStrings(
      appTitle: 'NumberParts',
      welcomeTitle: 'Živjo, mali matematik! 🦊',
      welcomeSubtitle: 'Izberi igro in okrepi svoje matematične spretnosti z lesenimi karticami!',
      gameNumberBondsTitle: 'Sestava Števil',
      gameNumberBondsSubtitle: 'Poišči in poveži pare prostih lesenih kartic, da dosežeš ciljno vsoto in počistiš kupček!',
      badgeGrades: '1.–2. Razred',
      badgeLives: '3 Življenja',
      badgeWood: 'Lesene kartice',
      playButton: 'Igraj zdaj!',
      chooseLanguage: 'Izberi jezik 🌍',
      languageUk: 'Українська',
      languageEn: 'English',
      languageSl: 'Slovenščina',
      comingSoon: 'Kmalu',
    ),
  };

  AppStrings get strings =>
      _localizedValues[locale.languageCode] ?? _localizedValues['en']!;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['uk', 'en', 'sl'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
