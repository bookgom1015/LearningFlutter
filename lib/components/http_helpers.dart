import 'package:flutter_application_learning/entries/group.dart';
import 'package:flutter_application_learning/entries/post.dart';
import 'package:flutter_application_learning/entries/subscriptions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_learning/components/globals.dart' as globals;

Future<int> getSubscriptions(int userId, void Function(Subscriptions data) onFinished) async {
  StringBuffer uri = StringBuffer();
  uri.write(globals.SpringUriPath);
  uri.write("/api/user/");
  uri.write(userId);
  uri.write("/subscription");
  var response = await http.get(Uri.parse(uri.toString()));
  if (response.statusCode != 200) {
    return response.statusCode;
  }
  List<dynamic> subscriptions = jsonDecode(response.body);
  Subscriptions subs = Subscriptions.fromJson(subscriptions);
  onFinished(subs);
  return response.statusCode;
}

Future<int> getGroups(void Function(List<Group> list) onFinished) async {
  StringBuffer uri = StringBuffer();
  uri.write(globals.SpringUriPath);
  uri.write("/api/team");
  var response = await http.get(Uri.parse(uri.toString()));
  if (response.statusCode != 200) {
    return response.statusCode;
  }
  List<Group> groups  = [];
  Map<String, dynamic> json = jsonDecode(response.body);
  List<dynamic> teamJsonArray = json["teams"];
  for (var teamJson in teamJsonArray) {
    groups.add(Group.fromJson(teamJson));
  }
  onFinished(groups);
  return response.statusCode;
}

Future<int> getPosts(void Function(List<Post> list) onFinished) async {
  StringBuffer uri = StringBuffer();
  uri.write(globals.SpringUriPath);
  uri.write("/api/post");
  var response = await http.get(Uri.parse(uri.toString()));
  if (response.statusCode != 200) {
    return response.statusCode;
  }
  List<Post> posts = [];
  List<dynamic> jsonArray = jsonDecode(response.body);
  for (var json in jsonArray) {
    posts.add(Post.fromJson(json));
  }
  onFinished(posts);
  return response.statusCode;
}

Future<int> editProfile(String token, String desc) async {
  StringBuffer uri = StringBuffer();
  uri.write(globals.SpringUriPath);
  uri.write("/api/user/profile");
  var response = await http.put(Uri.parse(
    uri.toString()),
    headers: { "Content-Type": "application/json", "Authorization": token },
    body: jsonEncode({
      "description": desc
    })
  );
  return response.statusCode;
}

Future<int> writePost(int groupId, String tags, String token, String title, String desc) async {
  StringBuffer uri = StringBuffer();
  uri.write(globals.SpringUriPath);
  uri.write("/api/team/");
  uri.write(groupId);
  uri.write("/post");
  String spaceless = tags.replaceAll(" ", "");
  var list = spaceless.split(",");
  var response = await http.post(
    Uri.parse(uri.toString()),
    headers: { "Content-Type": "application/json", "Authorization" : token },
    body: jsonEncode({
      "title": title,
      "description": desc,
      "tags": list,
    })
  );
  return response.statusCode;
}

Future<int> addGroup(String token, String title, bool isPrivate, String tags) async {
  StringBuffer uri = StringBuffer();
  uri.write(globals.SpringUriPath);
  uri.write("/api/team");
  String spaceless = tags.replaceAll(" ", "");
  var list = spaceless.split(",");
  var response = await http.post(Uri.parse(
    uri.toString()),
    headers: { "Content-Type": "application/json", "Authorization": token },
    body: jsonEncode({
      "name": title,
      "teamType": isPrivate ? "PRIVATE" : "PUBLIC",
      "tags": list,
    })
  );
  return response.statusCode;
}

Future<int> requestToJoin(String token, int teamId) async {
  StringBuffer uri = StringBuffer();
  uri.write(globals.SpringUriPath);
  uri.write("/api/team/");
  uri.write(teamId);
  uri.write("/join");
  var response = await http.post(
    Uri.parse(uri.toString()),
    headers: { "Content-Type": "application/json", "Authorization": token },
    body: jsonEncode({
      "description": "가입시켜줘 시발련아"
    })
  ); 
  return response.statusCode;
}

Future<int> editAccount(String token, String nickname, String password) async {
  StringBuffer uri = StringBuffer();
  uri.write(globals.SpringUriPath);
  uri.write("/api/user");
  var response = await http.put(
    Uri.parse(uri.toString()),
    headers: { "Content-Type": "application/json", "Authorization": token },
    body: jsonEncode({
      "userNickname": nickname,
      "userPassword": password
    })
  ); 
  return response.statusCode;
}

Future<int> withdraw(String token) async {
  StringBuffer uri = StringBuffer();
  uri.write(globals.SpringUriPath);
  uri.write("/api/user");
  var response = await http.delete(
    Uri.parse(uri.toString()),
    headers: { "Content-Type": "application/json", "Authorization": token }
  );

  return response.statusCode;
}