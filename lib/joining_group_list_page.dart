import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/fade_out.dart';
import 'package:flutter_application_learning/components/group_list_view.dart';
import 'package:flutter_application_learning/components/http_helpers.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/loading.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/entries/subscriptions.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;

class JoiningGroupListPage extends StatefulWidget {
  const JoiningGroupListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _JoiningGroupListPageState();
}

class _JoiningGroupListPageState extends State<JoiningGroupListPage> {
  Map _receivedData = {};

  late KeyValueStorage _storage;

  late User _user;
  late Subscriptions _subs;

  bool _loaded = false;

  late double _deviceWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _deviceWidth = MediaQuery.of(context).size.width;

    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;
    _storage = _receivedData["stroage"];
    _user = User.fromJson(jsonDecode(_storage.get("user")));

    generateSubs();
  }

  void generateSubs() async {    
    int statusCode = await getSubscriptions(
      _user.id,
      (data) {
        setState(() {
          _subs = data;
          _loaded = true;
        });
      }
    );
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
      return;
    }

    _storage.set("subs", _subs.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(
          height: globals.AppBarHeight,
          backgroundColor: globals.AppBarColor,
          title: "참여 중인 팀 목록"
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: globals.BackgroundColor
              ),
              child: !_loaded ? loading() :
              createGroupListView(
                groups: _subs.groups,
                onTab: (index) {
                  Navigator.pushNamed(
                    context, "/group_details",
                    arguments: { 
                      "index": index,
                      "storage": _storage,
                      "group": _subs.groups[index]
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
                viewItemPadding: const EdgeInsets.only(top: 20)
              )
            ),
            cretaeFadeOut(
              globals.BackgroundColor,
              const Color.fromARGB(0, 233, 232, 232)
            )
          ]
        )
      )
    );
  }
}