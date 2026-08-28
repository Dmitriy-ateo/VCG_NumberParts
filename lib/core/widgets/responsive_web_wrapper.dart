import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Responsive wrapper that centers the application in a mobile-width viewport
/// on wide desktop and web browser windows.
class ResponsiveWebWrapper extends StatelessWidget {
  final Widget child;

  /// Standard max mobile width (ideal for portrait mobile gameplay)
  static const double maxMobileWidth = 480.0;

  const ResponsiveWebWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        // If screen is within standard mobile width, render child directly
        if (screenWidth <= maxMobileWidth) {
          return child;
        }

        // On desktop / wide web browsers, constrain width to mobile viewport
        final effectiveWidth = math.min(screenWidth, maxMobileWidth);
        final mediaQuery = MediaQuery.of(context);
        final clampedMediaQuery = mediaQuery.copyWith(
          size: Size(effectiveWidth, screenHeight.isFinite ? screenHeight : mediaQuery.size.height),
        );

        return Container(
          color: const Color(0xFFEFE8DE), // Warm pastel desktop background
          alignment: Alignment.center,
          child: Container(
            constraints: const BoxConstraints(maxWidth: maxMobileWidth),
            decoration: const BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 32,
                  spreadRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRect(
              child: MediaQuery(
                data: clampedMediaQuery,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
