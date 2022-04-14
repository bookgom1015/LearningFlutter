import 'package:flutter/material.dart';
import 'package:flutter_application_learning/entries/account.dart';
import 'package:flutter_application_learning/entries/menu.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final List<Menu> _menuList = [
    Menu(Icons.info_outline, "Menu 1"),
    Menu(Icons.info_outline, "Menu 2"),
    Menu(Icons.info_outline, "Menu 3"),
    Menu(Icons.info_outline, "Menu 4"),
    Menu(Icons.info_outline, "Menu 5"),
    Menu(Icons.info_outline, "Menu 6"),
    Menu(Icons.info_outline, "Menu 7"),
    Menu(Icons.info_outline, "Menu 8"),
    Menu(Icons.info_outline, "Menu 9"),
    Menu(Icons.info_outline, "Menu 10"),    
    Menu(Icons.info_outline, "Menu 11"),    
    Menu(Icons.info_outline, "Menu 12"),    
    Menu(Icons.info_outline, "Menu 13"),    
    Menu(Icons.info_outline, "Menu 14"),    
  ];

  final Account _account = Account("assets/images/creeper_128x128.jpg", "KBG");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.BackgroundColor,
      body: Container(               
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0), 
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: _menuList.length,
          itemBuilder: (context, index) {
            return Container(
              height: 50,
              margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              decoration: BoxDecoration(
                color: globals.IdentityColor,
                borderRadius: globals.DefaultRadius
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Icon(
                    _menuList[index].icon,
                    color: globals.FocusedForeground,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _menuList[index].title,
                    style: const TextStyle(
                      color: globals.FocusedForeground
                    ),
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }  
}