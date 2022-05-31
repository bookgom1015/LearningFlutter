import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/fade_out.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/mene_list.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _user = User.fromJson(jsonDecode(widget.storage.get("user")));
    
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
        icon: Icons.list,
        title: "참여 중인 팀 목록",
        routeName: "/joining_group_list",
        arguments: {
          "stroage": widget.storage
        }
      ),
      Menu(
        icon: Icons.list,
        title: "내 팀 목록",
        routeName: "/my_group_list",
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
  }

  void onEditProfileButtonClicked() {
    Navigator.pushNamed(
      widget.context, "/edit_profile",
      arguments: { 
        "storage": widget.storage
      }
    ).then((value) {
      setState(() {
        _user = User.fromJson(jsonDecode(widget.storage.get("user")));                      
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.BackgroundColor,
      body: Container(               
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0), 
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 20),
                    itemCount: _menus.length + 1,
                    itemBuilder: (_, index) {
                      if (index == 0) {
                        return profileWidget();
                      }
                      return createMenuListView(
                        context: widget.context, 
                        menus: _menus,
                        index: index - 1,
                        bottomRightColor: globals.ListViewItemBackgroundColors1,
                        topLeftColor: globals.ListViewItemBackgroundColors2,
                        shadowColor: globals.ShadowColor,
                        borderRadius: globals.DefaultRadius
                      );
                    }
                  )
                )
              ]
            ),
            cretaeFadeOut(
              globals.BackgroundColor,
              const Color.fromARGB(0, 233, 232, 232)
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
                onPressed: onEditProfileButtonClicked,
              )
            )
          )
        ]
      )
    );
  }
}