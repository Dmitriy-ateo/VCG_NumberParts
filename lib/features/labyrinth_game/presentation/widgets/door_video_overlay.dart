import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class DoorVideoOverlay extends StatefulWidget {
  final String videoAsset;
  final VoidCallback onFinished;
  final String? title;

  const DoorVideoOverlay({
    super.key,
    required this.videoAsset,
    required this.onFinished,
    this.title,
  });

  @override
  State<DoorVideoOverlay> createState() => _DoorVideoOverlayState();
}

class _DoorVideoOverlayState extends State<DoorVideoOverlay> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasFinished = false;
  bool _hasStartedPlaying = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      VideoPlayerController controller;

      if (kIsWeb) {
        controller = VideoPlayerController.asset(widget.videoAsset);
      } else {
        // For macOS, iOS, Android: write asset bytes to a temp file to ensure AVPlayer / ExoPlayer compatibility
        final file = await _getCacheFile(widget.videoAsset);
        controller = VideoPlayerController.file(file);
      }

      _controller = controller;
      await controller.initialize();
      await controller.setLooping(false);
      await controller.setVolume(1.0);

      controller.addListener(_videoListener);
      await controller.play();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('DoorVideoOverlay video init fallback error: $e');
      // If native player fails, wait a brief moment for transition then proceed smoothly
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) _complete();
      });
    }
  }

  Future<File> _getCacheFile(String assetPath) async {
    final filename = assetPath.split('/').last;
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');

    if (!await file.exists() || await file.length() == 0) {
      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );
      await file.writeAsBytes(bytes, flush: true);
    }
    return file;
  }

  void _videoListener() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (controller.value.isPlaying && controller.value.position > const Duration(milliseconds: 100)) {
      _hasStartedPlaying = true;
    }

    if (_hasStartedPlaying) {
      final isAtEnd = controller.value.position >= controller.value.duration - const Duration(milliseconds: 150);
      final isCompleted = controller.value.isCompleted;

      if (isAtEnd || isCompleted) {
        _complete();
      }
    }
  }

  void _complete() {
    if (_hasFinished) return;
    _hasFinished = true;
    if (mounted) {
      widget.onFinished();
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return GestureDetector(
      onTap: _complete,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.black.withAlpha(210),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1308),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.woodBorder.withAlpha(220),
                width: 3.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 10),
                  blurRadius: 24,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (controller != null && _isInitialized)
                  AspectRatio(
                    aspectRatio: controller.value.aspectRatio > 0
                        ? controller.value.aspectRatio
                        : 16 / 9,
                    child: VideoPlayer(controller),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(48),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.pastelPeach),
                    ),
                  ),

                // Skip Button in top right
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: _complete,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24, width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Skip',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.fast_forward_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
