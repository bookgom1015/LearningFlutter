import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/group_list_view.dart';
import 'package:flutter_application_learning/components/http_helpers.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/loading.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/entries/subscriptions.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;
import 'package:http/http.dart' as http;

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

  late List<Group> _groups;

  bool _loaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;
    _storage = _receivedData["stroage"];
    _user = User.fromJson(jsonDecode(_storage.get("user")));

    generateSubs();

    super.didChangeDependencies();
  }

  void generateSubs() async {
    int statusCode = await getSubscriptions(
      _user.id,
      (data) {
        _subs = data;
      }
    );
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
      return;
    }

    _storage.set("subs", _subs.toString());

    generateGroups();
  }

  void generateGroups() async {
    int statusCode = await getGroups((list) {
      setState(() {
        _groups = list;
        _loaded = true;
      });
    });
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    const EdgeInsets margin = EdgeInsets.fromLTRB(10, 5, 10, 5);
    const EdgeInsets padding = EdgeInsets.all(10);
    const double imageBoxSize = 40;
    const double containerHeight = 70;

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double actualWidth = deviceWidth - padding.left - padding.right;
    final double postDescWidth = actualWidth - imageBoxSize;

    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(
          height: globals.AppBarHeight,
          backgroundColor: globals.AppBarColor,
          title: "참여 중인 팀 목록"
        ),
        body: _loaded ? Container(
          decoration: const BoxDecoration(
            color: globals.BackgroundColor
          ),
          child: createGroupListView(
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
            width: postDescWidth,
            height: containerHeight,
            tagsHeight: 20,
            imageSize: 40,
            margin: margin,
            padding: padding,
            descPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0)
          )
        ) : loading()
      )
    );
  }
}