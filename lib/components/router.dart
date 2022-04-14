import 'package:flutter/material.dart';
import 'package:flutter_application_learning/detail_page.dart';
import 'package:flutter_application_learning/login_page.dart';
import 'package:flutter_application_learning/main_page.dart';
import 'package:flutter_application_learning/public_post.dart';

MaterialApp createRouter() {
  return MaterialApp(
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      '/': (context) => const LoginPage(),
      '/main': (context) => const MainPage(),
      '/detail': (context) => const DetailPage(),
      '/public_post': (context) => const PublicPostPage(),
    },
  );
}