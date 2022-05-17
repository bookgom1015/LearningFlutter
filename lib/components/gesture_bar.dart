import 'package:flutter/material.dart';

class GestureBar extends StatelessWidget {
  final Function(DragStartDetails) onVerticalDragStart;
  final Function(DragUpdateDetails) onVerticalDragUpdate;
  final Function(DragEndDetails) onVerticalDragEnd;

  final double height;
  
  const GestureBar({
    Key? key,
    required this.height,
    required this.onVerticalDragStart,
    required this.onVerticalDragUpdate,
    required this.onVerticalDragEnd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: onVerticalDragStart,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd, 
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: Colors.transparent
        ),
        
      )
    );
  }
}