import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/loading.dart';
import 'package:flutter_application_learning/components/search_bar.dart';
import 'package:flutter_application_learning/components/tag_list.dart';
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
  List<Group> _groupList = [];

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

    List<Group> groupList  = [];

    Map<String, dynamic> json = jsonDecode(response.body);
    List<dynamic> teamJsonArray = json["teams"];
    for (var teamJson in teamJsonArray) {
      groupList.add(Group.fromJson(teamJson));
    }

    setState(() {
      _groupList = groupList;
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
    const double margin = 5;
    const double padding = 10;
    const double imageBoxSize = 40;
    const double containerHeight = 70;

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double actualWidth = deviceWidth - padding - padding;
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
              child: _loaded ? groupList(
                width: postDescWidth,
                height: containerHeight, 
                margin: const EdgeInsets.all(margin), 
                padding: const EdgeInsets.all(padding)) : loading()
            )
          ]
        )
      )
    );
  }

  Widget groupList({
      required double width,
      required double height,
      required EdgeInsets margin,
      required EdgeInsets padding}) {
    const EdgeInsets descPadding = EdgeInsets.fromLTRB(15, 0, 15, 0);
    const double tagsHeight = 20;
    const double imageSize = 40;

    final double actualWidth = width - margin.left - margin.right - padding.left - padding.right - 
                                descPadding.left - descPadding.right - imageSize;
    final double titleHeight = height - tagsHeight - padding.top - padding.bottom;

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: globals.ListViewBottomPadding),
      itemCount: _groupList.length,
      itemBuilder: (_, index) {
        return GestureDetector(
          onTap: () {
            if(_searchBarFocusNode.hasFocus) {
              SearchBarLostedFocus();
            }
            Navigator.pushNamed(
              widget.context, "/group_details",
              arguments: { 
                "index": index,
                "user": widget.user,
                "subs": widget.subs,
                "group": _groupList[index]
              }
            );
          },
          child: Container(
            height: height,
            margin: margin,
            padding: padding,
            decoration: BoxDecoration(
              color: globals.IdentityColor,
              borderRadius: globals.DefaultRadius
            ),
            child: Row(
              children: [
                // Profile
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: "group_" + index.toString(), 
                      child: Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                           image: AssetImage(_groupList[index].filePath)
                          )
                        )
                      )
                    )
                  ],
                ),
                // Descriptions
                Padding(
                  padding: descPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: actualWidth,
                        height: titleHeight,
                        child: Row(                        
                          children: [
                            Text(
                              _groupList[index].name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: globals.FocusedForeground
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _groupList[index].hostId.toString(),
                              style: const TextStyle(
                                fontSize: 11,
                                color: globals.FocusedForeground
                              ),
                            ),
                          ],
                        )
                      ),
                      TagList(width: actualWidth, height: tagsHeight, tagList: _groupList[index].tags)          
                    ],
                  )
                ),
              ],
            )
          ),
        );
      },
    );
  }
}