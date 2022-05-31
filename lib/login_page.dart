import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/alert_dialog.dart';
import 'package:flutter_application_learning/components/http_helpers.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/entries/subscriptions.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _visible = false;
  bool _pwdFocused = false;
  final FocusNode _pwdFocusNode = FocusNode();
  
  String _userPwd = "";
  String _userId = "";

  bool _idIsValid = true;
  bool _pwdIsValid= true;

  final _secureStorage = const FlutterSecureStorage();

  bool _isChecked = false;

  final KeyValueStorage _storage = KeyValueStorage();

  late double _deviceWidth;
  late double _deviceHeight;
  late double _invHalfWidth;
  late double _invHalfHeight;

  @override
  void initState() {
    super.initState();

    _storage.init();
    
    _pwdFocusNode.addListener(() {
      setState(() {
        _pwdFocused = _pwdFocusNode.hasFocus;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    _invHalfWidth = _deviceWidth * -0.5;
    _invHalfHeight = _deviceHeight * -0.5;
  }

  @override
  void dispose() {
    super.dispose();
    
    _pwdFocusNode.dispose();
  }

  void onLoginButtonClicked(BuildContext context) async {
    bool isValid = true;
    setState(() {
      if (_userId == "") {
      isValid = false;
      _idIsValid = false;
      }
      else {
        _idIsValid = true;
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
    uri.write("/api/user/login");
    
    var response = await http.post(
      Uri.parse(uri.toString()),
      headers: { "Content-Type": "application/json" },
      body: jsonEncode({
        "userName": _userId,
        "userPassword": _userPwd
      })
    );

    if (response.statusCode != 200) {
      // Show error message
      showAlertDialog(
        context: context,
        text: "아이디 또는 패스워드가 올바르지 않습니다.",
        fontColor: globals.FocusedForeground,
        backgroundColor: globals.DialogBackgroundColor,
        borderRadius: globals.DefaultRadius
      );
      return;
    }

    var json = jsonDecode(response.body);
    
    if (_isChecked) {
      _secureStorage.write(key: "user_id", value: _userId);
      _secureStorage.write(key: "user_pwd", value: _userPwd);
    }

    User user = User.fromJson(json);
    late Subscriptions subs;

    int statusCode = await getSubscriptions(
      user.id, 
      (data) {
        subs = data;
      }
    );
    if (statusCode != 200) {
      print("error occured");
      return;
    }    

    _storage.set("user", user.toString());
    _storage.set("subs", subs.toString());

    Navigator.pushReplacementNamed(context, '/main', arguments: {"storage": _storage, "user": user, "subs": subs});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            backgroundWidget(),
            SingleChildScrollView(
              child: Container(
                width: _deviceWidth,
                height: _deviceHeight,
                alignment: Alignment.center,
                child: Center(
                  child: ClipRect(
                    child: Container(
                      height: 480,                
                      margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      decoration: BoxDecoration(
                        color: globals.LoginBackgroundColor,
                        borderRadius: globals.DefaultRadius,                    
                      ),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 50),
                            idWidget(),
                            const SizedBox(height: 20),
                            passwordWidget(),
                            const SizedBox(height: 30),
                            rememberMeWidget(),
                            const SizedBox(height: 20),                      
                            loginWidget(),
                            const SizedBox(height: 50),
                            signUpWidget()
                          ],
                        ),
                      )
                    )
                  )
                )
              )
            )
          ]
        )
      )      
    );
  }

  Widget idWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
              borderSide: BorderSide(
                color: _idIsValid ? globals.LoginUnderlineUnfocusedColor : globals.LoginUnderlineUnfocusedDangerColor
              )
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: _idIsValid ? globals.LoginUnderlineFocusedColor : globals.LoginUnderlineFocusedDangerColor
              )
            ),
            hintText: "아이디를 입력해주세요",
            hintStyle: const TextStyle(
              color: globals.UnfocusedForeground
            )
          ),
          onChanged: (String text) {
            _userId = text;
          },
        ),
      ],
    );
  }
  
  Widget passwordWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
          focusNode: _pwdFocusNode,
          obscureText: !_visible,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _pwdIsValid ? globals.UnfocusedForeground : globals.UnfocusedDangerForeground)
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _pwdIsValid ? globals.FocusedForeground : globals.FocusedDangerForeground)
            ),
            hintText: "패스워드를 입력해주세요",
            hintStyle: const TextStyle(
              color: globals.UnfocusedForeground
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _visible = !_visible;
                });
              },
              icon: Icon(_visible ? Icons.visibility : Icons.visibility_off),
              color: _pwdFocused ? globals.FocusedForeground : globals.UnfocusedForeground,
            ),
          ),
          onChanged: (String text) {
            setState(() {
              _userPwd = text;
            });
          },
        ),
      ],
    );
  }

  Widget rememberMeWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "로그인 정보 저장",
            style: TextStyle(
              color: globals.FocusedForeground
            ),
          ),
          Checkbox(
            value: _isChecked,
            onChanged: (bool? newValue) {
              setState(() {
                _isChecked = !_isChecked;
              });
            }
          )
        ],
      )
    );
  }

  Widget loginWidget() {
    return GestureDetector(
      onTap: () {
        onLoginButtonClicked(context);
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: globals.LoginButtonBackgroundColor,
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              color: globals.ShadowColor,
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(4, 4)
            ),
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.login,
              color: globals.FocusedForeground
            ),
            Text(
              "로그인",
              style: TextStyle(
                color: globals.FocusedForeground
              ),
            )
          ],
        )
      )
    );
  }

  Widget signUpWidget() {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: globals.FocusedForeground,
                width: 1
              )
            )
          ),
          child: const Text(
            "아직 계정이 없으신가요?",
            style: TextStyle(
              color: globals.FocusedForeground
            ),
          ),          
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signup');
          }, 
          child: const Text(
            "회원가입"
          )
        )
      ],
    );
  }

  Widget backgroundWidget() {
    return Stack(
      children: [
        Positioned(
          top: _invHalfHeight,
          right: _invHalfWidth,
          child: Container(
            width: _deviceWidth * 1.5,
            height: _deviceHeight * 1.5,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 227, 225, 253)
            ),
          )
        ),
        Positioned(
          top: _invHalfHeight,
          left: _invHalfWidth,
          child: Container(
            width: _deviceWidth * 1.2,
            height: _deviceHeight * 1.2,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 235, 252, 235)
            ),
          )
        ),
        Positioned(
          bottom: _invHalfHeight,
          left: _invHalfWidth,
          child: Container(
            width: _deviceWidth * 1.5,
            height: _deviceHeight * 1.5,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 221, 246, 252)
            ),
          )
        ),
        Positioned(
          bottom: _invHalfHeight,
          right: _invHalfWidth,
          child: Container(
            width: _deviceWidth * 1.2,
            height: _deviceHeight * 1.2,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 250, 239, 249)
            ),
          )
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 64, sigmaY: 64),
          child: SizedBox(
            width: _deviceWidth,
            height: _deviceHeight
          ),
        )      
      ]
    );
  }
}