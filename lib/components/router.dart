import 'package:flutter/material.dart';
import 'package:flutter_application_learning/add_group.dart';
import 'package:flutter_application_learning/add_reply_page.dart';
import 'package:flutter_application_learning/group_management.page.dart';
import 'package:flutter_application_learning/permision_page.dart';
import 'package:flutter_application_learning/signup_page.dart';
import 'package:flutter_application_learning/edit_account_page.dart';
import 'package:flutter_application_learning/edit_profile_page.dart';
import 'package:flutter_application_learning/group_details_page.dart';
import 'package:flutter_application_learning/joining_group_list_page.dart';
import 'package:flutter_application_learning/login_page.dart';
import 'package:flutter_application_learning/main_page.dart';
import 'package:flutter_application_learning/post_page.dart';
import 'package:flutter_application_learning/withdrawal_page.dart';
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
      '/edit_account': (context) => const EditAccountPage(),
      '/edit_profile': (context) => const EditProfilePage(),
      '/joining_group_list': (context) => const JoiningGroupListPage(),
      '/withdrawal': (context) => const WithdrawalPage(),
      '/add_group': (context) => const AddGroupPage(),
      '/group_manage': (context) => const GroupManagementPage(),
      '/add_reply': (context) => const AddReplyPage(),
      '/permision': (context) => const PermisionPage(),
    },
  );
}