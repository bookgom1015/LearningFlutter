import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/http_helpers.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;
import 'package:flutter_application_learning/entries/user.dart';

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  Map _receivedData = {};

  late KeyValueStorage _storage;
  late User _user;

  bool _clicked = false;

  late double _deviceWidth;
  late double _viewHeight;

  late double _boxWidth; 
  late double _boxHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _deviceWidth = MediaQuery.of(context).size.width;
    _viewHeight = MediaQuery.of(context).size.height 
                    - MediaQuery.of(context).padding.top // Status bar height
                    - AppBar().preferredSize.height;
    _boxWidth = _deviceWidth * 0.8;
    _boxHeight = _viewHeight * 0.8;

    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;
    _storage = _receivedData["stroage"];
    _user = User.fromJson(jsonDecode(_storage.get("user")));
  }

  void onButtonClicked() async {
    int statusCode = await withdraw(
      _user.token
    );
    _clicked = false;
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context, 
      "/", 
      (route) { 
        return route.isCurrent;
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(
          height: globals.AppBarHeight, 
          title: "회원 탈퇴",
          backgroundColor: globals.AppBarColor
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: globals.BackgroundColor
          ),
          child: Center(
            child: Container(
              width: _boxWidth,
              height: _boxHeight,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: globals.DefaultRadius,
                gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topLeft,
                  stops: [
                    0.1,
                    0.4
                  ],
                  colors: [
                    globals.WithdrawalBackgroundColors1,
                    globals.WithdrawalBackgroundColors2,
                  ]
                ),
                boxShadow: const [
                  BoxShadow(
                    color: globals.ShadowColor,
                    blurRadius: 12,
                    spreadRadius: 1,
                    offset: Offset(6, 8)
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(height: 60),
                        Text(
                          "1. 가나다라마바사아자차카타파하",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          "2. 하파타카차자아사바마라다나가",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                        SizedBox(height: 20),
                        Text(
                          "나는 어쩌고 저쩌고를 다 이해했으며 회원 탈퇴를 진행하겠습니다.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        )
                      ]
                    )
                  ),
                  SizedBox(
                    height: 45,
                    child: GestureDetector(
                      onTap: () {
                        if (!_clicked) {
                          _clicked = true;
                          onButtonClicked();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: globals.WithdrawalButtonBackgroundColor,
                          borderRadius: globals.DefaultRadius
                        ),
                        child: const Center(
                          child: Text(
                            "회원 탈퇴",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            )
                          )
                        )
                      )
                    )
                  )
                ]
              )
            )
          )
        ),
      )
    );
  }
}