import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/http_helpers.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/components/slide_button.dart';
import 'package:flutter_application_learning/components/underline_input.dart';
import 'package:flutter_application_learning/entries/app_bar_btn.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;
import 'package:flutter_application_learning/entries/user.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddGroupPageState();  
}

class _AddGroupPageState extends State<AddGroupPage> {
  Map _receivedData = {};

  late KeyValueStorage _storage;
  late User _user;

  FocusNode _titleFocusNode = FocusNode();
  String _title = "";
  bool _titleFocused = false;
  bool _titleIsValid = true;

  FocusNode _tagsFocusNode = FocusNode();
  String _tags = "";
  bool _tagsFocused = false;
  bool _tagsIsValid = true;

  bool _isPrivate = false;

  bool _clicked = false;

  @override
  void initState() {
    _titleFocusNode.addListener(() {
      setState(() {
        _titleFocused = _titleFocusNode.hasFocus;
      });
    });

    _tagsFocusNode.addListener(() {
      setState(() {
        _tagsFocused = _tagsFocusNode.hasFocus;
      });
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;
    _storage = _receivedData["stroage"];
    _user = User.fromJson(jsonDecode(_storage.get("user")));

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();

    _titleFocusNode.dispose();
    _tagsFocusNode.dispose();
  }

  void onButtonClicked() async {
    bool isValid = true;

    setState(() {
      if (_title == "") {
        isValid = false;
        _titleIsValid = false;
      }
      else {
        _titleIsValid = true;
      }

      if (_tags == "") {
        isValid = false;
        _tagsIsValid = false;
      }
      else {
        _tagsIsValid = true;
      }
    });
    
    if (!isValid) {
      _clicked = false; 
      return;
    }

    int statusCode = await addGroup(_user.token,  _title, _isPrivate, _tags);

    if (statusCode != 200) {
      _clicked = false;
      print("error occured: " + statusCode.toString());
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(
          height: globals.AppBarHeight,          
          title: "팀 생성",
          backgroundColor: globals.AppBarColor,
          btnSize: 32,
          btnList: [
            AppBarBtn(
              icon: Icons.send,
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
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: globals.BackgroundColor
          ),
          child: Column(
            children: [
              titleWidget(),
              const SizedBox(height: 10),
              tagsWidget(),
              const SizedBox(height: 30),
              SlideButton(
                width: 120, 
                height: 40, 
                onChanged: (isCompleted) {
                  _isPrivate = isCompleted;
                }
              )
            ]
          )
        ),
      )
    );
  }

  Widget titleWidget() {
    Color underlineColor;
    if (_titleFocused) {
      underlineColor = _titleIsValid ? globals.AddGroupUnderlineFocusedColor : globals.AddGroupUnderlineFocusedDangerColor;
    }
    else {
      underlineColor = _titleIsValid ? globals.AddGroupUnderlineUnfocusedColor : globals.AddGroupUnderlineUnfocusedDangerColor;
    }

    return underlineInputfiled(
      focusNode: _titleFocusNode,
      fontColor: globals.FocusedForeground, 
      hintFontColor: globals.UnfocusedForeground, 
      onChanged: (String text) {
        _title = text;
      }, 
      underlineColor: underlineColor,
      text: "타이틀",
      hintText: "8~16글자 (영문자, 숫자)"
    );
  }

  Widget tagsWidget() {
    Color underlineColor;
    if (_tagsFocused) {
      underlineColor = _tagsIsValid ? globals.AddGroupUnderlineFocusedColor : globals.AddGroupUnderlineFocusedDangerColor;
    }
    else {
      underlineColor = _tagsIsValid ? globals.AddGroupUnderlineUnfocusedColor : globals.AddGroupUnderlineUnfocusedDangerColor;
    }

    return underlineInputfiled(
      focusNode: _tagsFocusNode,
      fontColor: globals.FocusedForeground, 
      hintFontColor: globals.UnfocusedForeground, 
      onChanged: (String text) {
        _tags = text;
      }, 
      underlineColor: underlineColor,
      text: "태그",
      hintText: "(ex: tag1, tag2, tag3, ...)"
    );
  }
}