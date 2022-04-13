import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _visible = false;
  bool _pwdFocused = false;
  final FocusNode _pwdFocusNode = FocusNode();

  @override
  void initState() {
    _pwdFocusNode.addListener(onPwdFocusChanged);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pwdFocusNode.dispose();
  }

  void onPwdFocusChanged() {
    setState(() {
      _pwdFocused = _pwdFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar("Login"),
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/8k_wallpaper.jpg'),
              fit: BoxFit.fill
            )
          ),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                height: 400,                
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
                      IdColumn(),
                      const SizedBox(height: 30),
                      PasswordColumn(),
                      const SizedBox(height: 60),
                      SubmitRow()
                    ],
                  ),
                )
              ),
            ),
          )
        )
      )      
    );
  }

  // ignore: non_constant_identifier_names
  Widget IdColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "ID:",
          style: TextStyle(
            color: globals.FocusedForeground
          ),
        ),
        TextFormField(
          style: const TextStyle(
            color: globals.FocusedForeground
          ),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: globals.UnfocusedForeground)
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: globals.FocusedForeground)
            ),
            hintText: "Enter your id",
            hintStyle: TextStyle(
              color: globals.UnfocusedForeground
            )
          ),
        ),
      ],
    );
  }
  
  // ignore: non_constant_identifier_names
  Widget PasswordColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "PASSWORD:",
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
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: globals.UnfocusedForeground)
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: globals.FocusedForeground)
            ),
            hintText: "Enter your password",
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
        ),
      ],
    );
  }  

  // ignore: non_constant_identifier_names
  Widget SubmitRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/main');
          },
          label: const Text("Login"),
          icon: const Icon(
            Icons.login, 
            size: 24
          ),
          style: ElevatedButton.styleFrom(
            primary: globals.IdentityColor
          ),
        )                  
      ],
    );
  }
}