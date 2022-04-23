import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/heart_anim.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/components/star_anim.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class DetailGroupPage extends StatefulWidget {
  const DetailGroupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailGroupPageState();  
}

class _DetailGroupPageState extends State<DetailGroupPage> {
  Map _receivedData = {};

  @override
  Widget build(BuildContext context) {
    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;

    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar("Detail Group"),
        body: Container(
          decoration: const BoxDecoration(
            color: globals.BackgroundColor
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  profileBox(),
                  buttonsBox()
                ],
              ),
              postBox()
            ],
          )
        )
      )
    );
  }

  Widget profileBox() {
    return Expanded(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 200,
          maxHeight: 200,
          minHeight: 200
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: globals.DefaultRadius,
            color: globals.IdentityColor
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ConstrainedBox(                
                  constraints: const BoxConstraints(
                    maxWidth: 128,
                    minWidth: 64,
                    maxHeight: 128,
                    minHeight: 64
                  ),
                  child: Hero(
                    tag: _receivedData['index'].toString(),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(_receivedData['image']),
                        )
                      )
                    )
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: const Center(
                  child: Text(
                    "Hello",
                    style: TextStyle(
                      color: globals.FocusedForeground
                    ),
                  ),
                ),
              )
            ],
          )
        ),
      )
    );
  }

  Widget buttonsBox() {
    return SizedBox(
      width: 80,
      height: 200,
      child: Container(
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
        decoration: BoxDecoration(
          borderRadius: globals.DefaultRadius,
          color: globals.IdentityColor
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 45,
              child: IconButton(
                onPressed: () {}, 
                icon: const Icon(Icons.call),
                color: globals.FocusedForeground,
              ),
            ),
            SizedBox(
              height: 45,
              child: IconButton(
                onPressed: () {}, 
                icon: const Icon(Icons.message),
                color: globals.FocusedForeground,
              ),
            ),
            const SizedBox(
              height: 45,
              child: StarAnim(beginSize: 24, endSize: 32),
            ),
            const SizedBox(
              height: 45,
              child: HeartAnim(beginSize: 24, endSize: 32)
            ),
          ],
        )
      ),
    );
  }

  Widget postBox() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: globals.IdentityColor
        ),
        child: const Center(
          child: Text(
              "대충 글 들어갈 곳",
              style: TextStyle(
                color: globals.FocusedForeground
              ),
            )
          ),
      )
    );
  }
}