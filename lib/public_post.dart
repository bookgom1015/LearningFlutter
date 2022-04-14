import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class PublicPostPage extends StatefulWidget {
  const PublicPostPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PublicPostPageState();
}

class _PublicPostPageState extends State<PublicPostPage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar("[Category]"),
        body: Container(
          decoration: const BoxDecoration(
            color: globals.BackgroundColor
          ),
        ),
      ),      
    );
  }
}