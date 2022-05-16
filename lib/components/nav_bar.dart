import 'package:flutter/material.dart';
import 'package:flutter_application_learning/entries/app_bar_btn.dart';
import 'package:flutter_application_learning/globals.dart' as globals;

AppBar createAppBar({required String navTitle, double? btnSize, List<AppBarBtn>? btnList}) {
  return AppBar(
    toolbarHeight: globals.AppBarHeight,
    title: Row(
      children: [
        SizedBox(
          width: 200,
          child: Stack(
            children: <Widget>[              
              Text(
                navTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: globals.FocusedForeground, // <-- Inner color
                ),
              ),
            ],
          )
        ),
        Expanded (
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: (btnSize ?? 0) * (btnList == null ? 0 : 1),
                height: globals.AppBarHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: btnList == null ? 0 : 1,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        btnList?[index].btnFunc();
                      },
                      child: Icon(
                        btnList?[index].btnIcon,
                        size: btnSize,
                      )
                    );
                  }
                )
              )
            ],
          )
        )
      ]
    ),
    backgroundColor: globals.IdentityColor,
  );
}