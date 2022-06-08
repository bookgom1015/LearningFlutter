import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/fade_out.dart';
import 'package:flutter_application_learning/components/http_helpers.dart';
import 'package:flutter_application_learning/components/key_value_storage.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/components/globals.dart' as globals;
import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/entries/join_request.dart';
import 'package:flutter_application_learning/entries/user.dart';

class PermisionPage extends StatefulWidget {
  const PermisionPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PermisionPageState();
}

class _PermisionPageState extends State<PermisionPage> {
  Map _receivedData = {};

  late KeyValueStorage _storage;
  late Group _group;
  late User _user;

  late JoinRequests _requests;
  Map<int, User> _users = {};

  bool _loaded = false;
  bool _permitButtonClicked = false;
  bool _rejectButtonClicked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;
    _storage = _receivedData["storage"];
    _group = _receivedData["group"];
    _requests = JoinRequests.fromJson(jsonDecode(_storage.get("requests")));
    _user = User.fromJson(jsonDecode(_storage.get("user")));

    generateUsers();
  }

  void onPermitButtonClicked(int index) async {
    int statusCode = await permitRequest(
      _user.token, 
      _group.id, 
      _requests.requests[index].requestId
    );
    _permitButtonClicked = false;
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
      return;
    }

    setState(() {
      _requests.requests.removeAt(index);
    });
    _storage.set("request", _requests.toString());
  }

  void onRejectButtonClicked(int index) async {
    int statusCode = await rejectRequest(
      _user.token, 
      _group.id, 
      _requests.requests[index].requestId
    );
    _rejectButtonClicked = false;
    if (statusCode != 200) {
      print("error occured: " + statusCode.toString());
      return;
    }

    setState(() {
      _requests.requests.removeAt(index);
    });
    _storage.set("request", _requests.toString());
  }

  void generateUsers() async {
    for (int index = 0; index < _requests.requests.length; ++index) {
      int userId = _requests.requests[index].userId;
      int statusCode = await getUserInfo(
        userId, 
        (data) {
          if (_users.containsKey(userId)) return;
          _users[userId] = data;
        }        
      );
      if (statusCode != 200) {
        print("error ocurred: " + statusCode.toString());
      }
    }

    setState(() {
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(
          height: globals.AppBarHeight, 
          title: "참가 요청 목록",
          backgroundColor: globals.AppBarColor
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: globals.BackgroundColor
          ),
          child: Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                itemCount: _requests.requests.length,
                itemBuilder: (_, index) {
                  return Container(
                    height: 180,
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        stops: [
                          0.0,
                          0.5
                        ],
                        colors: [
                          globals.ListViewItemBackgroundColors1,
                          globals.ListViewItemBackgroundColors2,
                        ]
                      ),
                      borderRadius: globals.DefaultRadius,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(
                                        _loaded ? 
                                        _users[_requests.requests[index].userId]!.userProfile.filePath : 
                                        "assets/images/champi_1_256x256.jpg"
                                      )
                                    )
                                  )
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _loaded ? _users[_requests.requests[index].userId]!.userNickname : ""
                                )
                              ]
                            )
                          )
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "참가요청",
                              maxLines: 3,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis
                              ),
                            )
                          )
                        ),
                        SizedBox(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (!_permitButtonClicked) {
                                    _permitButtonClicked = true;
                                    onPermitButtonClicked(index);
                                  }
                                },
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 32,
                                )
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (!_rejectButtonClicked) {
                                    _rejectButtonClicked = true;
                                    onRejectButtonClicked(index);
                                  }
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 32,
                                ),
                              )
                            ],                          
                          )
                        )
                      ]
                    )
                  );
                }
              ),
              cretaeFadeOut(
                globals.BackgroundColor,
                const Color.fromARGB(0, 233, 232, 232)
              )
            ]
          )
        )
      ),
    );
  }  
}