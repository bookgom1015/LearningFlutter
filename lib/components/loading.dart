import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;

Widget loading() {
  return const Center(
    child: Text(
      "Loading...",
      style: TextStyle(
        color: globals.FocusedForeground
      ),
    )
  );
}