import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_application_learning/globals.dart' as globals;

class StarAnim extends StatefulWidget {
  final double size;

  const StarAnim({Key? key, required this.size}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StarAnimState();
}

class _StarAnimState extends State<StarAnim> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _colorAnimation;
  late Animation _rotationAnimation;

  bool isFav = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180)
    );

    _colorAnimation = ColorTween(
      begin: globals.UnfocusedForeground,
      end: Colors.yellow
    ).animate(_controller);

    _rotationAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: math.pi / 6),
          weight: 20
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: math.pi / 6, end: -math.pi / 12),
          weight: 60
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: -math.pi / 12, end: 0),
          weight: 20
        )
      ]
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isFav = true;
        });
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          isFav = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: IconButton(
            onPressed: () {
              if (isFav) {
                _controller.reverse();
              } else {
                _controller.forward();
              }
            }, 
            icon: Icon(
              Icons.star,
              color: _colorAnimation.value,
              size: widget.size,
            )
          ),
        );
      }
    );
  }
}