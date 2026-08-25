import 'package:flutter/material.dart';
import 'sound_manager.dart';

class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    // Play switch screens sound on pushing a new page screen over an existing one
    if (previousRoute != null && route is PageRoute) {
      SoundManager.instance.playSwitchScreensSound();
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    // Play switch screens sound on popping back to a previous page screen
    if (previousRoute != null && route is PageRoute) {
      SoundManager.instance.playSwitchScreensSound();
    }
  }
}
