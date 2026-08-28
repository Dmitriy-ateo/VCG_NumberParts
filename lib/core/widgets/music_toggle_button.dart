import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../audio/sound_manager.dart';
import 'bouncy_button.dart';

class MusicToggleButton extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final Color? shadowColor;

  const MusicToggleButton({
    super.key,
    this.size = 48,
    this.backgroundColor,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: SoundManager.instance.isMusicEnabled,
      builder: (context, isMusicEnabled, _) {
        return BouncyButton(
          height: size,
          padding: EdgeInsets.zero,
          backgroundColor: backgroundColor ?? AppColors.surfaceWarm,
          shadowColor: shadowColor ?? AppColors.woodBorder,
          borderRadius: BorderRadius.circular(size * 0.42),
          bevelHeight: 3.5,
          onPressed: () {
            SoundManager.instance.toggleMusic();
          },
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: isMusicEnabled
                  ? const Text('🎵', style: TextStyle(fontSize: 20))
                  : const Text('🔇', style: TextStyle(fontSize: 20)),
            ),
          ),
        );
      },
    );
  }
}
