import 'dart:async';

import 'package:flutter/material.dart';

class DelayedWidget extends StatefulWidget {
  /// Child that will be displayed with the animation and delay
  final Widget child;

  /// Delay before displaying the widget and the animations
  final Duration delay;

  /// Duration of the fading animation
  final Duration fadingDuration;

  /// Curve of the sliding animation
  final Curve slidingCurve;

  /// Offset of the widget at the beginning of the sliding animation
  final Offset slidingBeginOffset;

  /// If true, make the child appear, disappear otherwise. Default to true.
  final bool fadeIn;

  /// DelayedDisplay constructor
  const DelayedWidget({
    required this.child,
    this.delay = Duration.zero,
    this.fadingDuration = const Duration(milliseconds: 600),
    this.slidingCurve = Curves.decelerate,
    this.slidingBeginOffset = const Offset(0.0, 0.35),
    this.fadeIn = true,
  });

  @override
  _DelayedWidgetState createState() => _DelayedWidgetState();
}

class _DelayedWidgetState extends State<DelayedWidget>
    with TickerProviderStateMixin {
  /// Controller of the opacity animation
  late AnimationController _opacityController;

  /// Sliding Animation offset
  late Animation<Offset> _slideAnimationOffset;

  /// Timer used to delayed animation
  Timer? _timer;

  /// Simple getter for widget's delay
  Duration get delay => widget.delay;

  /// Simple getter for widget's opacityTransitionDuration
  Duration get opacityTransitionDuration => widget.fadingDuration;

  /// Simple getter for widget's slidingCurve
  Curve get slidingCurve => widget.slidingCurve;

  /// Simple getter for widget's beginOffset
  Offset get beginOffset => widget.slidingBeginOffset;

  /// Simple getter for widget's fadeIn
  bool get fadeIn => widget.fadeIn;

  /// Initialize controllers, curve and offset with given parameters or default values
  /// Use a Timer in order to delay the animations if needed
  @override
  void initState() {
    super.initState();

    _opacityController = AnimationController(
      vsync: this,
      duration: opacityTransitionDuration,
    );

    final CurvedAnimation curvedAnimation = CurvedAnimation(
      curve: slidingCurve,
      parent: _opacityController,
    );

    _slideAnimationOffset = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(curvedAnimation);

    _runFadeAnimation();
  }

  /// Dispose the opacity controller
  @override
  void dispose() {
    _opacityController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  /// Whenever the widget is updated and that fadeIn is different from the oldWidget, triggers the fade in
  /// or out animation.
  @override
  void didUpdateWidget(DelayedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fadeIn == fadeIn) {
      return;
    }
    _runFadeAnimation();
  }

  void _runFadeAnimation() {
    _timer = Timer(delay, () {
      fadeIn ? _opacityController.forward() : _opacityController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SlideTransition(
        position: _slideAnimationOffset,
        child: widget.child,
      ),
      opacity: _opacityController,
    );
  }
}
