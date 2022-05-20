import 'package:flutter/material.dart';
import 'package:flutter_application_learning/entries/app_bar_btn.dart';

AppBar createAppBar({
    required double height,
    required String title,
    Color backgroundColor = Colors.white,
    Color fontColor = Colors.black,
    double? btnSize,
    List<AppBarBtn>? btnList}) {
  return AppBar(
    toolbarHeight: height,
    elevation: 0,
    title: Row(
      children: [
        SizedBox(
          width: 200,
          child: Stack(
            children: <Widget>[              
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: fontColor , // <-- Inner color
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
                height: height,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: btnList == null ? 0 : 1,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        btnList?[index].func();
                      },
                      child: Icon(
                        btnList?[index].icon,
                        color: btnList?[index].color,
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
    backgroundColor: backgroundColor,
  );
}