import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/globals.dart' as globals;
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

  final _storage = const FlutterSecureStorage();

  bool _isChecked = false;

  @override
  void initState() {
    _pwdFocusNode.addListener(() {
      setState(() {
        _pwdFocused = _pwdFocusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pwdFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(navTitle: "로그인"),
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            //image: DecorationImage(
            //  image: AssetImage('assets/images/8k_wallpaper.jpg'),
            //  fit: BoxFit.fill
            //)
          ),
          child: ClipRect(
            child: /*BackdropFilter*/(
              //filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              /*child:*/ Container(
                height: 480,                
                margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                decoration: BoxDecoration(
                  color: globals.LoginBackground,
                  borderRadius: globals.DefaultRadius,
                ),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IdWidget(),
                      const SizedBox(height: 20),
                      PasswordWidget(),
                      const SizedBox(height: 20),
                      RememberMeWidget(),
                      const SizedBox(height: 20),                      
                      LoginWidget(context),
                      const SizedBox(height: 15),
                      SignUpWidget(context)
                    ],
                  ),
                )
              )
            ),
          )
        )
      )      
    );
  }

  // ignore: non_constant_identifier_names
  Widget IdWidget() {
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
              borderSide: BorderSide(color: _idIsValid ? globals.UnfocusedForeground : globals.UnfocusedDangerForeground)
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _idIsValid ? globals.FocusedForeground : globals.FocusedDangerForeground)
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
  
  // ignore: non_constant_identifier_names
  Widget PasswordWidget() {
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

  Widget RememberMeWidget() {
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

  void login(BuildContext context) async {
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
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "알림",
            style: TextStyle(
              color: globals.FocusedForeground
            )
          ),
          content: const Text(
            "아이디 또는 패스워드가 올바르지 않습니다",
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

    var json = jsonDecode(response.body);
    
    if (_isChecked) {
      _storage.write(key: "user_id", value: _userId);
      _storage.write(key: "user_pwd", value: _userPwd);
    }

    User user = User(json["token"], json["id"], json["userName"], json["userNickname"]);
    Navigator.pushReplacementNamed(context, '/main', arguments: {"user": user});
  }

  // ignore: non_constant_identifier_names
  Widget LoginWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        login(context);
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: globals.IdentityColor,
          borderRadius: BorderRadius.circular(4)
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

  // ignore: non_constant_identifier_names
  Widget SignUpWidget(BuildContext context) {
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
}