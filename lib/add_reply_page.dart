import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/http_helpers.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;
import 'package:flutter_application_learning/components/text_divider.dart';
import 'package:flutter_application_learning/entries/app_bar_btn.dart';
import 'package:flutter_application_learning/entries/post.dart';
import 'package:flutter_application_learning/entries/user.dart';

class AddReplyPage extends StatefulWidget {
  const AddReplyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddReplyPageState();
}

class _AddReplyPageState extends State<AddReplyPage> {
  Map _receivedData = {};

  late KeyValueStorage _storage;
  late User _user;
  late Post _post;

  String _reply = "";

  bool _clicked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;
    _storage = _receivedData["storage"];
    _user = User.fromJson(jsonDecode(_storage.get("user")));
    _post = _receivedData["post"];
  }

  void onButtonClicked() async {
    int statusCode = await addReply(
      _user.token, 
      _post.group.id, 
      _post.id, 
      _reply
    );
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(
          height: globals.AppBarHeight, 
          title: "댓글 작성",
          backgroundColor: globals.AppBarColor,
          btnSize: 32,
          btnList: [
            AppBarBtn(
              icon: Icons.reply,
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
              createTextDivider(
                "댓글",
                height: 20,
                fontColor: globals.UnfocusedForeground,
                underlineColor: globals.UnderlineColor
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    maxLines: null,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                    onChanged: (value) {
                      _reply = value;
                    },
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}