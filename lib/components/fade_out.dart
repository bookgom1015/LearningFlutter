import 'package:flutter/material.dart';

Widget cretaeFadeOut(Color fromColor, Color toColor) {
  return Container(
    height: 30,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          fromColor,
          toColor,
        ]
      )
    )
  );
}