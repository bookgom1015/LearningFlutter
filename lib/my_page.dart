import 'package:flutter/material.dart';
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
  late List<Menu> _menus;

  @override
  void initState() {
    _menus = [
      Menu(
        icon: Icons.edit,
        title: "정보 수정",
        routeName: "/edit",
        arguments: {
          "user": widget.user,
          "subs": widget.subs,
        }
      ),
      Menu(
        icon: Icons.list_alt,
        title: "참여 중인 팀 목록",
        routeName: "/joining_group_list",
        arguments: {
          "user": widget.user,
          "subs": widget.subs,
        }
      ),
    ];

    super.initState();
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.BackgroundColor,
      body: Container(               
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0), 
        child: Column(
          children: [
            Container(              
              height: 200,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  stops: [
                    0.0,
                    0.5
                  ],
                  colors: [
                    globals.ListViewItemBackgroundColors1,
                    globals.ListViewItemBackgroundColors2,
                  ]
                ),
                borderRadius: globals.DefaultRadius,
                boxShadow: const [
                  BoxShadow(
                    color: globals.ShadowColor,
                    blurRadius: 12,
                    spreadRadius: 1,
                    offset: Offset(6, 8)
                  )
                ]
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
                          Navigator.pushNamed(
                            widget.context, "/edit",
                            arguments: { 
                              "user": widget.user,
                              "subs": widget.subs
                            }
                          );
                        },
                      )
                    )
                  )
                ]
              )
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _menus.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        widget.context, 
                        _menus[index].routeName,
                        arguments: _menus[index].arguments
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          stops: [
                            0.0,
                            0.5
                          ],
                          colors: [
                            globals.ListViewItemBackgroundColors1,
                            globals.ListViewItemBackgroundColors2,
                          ]
                        ),
                        borderRadius: globals.DefaultRadius,
                        boxShadow: const [
                          BoxShadow(
                            color: globals.ShadowColor,
                            blurRadius: 12,
                            spreadRadius: 1,
                            offset: Offset(6, 8)
                          )
                        ]
                      ),
                      height: 70,
                      child: Row(
                        children: [
                          Icon(
                            _menus[index].icon,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _menus[index].title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            )
                          )
                        ]
                      )
                    )
                  );
                }
              )
            )
          ]
        )
      ),
    );
  }  
}