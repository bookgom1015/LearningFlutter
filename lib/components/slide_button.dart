import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_application_learning/components/string_helper.dart';

class SlideButton extends StatefulWidget {  
  final double width;
  final double height;
  final String firstWord;
  final String secondWord;
  final IconData firstIcon;
  final IconData secondIcon;
  final void Function(bool) onChanged;

  const SlideButton({
    Key? key,
    required this.width,
    required this.height,
    required this.onChanged,
    required this.firstWord,
    required this.secondWord,
    required this.firstIcon,
    required this.secondIcon}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SlidedButtonState();
}

class _SlidedButtonState extends State<SlideButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  late Animation<double> _animation;
  late Animation _colorAnimation1;
  late Animation _colorAnimation2;

  late double _topPubTextPos;
  late double _rightPubTextPos;

  late double _topPrivateTextPos;
  late double _rightPrivateTextPos;

  late Size _publicTextSize;
  late Size _privateTextSize;

  final TextStyle _textStyle = const TextStyle(
    fontWeight: FontWeight.bold
  );

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300)
    );

    _curveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1
    ).animate(_curveAnimation);

    _colorAnimation1 = ColorTween(
      begin: const Color.fromARGB(255, 169, 255, 136),
      end: const Color.fromARGB(255, 255, 173, 126)
    ).animate(_curveAnimation);

    _colorAnimation2 = ColorTween(
      begin: const Color.fromARGB(255, 104, 175, 76),
      end: const Color.fromARGB(255, 187, 105, 58)
    ).animate(_curveAnimation);
    
    _publicTextSize = calcTextSize(widget.firstWord, _textStyle);
    _privateTextSize = calcTextSize(widget.secondWord, _textStyle);

    _topPubTextPos = widget.height * 0.5 - _publicTextSize.height * 0.5;
    _topPrivateTextPos = widget.height * 0.5 - _privateTextSize.height * 0.5;

    double halfWidth = (widget.width - widget.height) * 0.5;
    _rightPubTextPos = (halfWidth - _publicTextSize.width * 0.5);
    _rightPrivateTextPos = (halfWidth - _privateTextSize.width * 0.5);

    _controller.addListener(() { 
      if (_controller.isCompleted) {
        widget.onChanged(true);
      }
      else if (_controller.isDismissed) {
        widget.onChanged(false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                _colorAnimation1.value,
                _colorAnimation2.value,
              ]
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          child: ClipRect(
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                Positioned(
                  top: _topPubTextPos,
                  right: _rightPubTextPos * (1 - _animation.value) + -_publicTextSize.width * _animation.value,
                  child: Text(
                    widget.firstWord,
                    style: _textStyle
                  )
                ),
                Positioned(
                  top: _topPrivateTextPos,
                  left: _rightPrivateTextPos * _animation.value + -_privateTextSize.width * (1 - _animation.value),
                  child: Text(
                    widget.secondWord,
                    style: _textStyle
                  )
                ),
                Positioned(
                  top: 0,
                  left: 80 * _animation.value,
                  child: GestureDetector(
                    onTap: () {
                      if (_controller.isCompleted) {
                        _controller.reverse();
                      }
                      else if (_controller.isDismissed) {
                        _controller.forward();
                      }
                    },
                    child: Container(
                      width: widget.height,
                      height: widget.height,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          stops: [
                            0.0,
                            0.6
                          ],
                          colors: [
                            Colors.grey,
                            Colors.white,
                          ]
                        )
                      ),
                      child: Icon(
                        _controller.isCompleted ? widget.secondIcon : widget.firstIcon,
                        size: 28,
                      )
                    )
                  )
                )
              ]
            )
          )
        );
      }
    );
  }
}