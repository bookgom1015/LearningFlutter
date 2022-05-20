import 'package:flutter_application_learning/entries/group.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_learning/globals.dart' as globals;

void getGroups(void Function(List<Group> list) onFinished) async {
    StringBuffer uri = StringBuffer();
    uri.write(globals.SpringUriPath);
    uri.write("/api/team");

    var response = await http.get(Uri.parse(uri.toString()));

    if (response.statusCode != 200) {
      print("error occured: " + response.statusCode.toString());
      return;
    }

    List<Group> groups  = [];

    Map<String, dynamic> json = jsonDecode(response.body);
    List<dynamic> teamJsonArray = json["teams"];
    for (var teamJson in teamJsonArray) {
      groups.add(Group.fromJson(teamJson));
    }

    onFinished(groups);
  }