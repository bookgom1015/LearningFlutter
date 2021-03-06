import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/fade_out.dart';
import 'package:flutter_application_learning/components/group_list_view.dart';
import 'package:flutter_application_learning/components/http_helpers.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/loading.dart';
import 'package:flutter_application_learning/components/search_bar.dart';
import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/entries/subscriptions.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;
import 'package:http/http.dart' as http;

class GroupListPage extends StatefulWidget {
  final KeyValueStorage storage;
  final BuildContext context;
  final PageController pageController;

  const GroupListPage({
    Key? key, 
    required this.storage,
    required this.context, 
    required this.pageController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  List<Group> _groups = [];

  final FocusNode _searchBarFocusNode = FocusNode();
  final TextEditingController _searchBarController = TextEditingController();

  bool _loaded = false;
  bool _clicked = false;

  String _requirement = "";
  String _query = "";

  late double _deviceWidth;

  @override
  void initState() {
    super.initState();    
    
    widget.pageController.addListener(() {
      if(_searchBarFocusNode.hasFocus) {
        onSearchBarLostedFocus();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _deviceWidth = MediaQuery.of(context).size.width;

    generateGroups();
  }

  @override
  void dispose() {
    super.dispose();

    _searchBarFocusNode.dispose();
    _searchBarController.dispose();
  }

  void onSearchButtonClicked() async {
    int statusCode = await searchGroups(
      _requirement, 
      _query, 
      (list) {
        setState(() {
          _groups = list;
          _loaded = true;
        });
      }
    );
    _clicked = false;
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
    }
  }

  void onSearchBarLostedFocus() {
    _searchBarFocusNode.unfocus();
    _searchBarController.clear();
  }

  void generateGroups() async {
    int statusCode = await getGroups(
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: globals.BackgroundColor
        ),
        child: Column(
          children: [
            SearchBar(
              focusNode: _searchBarFocusNode,
              controller: _searchBarController,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 1),
              dropDownMenuItems: const { "??????": "name", "??????": "tag" },
              dropdownColor: globals.DropdownColor,
              focusedColor: globals.FocusedForeground,
              unfocusedColor: globals.UnfocusedForeground,
              onTap: () {
                if (!_clicked) {
                  _clicked = true;
                  setState(() {
                    _loaded = false;
                  });
                  onSearchButtonClicked();
                }
              },
              onChanged: (String value) {
                _query = value;
              },
              onDropdownChanged: (String value) {
                _requirement = value;
              }
            ),
            Expanded(
              child: _loaded ? Stack(
                children: [
                  createGroupListView(
                    groups: _groups,
                    onTab: (index) {
                      if(_searchBarFocusNode.hasFocus) {
                        onSearchBarLostedFocus();
                      }

                      Navigator.pushNamed(
                        widget.context, "/group_details",
                        arguments: { 
                          "index": index,
                          "storage": widget.storage,
                          "group": _groups[index]
                        }
                      );
                    },
                    width: _deviceWidth,
                    height: 70, 
                    tagsHeight: 20, 
                    imageSize: 40,
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                    padding: const EdgeInsets.all(10),
                    descPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    viewItemPadding: const EdgeInsets.only(top: 20, bottom: 110)
                  ),
                  cretaeFadeOut(
                    globals.BackgroundColor,
                    const Color.fromARGB(0, 233, 232, 232)
                  )
                ]
              ) : loading()
            )
          ]
        )
      )
    );
  }
}