import 'package:flutter/material.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class PublicPage extends StatefulWidget {
  const PublicPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PublicPageState();  
}

class _PublicPageState extends State<PublicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: globals.BackgroundColor
        ),
        child: const Center(
          child: Text(
            "공용 게시판",
            style: TextStyle(
              color: globals.FocusedForeground
            ),
          )
        ),
      ),
    );
  }
}