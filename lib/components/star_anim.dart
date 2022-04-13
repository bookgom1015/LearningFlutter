import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_application_learning/globals.dart' as globals;

class StarAnim extends StatefulWidget {
  final double beginSize;
  final double endSize;

  const StarAnim({
    Key? key, 
    required this.beginSize,
    required this.endSize}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StarAnimState();
}

class _StarAnimState extends State<StarAnim> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  late Animation _colorAnimation;
  late Animation _sizeAnimation;
  late Animation _rotationAnimation;

  bool isFav = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180)
    );

    _curveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutSine
    );

    _colorAnimation = ColorTween(
      begin: globals.UnfocusedForeground,
      end: Colors.yellow
    ).animate(_curveAnimation);

    _sizeAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: widget.beginSize, end: widget.endSize),
          weight: 50
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: widget.endSize, end: widget.beginSize),
          weight: 50
        )
      ]
    ).animate(_curveAnimation);

    _rotationAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: math.pi / 6),
          weight: 50
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: math.pi / 6, end: 0),
          weight: 50
        )
      ]
    ).animate(_curveAnimation);

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
              size: _sizeAnimation.value,
            )
          ),
        );
      }
    );
  }
}