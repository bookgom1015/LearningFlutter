import 'package:flutter/material.dart';
import 'dart:math' as math;

class HeartAnim extends StatefulWidget {
  final double beginSize;
  final double endSize;
  final Color fromColor;
  final Color toColor;
  final double stroke;
  final Color storkeFromColor;
  final Color storkeToColor;

  const HeartAnim({
    Key? key, 
    required this.beginSize, 
    required this.endSize,
    required this.fromColor,
    required this.toColor,
    required this.stroke,
    required this.storkeFromColor,
    required this.storkeToColor}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HeartAnimState();
}

class _HeartAnimState extends State<HeartAnim> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  late Animation _colorAnimation;
  late Animation _strokeColorAnimation;
  late Animation _sizeAnimation;

  bool isFav = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150)
    );

    _curveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.slowMiddle
    );

    _colorAnimation = ColorTween(
      begin: widget.fromColor,
      end: widget.toColor
    ).animate(_curveAnimation);

    _strokeColorAnimation = ColorTween(
      begin: widget.storkeFromColor,
      end: widget.storkeToColor
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
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        return Stack(
          children: [
            Center(
              child: Icon(
                Icons.favorite,
                size: _sizeAnimation.value,
                color: _strokeColorAnimation.value,
              )
            ),
            Center(
              child: IconButton(
                onPressed: () {
                  if (isFav) {
                    _controller.reverse();
                  } else {
                    _controller.forward();
                  }
                }, 
                icon: Icon(
                  Icons.favorite,
                  color: _colorAnimation.value,
                  size: math.max(_sizeAnimation.value - widget.stroke, 0),
                )
              )
            )
          ]
        );
      }
    );
  }
}