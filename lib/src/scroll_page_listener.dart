import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/src/scroll_page_mixin.dart';

class ScrollPageListener extends StatelessWidget {
  final ScrollPageMixin parentState;
  final ValueChanged<Offset> onStart;
  final ValueChanged<DragEndDetails> onEnd;
  final ValueChanged<DragUpdateDetails> onUpdate;
  final Widget child;

  const ScrollPageListener({
    super.key,
    required this.parentState,
    required this.onStart,
    required this.onUpdate,
    required this.onEnd,
    required this.child,
  });

  bool get _dragUnderway => parentState.dragUnderway;

  void _startOrUpdateDrag(DragUpdateDetails? details) {
    if (details == null) return;
    if (_dragUnderway) {
      onUpdate(details);
    } else {
      onStart(details.globalPosition);
    }
  }

  void _updateDrag(DragUpdateDetails? details) {
    if (details != null && details.primaryDelta != null) {
      if (_dragUnderway) {
        onUpdate(details);
      }
    }
  }

  bool _onScrollNotification(ScrollNotification scrollInfo) {
    if (Axis.horizontal == scrollInfo.metrics.axis) {
      if (scrollInfo is OverscrollNotification) {
        _startOrUpdateDrag(scrollInfo.dragDetails);
        return false;
      }

      if (scrollInfo is ScrollUpdateNotification) {
        if (scrollInfo.metrics.outOfRange) {
          _startOrUpdateDrag(scrollInfo.dragDetails);
        } else {
          _updateDrag(scrollInfo.dragDetails);
        }
        return false;
      }
    }

    return false;
  }

  void _onPointerDown(PointerDownEvent event) {
    parentState.velocityTracker = VelocityTracker.withKind(event.kind);

    parentState.activePointerCount++;
  }

  void _onPointerMove(PointerMoveEvent event) {
    parentState.velocityTracker?.addPosition(event.timeStamp, event.position);
  }

  void _onPointerUp(PointerEvent event) {
    parentState.activePointerCount--;

    if (_dragUnderway && parentState.activePointerCount == 0) {
      if (parentState.velocityTracker != null) {
        onEnd(
          DragEndDetails(velocity: parentState.velocityTracker!.getVelocity()),
        );
      } else {
        onEnd(DragEndDetails());
      }
    }

    parentState.velocityTracker = null;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerCancel: _onPointerUp,
      onPointerUp: _onPointerUp,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: child,
      ),
    );
  }
}
