import 'package:flutter/material.dart';
import 'package:flutter_application_learning/entries/tab_btn_model.dart';

class TabButtonAnim extends StatefulWidget {
  final TabButtonModel model;
  final int index;
  final Function callback;
  final List<IconData> icons;
  final double minSize;
  final double maxSize;
  final double minIconSize;
  final double maxIconSize;
  final Color fromColor;
  final Color toColor;
  final Color fromIconColor;
  final Color toIconColor;
  final int animDuration;

  const TabButtonAnim({
    Key? key, 
    required this.model,
    required this.index,
    required this.callback,
    required this.icons,
    required this.minSize,
    required this.maxSize,
    required this.minIconSize,
    required this.maxIconSize,
    required this.fromColor,
    required this.toColor,
    required this.fromIconColor,
    required this.toIconColor,
    required this.animDuration
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabButtonAnimState();
}

class _TabButtonAnimState extends State<TabButtonAnim> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _colorAnimation;
  late Animation _iconColorAnimation;
  late Animation<double> _curveAnimation;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animDuration)
    );

    _curveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn
    );

    _colorAnimation = ColorTween(
      begin: widget.fromColor,
      end: widget.toColor
    ).animate(_curveAnimation);

    _iconColorAnimation = ColorTween(
      begin: widget.fromIconColor,
      end: widget.toIconColor
    ).animate(_curveAnimation);

    _animation = Tween<double>(
      begin: 0,
      end: 1
    ).animate(_curveAnimation);

    widget.model.addListener(() { 
      if (widget.model.canAnimate(widget.index)) {
        _controller.forward();
      }
      else {
        _controller.reverse();
      }
    });

    if (widget.index == 0) {
      _controller.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: widget.animDuration),
      child: SizedBox(
        width: widget.maxSize,
        height: widget.maxSize,
        child: Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, _) {                  
                  double tabBoxSize = (widget.minSize + (widget.maxSize - widget.minSize) * _animation.value);
                  return Container(
                    width: tabBoxSize,
                    height: tabBoxSize,
                    decoration: BoxDecoration(                      
                      color: _colorAnimation.value,
                      shape: BoxShape.circle,
                      boxShadow: [          
                        BoxShadow(
                          color: _animation.value == 1 ? _colorAnimation.value : Colors.transparent,
                          spreadRadius: 2,
                          blurRadius: 8,
                        )
                      ]
                    ),
                  );
                },
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, _) {
                  return GestureDetector(
                    onTap: () {
                      widget.callback();
                    },
                    child: Icon(
                      widget.icons[widget.index],
                      size: (widget.minIconSize + (widget.maxIconSize - widget.minIconSize) * _animation.value),
                      color: _iconColorAnimation.value,
                    )
                  );
                },
              )
            )
          ]
        ),
      )
    );
  }
}