import 'package:flutter/material.dart';
import 'package:flutter_application_learning/entries/tab_btn_model.dart';

class TabButtonAnim extends StatefulWidget {
  final TabButtonModel model;
  final PageController pageController;
  final int tabIndex;

  const TabButtonAnim({
    Key? key, 
    required this.model,
    required this.pageController,
    required this.tabIndex,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabButtonAnimState();
}

class _TabButtonAnimState extends State<TabButtonAnim> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _colorAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500)
    );

    _colorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.white
    ).animate(_controller);    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        return IconButton(
          onPressed: () {
            widget.model.updateIndex(widget.tabIndex);
            widget.pageController.animateToPage(
              widget.tabIndex,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }, 
          icon: Icon(
            Icons.adb,
            color: _colorAnimation.value,
          )
        );
      }
    );
  }
}