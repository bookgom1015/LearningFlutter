import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;

class PermisionPage extends StatefulWidget {
  const PermisionPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PermisionPageStaet();
}

class _PermisionPageStaet extends State<PermisionPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(
          height: globals.AppBarHeight,
          title: "관리자 페이지",
          backgroundColor: globals.BackgroundColor
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: globals.BackgroundColor
          ),
        ),
      ),
    );
  }
}