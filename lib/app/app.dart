import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/audio/app_navigator_observer.dart';
import '../core/l10n/app_localizations.dart';
import '../core/l10n/locale_controller.dart';
import '../core/widgets/responsive_web_wrapper.dart';
import '../features/home/presentation/home_screen.dart';
import 'theme/app_theme.dart';

class HeromaApp extends StatelessWidget {
  final LocaleController localeController;

  const HeromaApp({
    super.key,
    required this.localeController,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Heroma',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: localeController.locale,
          supportedLocales: const [
            Locale('uk'),
            Locale('en'),
            Locale('sl'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          navigatorObservers: [
            AppNavigatorObserver(),
          ],
          builder: (context, child) {
            return ResponsiveWebWrapper(
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: HomeScreen(localeController: localeController),
        );
      },
    );
  }
}
