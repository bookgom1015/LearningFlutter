import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/components/underline_input.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _userId = "";
  String _userNickname = "";
  String _userPwd = "";

  bool _idIsValid = true;
  bool _nicknameIsValid = true;
  bool _pwdIsValid = true;

  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _nicknameFocusNode = FocusNode();
  final FocusNode _pwdFocusNode = FocusNode();

  bool _idFocused = false;
  bool _nicknameFocused = false;
  bool _pwdFocused = false;

  @override
  void initState() {
    super.initState();

    _idFocusNode.addListener(() {
      setState(() {
        _idFocused = _idFocusNode.hasFocus;
      });
    });

    _nicknameFocusNode.addListener(() {
      setState(() {
        _nicknameFocused = _nicknameFocusNode.hasFocus;
      });
    });

    _pwdFocusNode.addListener(() {
      setState(() {
        _pwdFocused = _pwdFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _idFocusNode.dispose();
    _nicknameFocusNode.dispose();
    _pwdFocusNode.dispose();
  }

  void onSignupButtonClicked() async {
    bool isValid = true;
    setState(() {
      if (_userId == "") {
      isValid = false;
      _idIsValid = false;
      }
      else {
        _idIsValid = true;
      }

      if (_userNickname == "") {
        isValid = false;
        _nicknameIsValid = false;
      }
      else {
        _nicknameIsValid = true;
      }

      if (_userPwd == "") {
        isValid = false;
        _pwdIsValid = false;
      }
      else {
        _pwdIsValid = true;
      }
    });
    if (!isValid) { return; }

    StringBuffer uri = StringBuffer();
    uri.write(globals.SpringUriPath);
    uri.write("/api/user");
    
    var response = await http.post(
      Uri.parse(uri.toString()),
      headers: { "Content-Type": "application/json" },
      body: jsonEncode({
        "userName": _userId,
        "userNickname": _userNickname,
        "userPassword": _userPwd
      })
    );

    if (response.statusCode != 200) {
      // Show error message
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "??????",
            style: TextStyle(
              color: globals.FocusedForeground
            )
          ),
          content: const Text(
            "??????... ?????? ?????????...",
            style: TextStyle(
              color: globals.FocusedForeground
            )
          ),
          backgroundColor: globals.IdentityColor,
          elevation: 24,
          shape: RoundedRectangleBorder(
            borderRadius: globals.DefaultRadius
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      });
      return;
    }    

    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(
          height: globals.AppBarHeight,
          title: "????????????",
          backgroundColor: globals.AppBarColor
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(15, 60, 15, 0),
          decoration: const BoxDecoration(
            color: globals.BackgroundColor
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              idWidget(),
              const SizedBox(height: 30),
              nicknameWidget(),
              const SizedBox(height: 30),
              pwdWidget(),
              const SizedBox(height: 40),
              signupWidget()
            ],
          ),
        ),
      ),      
    );
  }

  Widget idWidget() {
    Color underlineColor;
    if (_idFocused) {
      underlineColor = _idIsValid ? globals.SignupUnderlineFocusedColor : globals.SignupUnderlineFocusedDangerColor;
    }
    else {
      underlineColor = _idIsValid ? globals.SignupUnderlineUnfocusedColor : globals.SignupUnderlineUnfocusedDangerColor;
    }
    
    return underlineInputfiled(
      focusNode: _idFocusNode,
      fontColor: globals.FocusedForeground, 
      hintFontColor: globals.UnfocusedForeground, 
      onChanged: (String text) {
        _userId = text;
      }, 
      underlineColor: underlineColor,
      text: "?????????",
      hintText: "8~16?????? (?????????, ??????)",
      width: 60
    );
  }

  Widget nicknameWidget() {
    Color underlineColor;
    if (_nicknameFocused) {
      underlineColor = _nicknameIsValid ? globals.SignupUnderlineFocusedColor : globals.SignupUnderlineFocusedDangerColor;
    }
    else {
      underlineColor = _nicknameIsValid ? globals.SignupUnderlineUnfocusedColor : globals.SignupUnderlineUnfocusedDangerColor;
    }

    return underlineInputfiled(
      focusNode: _nicknameFocusNode,
      fontColor: globals.FocusedForeground, 
      hintFontColor: globals.UnfocusedForeground, 
      onChanged: (String text) {
        _userNickname = text;
      }, 
      underlineColor: underlineColor,
      text: "?????????",
      hintText: "8~16?????? (?????????, ??????)",
      width: 60
    );
  }

  Widget pwdWidget() {
    Color underlineColor;
    if (_pwdFocused) {
      underlineColor = _pwdIsValid ? globals.SignupUnderlineFocusedColor : globals.SignupUnderlineFocusedDangerColor;
    }
    else {
      underlineColor = _pwdIsValid ? globals.SignupUnderlineUnfocusedColor : globals.SignupUnderlineUnfocusedDangerColor;
    }

    return underlineInputfiled(
      focusNode: _pwdFocusNode,
      fontColor: globals.FocusedForeground, 
      hintFontColor: globals.UnfocusedForeground, 
      onChanged: (String text) {
        _userPwd = text;
      }, 
      underlineColor: underlineColor,
      text: "????????????",
      hintText: "8~16?????? (?????????, ??????)",
      width: 60
    );
  }
  
  Widget signupWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: onSignupButtonClicked,
          child: Container(
            width: 110,
            height: 40,
            decoration: BoxDecoration(
              color: globals.SignupButtonBackgroundColor,
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
              BoxShadow(
                color: globals.ShadowColor,
                blurRadius: 4,
                spreadRadius: 1,
                offset: Offset(4, 4)
              )
            ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.add_outlined),
                Text(
                  "?????? ??????"
                )
              ]
            )
          )
        )
      ],
    );
  }
}