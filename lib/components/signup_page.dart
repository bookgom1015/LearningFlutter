import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/globals.dart' as globals;
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(navTitle: "회원가입"),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "아이디:",
          style: TextStyle(
            color: globals.FocusedForeground
          ),
        ),
        TextFormField(
          style: const TextStyle(
            color: globals.FocusedForeground
          ),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _idIsValid ? globals.UnfocusedForeground : globals.UnfocusedDangerForeground)
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _idIsValid ? globals.FocusedForeground : globals.FocusedDangerForeground)
            ),
            hintText: "사용하실 아이디를 입력해주세요",
            hintStyle: const TextStyle(
              color: globals.UnfocusedForeground
            )
          ),
          onChanged: (String text) {
            _userId = text;
          }
        )
      ],
    );
  }

  Widget nicknameWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "닉네임:",
          style: TextStyle(
            color: globals.FocusedForeground
          ),
        ),
        TextFormField(
          style: const TextStyle(
            color: globals.FocusedForeground
          ),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _nicknameIsValid ? globals.UnfocusedForeground : globals.UnfocusedDangerForeground)
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _nicknameIsValid ? globals.FocusedForeground : globals.FocusedDangerForeground)
            ),
            hintText: "사용하실 닉네임을 입력해주세요",
            hintStyle: const TextStyle(
              color: globals.UnfocusedForeground
            )
          ),
          onChanged: (String text) {
            _userNickname = text;
          }
        )
      ],
    );
  }

  Widget pwdWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "패스워드:",
          style: TextStyle(
            color: globals.FocusedForeground
          ),
        ),
        TextFormField(
          style: const TextStyle(
            color: globals.FocusedForeground
          ),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _pwdIsValid ? globals.UnfocusedForeground : globals.UnfocusedDangerForeground)
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _pwdIsValid ? globals.FocusedForeground : globals.FocusedDangerForeground)
            ),
            hintText: "사용하실 패스워드를 입력해주세요",
            hintStyle: const TextStyle(
              color: globals.UnfocusedForeground
            )
          ),
          onChanged: (String text) {
            _userPwd = text;
          }
        )
      ],
    );
  }
  
  Widget signupWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            signup();
          },
          icon: const Icon(Icons.add_outlined),
          label: const Text("계정 생성")
        )
      ],
    );
  }

  void signup() async {
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
            "에러",
            style: TextStyle(
              color: globals.FocusedForeground
            )
          ),
          content: const Text(
            "몬가... 몬가 잘못됨...",
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
}