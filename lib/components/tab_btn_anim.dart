import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:flutter_application_learning/entries/tab_btn_model.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class TabButtonAnim extends StatefulWidget {
  final TabButtonModel model;
  final int index;
  final Function callback;

  const TabButtonAnim({
    Key? key, 
    required this.model,
    required this.index,
    required this.callback
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabButtonAnimState();
}

class _TabButtonAnimState extends State<TabButtonAnim> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _circleColorAnimation;
  late Animation<double> _sizeCurveAnimation;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: globals.AnimDuration)
    );

    _circleColorAnimation = ColorTween(
      begin: globals.IdentityColorLighter50,
      end: globals.IdentityColorLighter70
    ).animate(_controller);

    _sizeCurveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn
    );

    _sizeAnimation = Tween<double>(
      begin: 0,
      end: 1
    ).animate(_sizeCurveAnimation);

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
    const List<IconData> iconList = [
      Icons.comment_bank,
      Icons.list,
      Icons.manage_accounts
    ];

    return AnimatedContainer(
      margin: EdgeInsets.only(
        left: widget.model.animateMargin(widget.index),
        right: widget.model.animateMargin(widget.index),
      ),
      duration: const Duration(milliseconds: globals.AnimDuration),
      transform: Matrix4.translation(
        math.Vector3(
          widget.model.translateX(widget.index),
          0,
          0)
      ),
      child: SizedBox(
        width: globals.MaxTabBoxSize,
        height: globals.MaxTabBoxSize,
        child: Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, _) {
                  double tabBoxSize = (globals.MinTabBoxSize + (globals.MaxTabBoxSize - globals.MinTabBoxSize) * _sizeAnimation.value);
                  return Container(
                    width: tabBoxSize,
                    height: tabBoxSize,
                    decoration: BoxDecoration(
                      color: _circleColorAnimation.value,
                      shape: BoxShape.circle
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
                      iconList[widget.index],
                      size: (globals.MinTabIconSize + (globals.MaxTabIconSize - globals.MinTabIconSize) * _sizeAnimation.value),
                      color: widget.model.animateColor(
                        widget.index,
                        globals.FocusedForeground,
                        globals.UnfocusedForeground
                      ),
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