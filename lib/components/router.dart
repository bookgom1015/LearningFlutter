import 'package:flutter/material.dart';
import 'package:flutter_application_learning/components/signup_page.dart';
import 'package:flutter_application_learning/edit_account_page.dart';
import 'package:flutter_application_learning/group_details_page.dart';
import 'package:flutter_application_learning/joining_group_list_page.dart';
import 'package:flutter_application_learning/login_page.dart';
import 'package:flutter_application_learning/main_page.dart';
import 'package:flutter_application_learning/post_page.dart';
import 'package:flutter_application_learning/write_post.dart';

MaterialApp createRouter() {
  return MaterialApp(
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      '/': (context) => const LoginPage(),
      '/main': (context) => const MainPage(),
      '/signup': (context) => const SignupPage(),
      '/group_details': (context) => const GroupDetailsPage(),
      '/write_post': (context) => const WritePostPage(),
      '/post': (context) => const PostPage(),
      '/edit': (context) => const EditAccountPage(),
      '/joining_group_list': (context) => const JoiningGroupListPage(),
    },
  );
}