import 'package:flutter/material.dart';

class Menu {
  IconData icon;
  String title;
  String routeName;
  Object? arguments;

  Menu({
    required this.icon,
    required this.title,
    required this.routeName,
    this.arguments
  });
}