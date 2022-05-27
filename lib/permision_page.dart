import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;

class PermisionPage extends StatefulWidget {
  const PermisionPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PermisionPageState();
}

class _PermisionPageState extends State<PermisionPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(
          height: globals.AppBarHeight, 
          title: "참가 요청 목록"),
      ),
    );
  }  
}