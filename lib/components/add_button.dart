import 'package:flutter/material.dart';
import 'dart:math' as math;

Widget createAddButton({
    void Function()? onTap,
    bool disabled = false,
    Color backgroundColors1 = Colors.white,
    Color backgroundColors2 = Colors.grey,
    Color shadowColor = Colors.black}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          stops: const [
            0.2,
            0.6,
          ],
          colors: [
            backgroundColors1,
            backgroundColors2,
          ]
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(6, 8)
          )
        ]
      ),
      child: Transform.rotate(
        angle: disabled ? 45 * math.pi / 180 : 0,
        child: Icon(
          Icons.add_rounded,
          size: 64,
          color: disabled ? Colors.grey : Colors.black
        )
      )    )                    
  );
}