import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppStrings {
  final String appTitle;
  final String welcomeTitle;
  final String welcomeSubtitle;
  
  // Game 1: Number Bonds
  final String gameNumberBondsTitle;
  final String gameNumberBondsSubtitle;
  final String badgeGrades;
  final String badgeLives;
  final String badgeWood;
  final String playButton;

  // Game 2: Labyrinth Explorer
  final String gameLabyrinthTitle;
  final String gameLabyrinthSubtitle;
  final String badgeMaze;
  final String badgeRandom;
  final String tabSimple;
  final String tabHard;
  final String chamberLabel;
  final String doorsChooseHint;
  final String treasureFoundTitle;
  final String treasureFoundSubtitle;

  // Levels Screen
  final String selectLevelTitle;
  final String tabClassic;
  final String tabAdvanced;
  final String levelNumberLabel;
  final String targetLabel;
  final String lockedLevel;

  // Game Screen
  final String targetSumDisplay;
  final String remainingCards;
  final String hintButton;
  final String undoButton;
  final String restartButton;
  final String noMoreHints;
  final String pairSelectedHint;

  // Victory Dialog
  final String victoryTitle;
  final String victorySubtitle;
  final String nextLevelButton;
  final String replayButton;
  final String homeButton;

  // Game Over Dialog
  final String gameOverTitle;
  final String gameOverSubtitle;
  final String tryAgainButton;

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
    required this.gameLabyrinthTitle,
    required this.gameLabyrinthSubtitle,
    required this.badgeMaze,
    required this.badgeRandom,
    required this.tabSimple,
    required this.tabHard,
    required this.chamberLabel,
    required this.doorsChooseHint,
    required this.treasureFoundTitle,
    required this.treasureFoundSubtitle,
    required this.selectLevelTitle,
    required this.tabClassic,
    required this.tabAdvanced,
    required this.levelNumberLabel,
    required this.targetLabel,
    required this.lockedLevel,
    required this.targetSumDisplay,
    required this.remainingCards,
    required this.hintButton,
    required this.undoButton,
    required this.restartButton,
    required this.noMoreHints,
    required this.pairSelectedHint,
    required this.victoryTitle,
    required this.victorySubtitle,
    required this.nextLevelButton,
    required this.replayButton,
    required this.homeButton,
    required this.gameOverTitle,
    required this.gameOverSubtitle,
    required this.tryAgainButton,
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
      appTitle: 'Heroma',
      welcomeTitle: 'Привіт, маленький математику! 🦊',
      welcomeSubtitle: 'Вибирай гру та розвивай свої супернавички лічби разом з дерев\'яними картками!',
      gameNumberBondsTitle: 'Склад Числа',
      gameNumberBondsSubtitle: 'Знаходь та з\'єднуй пари відкритих карток, щоб зібрати число рівня і очистити піраміду!',
      badgeGrades: '1–2 Класи',
      badgeLives: '3 Життя',
      badgeWood: 'Дерев\'яні картки',
      playButton: 'Грати!',
      gameLabyrinthTitle: 'Лабіринт Знань',
      gameLabyrinthSubtitle: 'Обирай правильні двері за математичним прикладом і дійди до скрині скарбів!',
      badgeMaze: '3D Двері',
      badgeRandom: 'Генератор завдань',
      tabSimple: '🌿 Простий',
      tabHard: '🔥 Майстер',
      chamberLabel: 'Кімната',
      doorsChooseHint: 'Які двері правильні?',
      treasureFoundTitle: 'Скарб Знайдено! 🏆',
      treasureFoundSubtitle: 'Ти майстерно пройшов усі кімнати лабіринту!',
      selectLevelTitle: 'Обери Рівень 🗺️',
      tabClassic: '🌿 Базовий',
      tabAdvanced: '⚡ Складний',
      levelNumberLabel: 'Рівень',
      targetLabel: 'Ціль',
      lockedLevel: 'Пройди попередній рівень!',
      targetSumDisplay: 'Збери',
      remainingCards: 'Залишилось карток',
      hintButton: 'Підказка',
      undoButton: 'Назад',
      restartButton: 'Спочатку',
      noMoreHints: 'Підказки закінчились!',
      pairSelectedHint: 'Вибери ще одну картку для пари',
      victoryTitle: 'Чудова Робота! 🎉',
      victorySubtitle: 'Ти майстерно склав усі числа!',
      nextLevelButton: 'Наступний рівень ➔',
      replayButton: 'Ще раз',
      homeButton: 'Головна',
      gameOverTitle: 'Ой, закінчились життя! ❤️',
      gameOverSubtitle: 'Не засмучуйся, спробуймо ще раз разом!',
      tryAgainButton: 'Спробувати знову',
      chooseLanguage: 'Обери мову 🌍',
      languageUk: 'Українська',
      languageEn: 'English',
      languageSl: 'Slovenščina',
      comingSoon: 'Незабаром',
    ),
    'en': AppStrings(
      appTitle: 'Heroma',
      welcomeTitle: 'Hello, little math explorer! 🦊',
      welcomeSubtitle: 'Pick a game and build your super counting powers with tactile wooden cards!',
      gameNumberBondsTitle: 'Number Bonds',
      gameNumberBondsSubtitle: 'Find and pair free wooden cards to match the target sum and clear the pile!',
      badgeGrades: 'Grades 1–2',
      badgeLives: '3 Lives',
      badgeWood: 'Tactile Wood',
      playButton: 'Play Now!',
      gameLabyrinthTitle: 'Labyrinth Explorer',
      gameLabyrinthSubtitle: 'Pick the correct door to solve the equation and reach the golden treasure chest!',
      badgeMaze: '3D Doors',
      badgeRandom: 'Random Tasks',
      tabSimple: '🌿 Simple',
      tabHard: '🔥 Master',
      chamberLabel: 'Chamber',
      doorsChooseHint: 'Which door is correct?',
      treasureFoundTitle: 'Treasure Unlocked! 🏆',
      treasureFoundSubtitle: 'You navigated all chambers with great math skills!',
      selectLevelTitle: 'Select Level 🗺️',
      tabClassic: '🌿 Basic',
      tabAdvanced: '⚡ Advanced',
      levelNumberLabel: 'Level',
      targetLabel: 'Target',
      lockedLevel: 'Complete previous level first!',
      targetSumDisplay: 'Target',
      remainingCards: 'Cards left',
      hintButton: 'Hint',
      undoButton: 'Undo',
      restartButton: 'Restart',
      noMoreHints: 'No more hints available!',
      pairSelectedHint: 'Pick one more card to make the target sum',
      victoryTitle: 'Fantastic Job! 🎉',
      victorySubtitle: 'You cleared all the wooden pairs!',
      nextLevelButton: 'Next Level ➔',
      replayButton: 'Replay',
      homeButton: 'Menu',
      gameOverTitle: 'Out of lives! ❤️',
      gameOverSubtitle: 'Don\'t worry! Let\'s try again together!',
      tryAgainButton: 'Try Again',
      chooseLanguage: 'Choose Language 🌍',
      languageUk: 'Українська',
      languageEn: 'English',
      languageSl: 'Slovenščina',
      comingSoon: 'Coming Soon',
    ),
    'sl': AppStrings(
      appTitle: 'Heroma',
      welcomeTitle: 'Živjo, mali matematik! 🦊',
      welcomeSubtitle: 'Izberi igro in okrepi svoje matematične spretnosti z lesenimi karticami!',
      gameNumberBondsTitle: 'Sestava Števil',
      gameNumberBondsSubtitle: 'Poišči in poveži pare prostih lesenih kartic, da dosežeš ciljno vsoto in počistiš kupček!',
      badgeGrades: '1.–2. Razred',
      badgeLives: '3 Življenja',
      badgeWood: 'Lesene kartice',
      playButton: 'Igraj zdaj!',
      gameLabyrinthTitle: 'Labirint Raziskovalec',
      gameLabyrinthSubtitle: 'Izberi prava vrata glede na račun in dosezi zlato skrinjo z zakladom!',
      badgeMaze: '3D Vrata',
      badgeRandom: 'Naključne naloge',
      tabSimple: '🌿 Preprosto',
      tabHard: '🔥 Mojster',
      chamberLabel: 'Soba',
      doorsChooseHint: 'Katera vrata so prava?',
      treasureFoundTitle: 'Zaklad Odkrit! 🏆',
      treasureFoundSubtitle: 'Mojstrsko si opravil z vsemi sobami labirinta!',
      selectLevelTitle: 'Izberi Stopnjo 🗺️',
      tabClassic: '🌿 Osnovno',
      tabAdvanced: '⚡ Napredno',
      levelNumberLabel: 'Stopnja',
      targetLabel: 'Cilj',
      lockedLevel: 'Najprej zaključi prejšnjo stopnjo!',
      targetSumDisplay: 'Cilj',
      remainingCards: 'Preostale kartice',
      hintButton: 'Namig',
      undoButton: 'Nazaj',
      restartButton: 'Znova',
      noMoreHints: 'Ni več namigov!',
      pairSelectedHint: 'Izberi še eno kartico za par',
      victoryTitle: 'Odlično opravljeno! 🎉',
      victorySubtitle: 'Uspešno si sestavil vsa števila!',
      nextLevelButton: 'Naslednja stopnja ➔',
      replayButton: 'Ponovi',
      homeButton: 'Meni',
      gameOverTitle: 'Zmanjkalo je življenj! ❤️',
      gameOverSubtitle: 'Brez skrbi, poskusiva znova skupaj!',
      tryAgainButton: 'Poskusi znova',
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
