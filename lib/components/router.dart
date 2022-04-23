import 'package:flutter/material.dart';
import 'package:flutter_application_learning/detail_group_page.dart';
import 'package:flutter_application_learning/login_page.dart';
import 'package:flutter_application_learning/main_page.dart';
import 'package:flutter_application_learning/detail_post_page.dart';

MaterialApp createRouter() {
  return MaterialApp(
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      '/': (context) => const LoginPage(),
      '/main': (context) => const MainPage(),
      '/detail_group': (context) => const DetailGroupPage(),
      '/detail_post': (context) => const DetailPostPage(),
    },
  );
}