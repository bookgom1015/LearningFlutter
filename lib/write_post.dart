import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_learning/components/nav_bar.dart';
import 'package:flutter_application_learning/entries/app_bar_btn.dart';
import 'package:flutter_application_learning/entries/user.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class WritePostPage extends StatefulWidget {
  const WritePostPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WritePostPageState();
}

class _WritePostPageState extends State<WritePostPage> {
  Map _receivedData = {};

  String _title = "";
  String _tags = "";
  String _desc = "";

  void send() {
    User user = _receivedData["user"];
    print(user.key);
  }

  @override
  Widget build(BuildContext context) {
    _receivedData = ModalRoute.of(context)?.settings.arguments as Map;
    
    return MaterialApp(
      home: Scaffold(        
        appBar: createAppBar(
          navTitle: "공개 글쓰기",
          btnSize: 32,
          btnList: [
            AppBarBtn(
              btnIcon: Icons.send,
              btnFunc: send
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
              Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: globals.IdentityColor,
                  borderRadius: globals.DefaultRadius
                ),
                child: Row(
                  children: [
                    const Text(
                      "제목",
                      style: TextStyle(color: globals.FocusedForeground)
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: const BoxDecoration(
                          color: globals.IdentityColorDarker20
                        ),
                        child: TextFormField(
                          style: const TextStyle(
                            color: globals.FocusedForeground
                          ),
                          maxLines: 1,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(256)
                          ],
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none
                          ),
                          onChanged: (text) {
                             setState(() {
                               _title = text;
                             });
                          },
                        ),
                      )
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: globals.IdentityColor,
                  borderRadius: globals.DefaultRadius
                ),
                child: Row(
                  children: [
                    const Text(
                      "태그",
                      style: TextStyle(color: globals.FocusedForeground)
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: const BoxDecoration(
                          color: globals.IdentityColorDarker20
                        ),
                        child: TextFormField(
                          style: const TextStyle(
                            color: globals.FocusedForeground
                          ),
                          maxLines: 1,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(256)
                          ],
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none
                          ),
                          onChanged: (text) {
                             setState(() {
                               _tags = text;
                             });
                          },
                        ),                        
                      )
                    )
                  ],
                )
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: globals.IdentityColor,
                    borderRadius: globals.DefaultRadius
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: globals.IdentityColorDarker20
                    ),
                    child: TextFormField(
                      maxLines: null,
                      style: const TextStyle(
                        color: globals.FocusedForeground
                      ),
                      decoration: const InputDecoration(
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none
                      ),
                      onChanged: (text) {
                         setState(() {
                           _desc = text;
                         });
                      },
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}