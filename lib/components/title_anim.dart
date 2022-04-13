import 'package:flutter/material.dart';
import 'package:flutter_application_learning/entries/tab_btn_model.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class TitleFadeInAnim extends StatefulWidget {
  final String title;
  final TabButtonModel model;

  const TitleFadeInAnim({
    Key? key, 
    required this.title,
    required this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TitleFadeInAnimState();
}

class _TitleFadeInAnimState extends State<TitleFadeInAnim> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: globals.AnimDuration)
    );

    _curveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1
    ).animate(_curveAnimation);

    widget.model.addListener(() {
      _controller.reset();
        _controller.forward();
    });

    _controller.forward();
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
        return Opacity(
          opacity: _animation.value,
          child: Container(
            transform: Matrix4.translationValues(
              -100 * (1 - _animation.value), 0, 0
            ),
            child: Stack(
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = globals.BackgroundColor,
                  ),
                ),
                Text(
                  widget.title,
                  style: const TextStyle( 
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            )
          )
        );
      }
    );
  }
}