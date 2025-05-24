import 'package:flutter/gestures.dart';

mixin ScrollPageMixin {
  VelocityTracker? velocityTracker;

  int activePointerCount = 0;

  // ignore: prefer_final_fields
  bool dragUnderway = false;

  // bool get _isActive => _dragUnderway || _moveController.isAnimating;
  bool get isActive => dragUnderway;
}
