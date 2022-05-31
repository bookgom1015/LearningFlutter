import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/http_helpers.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;
import 'package:flutter_application_learning/components/underline_input.dart';
import 'package:flutter_application_learning/entries/app_bar_btn.dart';
import 'package:flutter_application_learning/entries/user.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditAccountPageState();  
}

class _EditAccountPageState extends State<EditAccountPage> {
  Map _receivedData = {};

  late KeyValueStorage _storage;
  late User _user;

  final FocusNode _nicknameFoucusNode = FocusNode();
  String _nickname = "";
  bool _nicknameFocused = false;
  bool _nicknameIsValid = true;

  final FocusNode _passwordFoucusNode = FocusNode();
  String _password = "";
  bool _passwordFocused = false;
  bool _passwordIsValid = true;

  bool _clicked = false;

  @override
  void initState() {
    _nicknameFoucusNode.addListener(() { 
      setState(() {
        _nicknameFocused = _nicknameFoucusNode.hasFocus;
      });
    });

    _passwordFoucusNode.addListener(() {
      setState(() {
        _passwordFocused = _passwordFoucusNode.hasFocus;
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

    _nicknameFoucusNode.dispose();
    _passwordFoucusNode.dispose();
  }

  void onEditButtonClicked() async {
    bool isValid = true;

    setState(() {
      if (_nickname == "") {
        _nicknameIsValid = false;
        isValid = false;
      }
      else {
        _nicknameIsValid = true;
      }

      if (_password == "") {
        _passwordIsValid = false;
        isValid = false;
      }
      else {
        _passwordIsValid = true;
      }
    });
    
    if (!isValid) {
      _clicked = false;
      return;
    }

    int statusCode = await editAccount(
      _user.token, 
      _nickname, 
      _password
    );
    if (statusCode != 200) {
      _clicked = false;
      print("error occured: " + statusCode.toString());
      return;
    }

    _user.userNickname = _nickname;
    _storage.set("user", _user.toString());

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(
          height: globals.AppBarHeight,
          backgroundColor: globals.AppBarColor,
          title: "정보 수정",
          btnSize: 32,
          btnList: [
            AppBarBtn(
              icon: Icons.edit,
              color: Colors.black,
              func: () {
                if (!_clicked) {
                  _clicked = true;   
                  onEditButtonClicked();
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
              nicknameWidget(),
              const SizedBox(height: 10),
              passwordWidget()
            ]
          )
        )
      )
    );
  }

  Widget nicknameWidget() {
    Color underlineColor;
    if (_nicknameFocused) {
      underlineColor = _nicknameIsValid ? globals.EditAccountUnderlineFocusedColor : globals.EditAccountUnderlineFocusedDangerColor;
    }
    else {
      underlineColor = _nicknameIsValid ? globals.EditAccountUnderlineUnfocusedColor : globals.EditAccountUnderlineUnfocusedDangerColor;
    }

    return underlineInputfiled(
      focusNode: _nicknameFoucusNode,
      fontColor: globals.FocusedForeground, 
      hintFontColor: globals.UnfocusedForeground, 
      onChanged: (String text) {
        _nickname = text;
      }, 
      underlineColor: underlineColor,
      text: "닉네임",
      hintText: "8~16글자 (영문자, 숫자)",
      width: 60
    );
  }

  Widget passwordWidget() {
    Color underlineColor;
    if (_passwordFocused) {
      underlineColor = _passwordIsValid ? globals.EditAccountUnderlineFocusedColor : globals.EditAccountUnderlineFocusedDangerColor;
    }
    else {
      underlineColor = _passwordIsValid ? globals.EditAccountUnderlineUnfocusedColor : globals.EditAccountUnderlineUnfocusedDangerColor;
    }

    return underlineInputfiled(
      focusNode: _passwordFoucusNode,
      fontColor: globals.FocusedForeground, 
      hintFontColor: globals.UnfocusedForeground, 
      onChanged: (String text) {
        _password = text;
      }, 
      underlineColor: underlineColor,
      text: "패스워드",
      hintText: "8~16글자 (영문자, 숫자)",
      width: 60
    );
  }
}