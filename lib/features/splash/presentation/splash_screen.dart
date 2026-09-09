import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/audio/sound_manager.dart';
import '../../../core/l10n/locale_controller.dart';
import '../../home/presentation/home_screen.dart';

class SplashScreen extends StatefulWidget {
  final LocaleController localeController;

  const SplashScreen({
    super.key,
    required this.localeController,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _startInitSequence();
  }

  Future<void> _startInitSequence() async {
    // Play warm chime / click or begin menu music
    SoundManager.instance.startMenuMusic();

    // Allow time for assets & animations to shine nicely (~1.8s)
    await Future.delayed(const Duration(milliseconds: 1800));

    if (!mounted || _isNavigating) return;
    _goToHome();
  }

  void _goToHome() {
    if (_isNavigating) return;
    _isNavigating = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            HomeScreen(localeController: widget.localeController),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _goToHome,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Logo Graphic with gentle bounce & scale
                Image.asset(
                  'assets/images/heroma_splash_logo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                    .scale(
                      begin: const Offset(0.85, 0.85),
                      end: const Offset(1.0, 1.0),
                      duration: 700.ms,
                      curve: Curves.elasticOut,
                    ),

                const SizedBox(height: 18),

                Text(
                  'Heroma',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 500.ms),

                const SizedBox(height: 4),

                Text(
                  'Math Explorer',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 500.ms),

                const SizedBox(height: 32),

                // Cozy Loading Indicator
                SizedBox(
                  width: 140,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      minHeight: 6,
                      backgroundColor: AppColors.woodLight.withAlpha(120),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.woodHoney,
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 500.ms),

                const SizedBox(height: 14),

                // Subtitle
                Text(
                  'Loading playful math...',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 500.ms),

                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
