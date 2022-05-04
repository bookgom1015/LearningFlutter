import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/signup_page.dart';
import 'package:flutter_application_learning/group_details_page.dart';
import 'package:flutter_application_learning/login_page.dart';
import 'package:flutter_application_learning/main_page.dart';
import 'package:flutter_application_learning/post_details_page.dart';
import 'package:flutter_application_learning/write_group_post_page.dart';
import 'package:flutter_application_learning/write_post.dart';

MaterialApp createRouter() {
  return MaterialApp(
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      '/': (context) => const LoginPage(),
      '/main': (context) => const MainPage(),
      '/detail_group': (context) => const GroupDetailsPage(),
      '/detail_post': (context) => const PostDetailsPage(),
      '/signup': (context) => const SignupPage(),
      '/write_post': (context) => const WritePostPage(),
      '/write_group_post': (context) => const WriteGroupPostPage(),
    },
  );
}