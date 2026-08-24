import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'app/theme/app_colors.dart';
import 'core/l10n/locale_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set immersive status bar styling with warm pastel background
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final localeController = LocaleController();

  runApp(HeromaApp(localeController: localeController));
}
