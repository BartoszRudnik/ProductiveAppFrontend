import 'package:flutter/material.dart';
import 'package:productive_app/config/images.dart';

class AnimatedImage extends StatefulWidget {
  @override
  _AnimatedImageState createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    this._controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    this._animation = Tween(
      begin: Offset.zero,
      end: Offset(0, 0.18),
    ).animate(this._controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: this._animation,
      child: Image.asset(
        Theme.of(context).brightness == Brightness.light ? Images.loadingScreenImageLight : Images.loadingScreenImageDark,
      ),
    );
  }
}
