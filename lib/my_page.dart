import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/group_list_view.dart';
import 'package:flutter_application_learning/entries/account.dart';
import 'package:flutter_application_learning/entries/menu.dart';
import 'package:flutter_application_learning/entries/subscriptions.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class MyPage extends StatefulWidget {
  final User user;
  final Subscriptions subs;
  final BuildContext context;
  final PageController pageController;

  const MyPage({
    Key? key,
    required this.user,
    required this.subs,
    required this.context, 
    required this.pageController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {  
  @override
  Widget build(BuildContext context) {
    const EdgeInsets margin = EdgeInsets.all(5);
    const EdgeInsets padding = EdgeInsets.all(10);
    const double imageBoxSize = 40;
    const double containerHeight = 70;

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double actualWidth = deviceWidth - padding.left - padding.right;
    final double postDescWidth = actualWidth - imageBoxSize;

    return Scaffold(
      backgroundColor: globals.BackgroundColor,
      body: Container(               
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0), 
        child: Column(
          children: [
            Container(              
              height: 200,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: globals.IdentityColor,
                borderRadius: globals.DefaultRadius
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(widget.user.userProfile.filePath)
                          )
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.userName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          const Text("E-mail@email.com")
                        ]
                      )
                    ]
                  ),
                  Expanded(child: Container()),
                  SizedBox(
                    height: 30,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          print("pressed");
                        },
                      )
                    )
                  )
                ]
              )
            ),
            const SizedBox(height: 10),
            Expanded(
              child: createGroupListView(
                groups: widget.subs.groups,
                onTab: (index) {},
                width: postDescWidth,
                height: containerHeight,
                tagsHeight: 20,
                imageSize: 40,
                margin: margin,
                padding: padding,
                descPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0)
              )
            )
          ]
        )
      ),
    );
  }  
}