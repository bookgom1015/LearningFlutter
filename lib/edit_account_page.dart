import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class EditAccountPage extends StatelessWidget {
  const EditAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(
          height: globals.AppBarHeight,
          backgroundColor: globals.AppBarColor,
          title: "정보 수정"
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: globals.BackgroundColor
          )
        )
      )
    );
  }
}