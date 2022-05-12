import 'dart:convert';
import 'package:flutter/material.dart';
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
  late List<Group> _groups;

  final List<String> _dropDownMenuItemList = [
    "One", "Two", "Three", "Four"
  ];

  final FocusNode _searchBarFocusNode = FocusNode();
  final TextEditingController _searchBarController = TextEditingController();

  @override
  void initState() {
    _groups = [];

    StringBuffer uri = StringBuffer();
    uri.write(globals.SpringUriPath);
    uri.write("/api/team");

    var response = http.get(Uri.parse(uri.toString()));

    response.then((value) {
      if (value.statusCode != 200) {
        print("error occured");
      }
      else {
        Map<String, dynamic> json = jsonDecode(value.body);
        List<dynamic> temaList = json["teams"];
        for (var team in temaList) {
          _groups.add(Group.fromJson(team));
        }
      }
    });

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
    const double outerPadding = 15;
    const double innerPadding = 15;
    const double imageBoxSize = 40;
    const double containerHeight = 70;
    double deviceWidth = MediaQuery.of(context).size.width;
    double actualWidth = deviceWidth - outerPadding - outerPadding - innerPadding - innerPadding;
    double postDescWidth = actualWidth - imageBoxSize;

    return Scaffold(
      backgroundColor: globals.BackgroundColor,
      body: Container(
        padding: const EdgeInsets.fromLTRB(outerPadding, 10, outerPadding, 0),
        child: Column(
          children: [
            SearchBar(
              focusNode: _searchBarFocusNode,
              controller: _searchBarController,
              dropDownMenuItemList: _dropDownMenuItemList,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: globals.ListViewBottomPadding),
                itemCount: _groups.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      if(_searchBarFocusNode.hasFocus) {
                        SearchBarLostedFocus();
                      }
                      //Navigator.pushNamed(
                      //  widget.context, "/group_details", 
                      //  arguments: { 
                      //    "user": widget.user,
                      //    "isPrivate": widget.isPrivate,
                      //    "index": index,                          
                      //    "title": _postList[index].title,
                      //    "host": _postList[index].host,
                      //    "image": _postList[index].image,
                      //    "desc": _postList[index].desc
                      //  }
                      //);
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
                    child: Container(
                      height: containerHeight,
                      padding: const EdgeInsets.fromLTRB(innerPadding, 0, innerPadding, 0),
                      margin: const EdgeInsets.fromLTRB(0, margin, 0, margin),
                      decoration: BoxDecoration(
                        color: globals.IdentityColor,
                        borderRadius: globals.DefaultRadius
                      ),
                      child: Row(
                        children: [
                          ImageBox(40, index),
                          PostDesc(postDescWidth, imageBoxSize, index),
                        ],
                      )
                    ),
                  );
                },
              )
            )
          ]
        )
      )
    );
  }

  // ignore: non_constant_identifier_names
  Widget ImageBox(double size, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: "group_" + index.toString(), 
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
               image: AssetImage(_groups[index].filePath)
              )
            )
          )
        )
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget PostDesc(double width, double height, int index) {
    const double padding = 15;
    double actualWidth = width - padding - padding;
    double tagsHeight = 20;
    double titleHeight = height - tagsHeight;

    return Padding(
      padding: const EdgeInsets.fromLTRB(padding, 0, padding, 0),
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
                  _groups[index].name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: globals.FocusedForeground
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _groups[index].hostId.toString(),
                  style: const TextStyle(
                    fontSize: 11,
                    color: globals.FocusedForeground
                  ),
                ),
              ],
            )
          ),
          TagList(width: actualWidth, height: tagsHeight, tagList: _groups[index].tags)          
        ],
      )
    );
  }
}