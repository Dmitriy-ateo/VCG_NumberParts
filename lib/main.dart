import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'app/theme/app_colors.dart';
import 'core/audio/sound_manager.dart';
import 'core/l10n/locale_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Preload audio sound assets
  await SoundManager.instance.init();

  // Set immersive status bar styling on mobile/desktop platforms
  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  final localeController = LocaleController();

  runApp(HeromaApp(localeController: localeController));
}
