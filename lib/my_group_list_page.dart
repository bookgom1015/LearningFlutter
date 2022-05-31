import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/add_button.dart';
import 'package:flutter_application_learning/components/fade_out.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;
import 'package:flutter_application_learning/components/group_list_view.dart';
import 'package:flutter_application_learning/components/http_helpers.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/loading.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/entries/subscriptions.dart';
import 'package:flutter_application_learning/entries/user.dart';

class MyGroupListPage extends StatefulWidget {
  const MyGroupListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyGroupListPageState();
}

class _MyGroupListPageState extends State<MyGroupListPage> {    
  Map _receivedData = {};

  late KeyValueStorage _storage;
  late User _user;

  late List<Group> _groups;

  bool _loaded = false;

  late double _deviceWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _deviceWidth = MediaQuery.of(context).size.width;

    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;
    _storage = _receivedData["stroage"];
    _user = User.fromJson(jsonDecode(_storage.get("user")));

    generateGroups();
  }

  void generateGroups() async {
    int statusCode = await getGroups(
      userId: _user.id,
      onFinished: (list) {
        setState(() {
          _groups = list;
          _loaded = true;
        });
      }
    );
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(
          height: globals.AppBarHeight, 
          title: "내 팀 목록",
          backgroundColor: globals.AppBarColor
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: globals.BackgroundColor
          ),
          child: Stack(
            children: [
              !_loaded ? loading() :
              createGroupListView(
                groups: _groups, 
                onTab: (index) {
                  Navigator.pushNamed(
                    context, "/group_details",
                    arguments: { 
                      "index": index,
                      "storage": _storage,
                      "group": _groups[index]
                    }
                  );
                }, 
                width: _deviceWidth, 
                height: 70, 
                tagsHeight: 20, 
                imageSize: 40,
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                padding: const EdgeInsets.all(10),
                descPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                viewItemPadding: const EdgeInsets.only(top: 20, bottom: 90)
              ),
              Positioned(
                bottom: 35,
                right: 35,
                child: createAddButton(
                  onTap: () {
                    Navigator.pushNamed(
                      context, 
                      "/add_group",
                      arguments: {
                        "storage": _storage,
                        "user": _user
                      }
                    ).then((value) {
                      setState(() {
                        
                      });
                    });
                  },
                  backgroundColors1: globals.AddGroupButtonBackgroundColors1,
                  backgroundColors2: globals.AddGroupButtonBackgroundColors2,
                  shadowColor: globals.ShadowColor
                )
              ),
              cretaeFadeOut(
                globals.BackgroundColor,
                const Color.fromARGB(0, 233, 232, 232)
              )
            ],
          ) 
        ),
      ),
    );
  }  
}