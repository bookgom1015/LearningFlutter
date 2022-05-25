import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/http_helpers.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/entries/app_bar_btn.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Map _receivedData = {};

  late KeyValueStorage _storage;
  late User _user;

  late String _desc;

  bool _sending = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;

    _storage = _receivedData["storage"];

    _user = User.fromJson(jsonDecode(_storage.get("user")));
    _desc = _user.userProfile.desc;
    super.didChangeDependencies();
  }

  void onEditButtonClicked() async {
    int statusCode = await editProfile(_user.token, _desc);
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
      _sending = false;
      return;
    }

    _user.userProfile.desc = _desc;
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
          title: "프로필 수정",
          btnSize: 32,
          btnList: [
            AppBarBtn(
              icon: Icons.edit,
              color: Colors.black,
              func: () {
                if (!_sending) {
                  _sending = true;
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: SizedBox(
                  width: 128,
                  height: 128,
                  child: Stack(
                    children: [
                      Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(_user.userProfile.filePath)
                          )
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(103, 0, 0, 0)
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 28,
                            ),
                          )
                        )
                      )
                    ]
                  )
                ),
              ),
              SizedBox(
                height: 40,
                child: Row(
                  children: const [
                    Text(
                      "소개글",
                      style: TextStyle(
                        color: globals.UnfocusedForeground
                      )        
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 1,
                        child: Divider(
                          color: globals.UnderlineColor,
                          thickness: 1,
                        )
                      )
                    )
                  ]
                )
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    initialValue: _desc,
                    maxLines: null,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _desc = value;
                      });
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