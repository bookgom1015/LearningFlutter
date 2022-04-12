import 'package:flutter/material.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

AppBar createAppBar(String navTitle) {
  return AppBar(
    title: Stack(
      children: <Widget>[
        Text(
          navTitle,
          style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = Colors.grey.shade600, // <-- Border color
          ),
        ),
        Text(
          navTitle,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // <-- Inner color
          ),
        ),
      ],
    ),
    backgroundColor: globals.IdentityColor,
  );
}