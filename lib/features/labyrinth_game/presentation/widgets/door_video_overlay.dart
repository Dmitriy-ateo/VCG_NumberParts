import 'package:flutter/material.dart';
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
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasFinished = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      _controller = VideoPlayerController.asset(widget.videoAsset);
      await _controller.initialize();
      _controller.setLooping(false);
      _controller.addListener(_videoListener);
      await _controller.play();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('DoorVideoOverlay error initializing video: $e');
      // If error (e.g. codec issue), automatically complete without blocking gameplay
      _complete();
    }
  }

  void _videoListener() {
    if (!_controller.value.isInitialized) return;
    if (_controller.value.position >= _controller.value.duration &&
        _controller.value.duration > Duration.zero) {
      _complete();
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
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _complete,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.black.withAlpha(200),
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
                if (_isInitialized)
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio > 0
                        ? _controller.value.aspectRatio
                        : 16 / 9,
                    child: VideoPlayer(_controller),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(40),
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
