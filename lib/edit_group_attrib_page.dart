import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;
import 'package:flutter_application_learning/components/http_helpers.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/components/slide_button.dart';
import 'package:flutter_application_learning/components/text_divider.dart';
import 'package:flutter_application_learning/entries/app_bar_btn.dart';
import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/entries/user.dart';

class EditGroupAttribPage extends StatefulWidget {
  const EditGroupAttribPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditGroupAttribPageState();
}

class _EditGroupAttribPageState extends State<EditGroupAttribPage> {
  Map _receivedData = {};

  late KeyValueStorage _storage;
  late Group _group;

  bool _isClosed = false;
  bool _clicked = false;

  late String _desc;

  late double _deviceWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _deviceWidth = MediaQuery.of(context).size.width;

    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;
    _storage = _receivedData["storage"];
    _group = Group.fromJson(jsonDecode(_storage.get("group")));

    _desc = _group.desc;
  }

  void onButtonClicked() async {
    int statusCode = await editGroupAttrib(
      _group.id, 
      _desc, 
      _isClosed
    );
    _clicked = false;
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
      return;
    }
    
    _group.desc = _desc;
    _storage.set("group", _group.toString());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(
          height: globals.AppBarHeight, 
          title: "팀 설정 변경",
          backgroundColor: globals.AppBarColor,
          btnSize: 32,
          btnList: [
            AppBarBtn(
              icon: Icons.edit,
              color: Colors.black,
              func: () {
                if (!_clicked) {
                  _clicked = true;
                  onButtonClicked();
                }
              }
            )
          ]
        ),
        body: Container(
          width: _deviceWidth,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: globals.BackgroundColor
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SlideButton(
                width: 120, 
                height: 40, 
                onChanged: (isCompleted) {
                  _isClosed = isCompleted;
                }, 
                firstWord: "Opend", 
                secondWord: "Closed",
                firstIcon: Icons.open_in_new_rounded,
                secondIcon: Icons.block,
              ),
              const SizedBox(height: 10),
              createTextDivider(
                "소개글",
                height: 20,
                fontColor: globals.UnfocusedForeground,
                underlineColor: globals.UnderlineColor
              ),
              Expanded(
                child: TextFormField(
                  initialValue: _group.desc,
                  maxLines: null,
                  style: const TextStyle(
                    color: globals.FocusedForeground
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: "내용을 입력하세요",
                    hintStyle: TextStyle(
                      color: globals.UnfocusedForeground
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none
                  ),
                  onChanged: (text) {
                    _desc = text;
                  }
                )
              )
            ]
          )
        ),
      ),
    );
  }  
}