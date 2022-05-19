import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/group_list_view.dart';
import 'package:flutter_application_learning/components/loading.dart';
import 'package:flutter_application_learning/components/search_bar.dart';
import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/entries/subscriptions.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:flutter_application_learning/globals.dart' as globals;
import 'package:http/http.dart' as http;

class GroupListPage extends StatefulWidget {
  final User user;
  final Subscriptions subs;
  final BuildContext context;
  final PageController pageController;

  const GroupListPage({
    Key? key, 
    required this.user,
    required this.subs,
    required this.context, 
    required this.pageController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  List<Group> _groups = [];

  final List<String> _dropDownMenuItemList = [
    "One", "Two", "Three", "Four"
  ];

  final FocusNode _searchBarFocusNode = FocusNode();
  final TextEditingController _searchBarController = TextEditingController();

  bool _loaded = false;

  void getGroupList() async {
    StringBuffer uri = StringBuffer();
    uri.write(globals.SpringUriPath);
    uri.write("/api/team");

    var response = await http.get(Uri.parse(uri.toString()));

    if (response.statusCode != 200) {
      print("error occured: " + response.statusCode.toString());
      return;
    }

    List<Group> groups  = [];

    Map<String, dynamic> json = jsonDecode(response.body);
    List<dynamic> teamJsonArray = json["teams"];
    for (var teamJson in teamJsonArray) {
      groups.add(Group.fromJson(teamJson));
    }

    setState(() {
      _groups = groups;
      _loaded = true;
    });
  }

  @override
  void initState() {
    getGroupList();    

    widget.pageController.addListener(() {
      if(_searchBarFocusNode.hasFocus) {
        SearchBarLostedFocus();
      }
    });
    super.initState();    
  }

  @override
  void dispose() {
    super.dispose();
    _searchBarFocusNode.dispose();
    _searchBarController.dispose();
  }

  // ignore: non_constant_identifier_names
  void SearchBarLostedFocus() {
    _searchBarFocusNode.unfocus();
    _searchBarController.clear();
  }

  @override
  Widget build(BuildContext _) {
    const EdgeInsets margin = EdgeInsets.fromLTRB(10, 5, 10, 5);
    const EdgeInsets padding = EdgeInsets.all(10);
    const double imageBoxSize = 40;
    const double containerHeight = 70;

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double actualWidth = deviceWidth - padding.left - padding.right;
    final double postDescWidth = actualWidth - imageBoxSize;

    return Scaffold(
      backgroundColor: globals.BackgroundColor,
      body: Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: [
            SearchBar(
              focusNode: _searchBarFocusNode,
              controller: _searchBarController,
              dropDownMenuItemList: _dropDownMenuItemList,
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0)
            ),
            Expanded(
              child: _loaded ? createGroupListView(
                groups: _groups,
                onTab: (index) {
                  if(_searchBarFocusNode.hasFocus) {
                    SearchBarLostedFocus();
                  }
                  Navigator.pushNamed(
                    widget.context, "/group_details",
                    arguments: { 
                      "index": index,
                      "user": widget.user,
                      "subs": widget.subs,
                      "group": _groups[index]
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
              ) : loading()
            )
          ]
        )
      )
    );
  }
}