import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/mene_list.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;
import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/entries/join_request.dart';
import 'package:flutter_application_learning/entries/menu.dart';
import 'package:flutter_application_learning/entries/user.dart';

class GroupManagementPage extends StatefulWidget {
  const GroupManagementPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupManagementPageStaet();
}

class _GroupManagementPageStaet extends State<GroupManagementPage> {
  Map _receivedData = {};

  late KeyValueStorage _storage;
  late List<JoinRequest> _requests;
  late List<Menu> _menus;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;
    _storage = _receivedData["storage"];
    _requests = _receivedData["requests"];

    _menus = [
      Menu(
        icon: Icons.list,
        title: "참가 요청 목록",
        routeName: "/permision",
        arguments: {
          "storage": _storage,
          "requests": _requests
        }
      ),
      Menu(
        icon: Icons.edit, 
        title: "팀 설정 변경", 
        routeName: "/edit_group_attrib",
        arguments: {
          "storage": _storage
        }
      ),
    ];
  }

  @override  
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(
          height: globals.AppBarHeight,
          title: "관리자 페이지",
          backgroundColor: globals.BackgroundColor
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: globals.BackgroundColor
          ),
          child: ListView.builder(
            itemCount: _menus.length,
            itemBuilder: (_, index) {
              return createMenuListView(
                context: context, 
                menus: _menus,
                index: index,
                bottomRightColor: globals.ListViewItemBackgroundColors1,
                topLeftColor: globals.ListViewItemBackgroundColors2,
                shadowColor: globals.ShadowColor,
                borderRadius: globals.DefaultRadius
              );
            }
          ),
        ),
      )
    );
  }
}