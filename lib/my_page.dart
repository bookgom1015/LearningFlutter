import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/entries/menu.dart';
import 'package:flutter_application_learning/entries/subscriptions.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;

class MyPage extends StatefulWidget {
  final KeyValueStorage storage;
  final BuildContext context;
  final PageController pageController;

  const MyPage({
    Key? key,
    required this.storage,
    required this.context, 
    required this.pageController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {  
  late List<Menu> _menus;

  late User _user;
  late Subscriptions _subs;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _user = User.fromJson(jsonDecode(widget.storage.get("user")));
    _subs = Subscriptions.fromJson(jsonDecode(widget.storage.get("subs")));
    _menus = [
      Menu(
        icon: Icons.edit,
        title: "정보 수정",
        routeName: "/edit_account",
        arguments: {
          "stroage": widget.storage
        },
        then: () {
          // The code below is for rebuilding this page.
          setState(() {
            _user = User.fromJson(jsonDecode(widget.storage.get("user")));
          });
        }
      ),
      Menu(
        icon: Icons.list_alt,
        title: "참여 중인 팀 목록",
        routeName: "/joining_group_list",
        arguments: {
          "stroage": widget.storage
        }
      ),
      Menu(
        icon: Icons.add_reaction,
        title: "팀 생성",
        routeName: "/add_group",
        arguments: {
          "stroage": widget.storage
        }
      ),
      Menu(
        icon: Icons.warning,
        title: "회원 탈퇴",
        routeName: "/withdrawal",
        arguments: {
          "stroage": widget.storage
        }
      )
    ];
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
            Expanded(
              child: ListView.builder(
                itemCount: _menus.length + 1,
                itemBuilder: (_, index) {
                  if (index == 0) {
                    return profileWidget();
                  }
                  return menuWidget(index - 1);
                }
              )
            )
          ]
        )
      ),
    );
  }

  Widget profileWidget() {
    return Container(              
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
                    image: AssetImage(_user.userProfile.filePath)
                  )
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _user.userNickname,
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
          const SizedBox(height: 10),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                _user.userProfile.desc,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              )
            )
          ),
          SizedBox(
            height: 30,
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(
                    widget.context, "/edit_profile",
                    arguments: { 
                      "storage": widget.storage
                    }
                  ).then((value) {
                    // The code below is for rebuilding this page.
                    setState(() {
                      _user = User.fromJson(jsonDecode(widget.storage.get("user")));
                    });
                  });
                },
              )
            )
          )
        ]
      )
    );
  }

  Widget menuWidget(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          widget.context, 
          _menus[index].routeName,
          arguments: _menus[index].arguments
        ).then((value) {
          if (_menus[index].then != null) {
            _menus[index].then!();
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
}