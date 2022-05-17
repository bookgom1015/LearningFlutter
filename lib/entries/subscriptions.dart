import 'package:flutter_application_learning/entries/group.dart';
import 'dart:math' as math;

class Subscriptions {
  List<Group> groups;

  Subscriptions({required this.groups});

  Subscriptions.fromJson(List<dynamic> json)
    : groups = json.isEmpty ? [] : List<Group>.from(json.map((j) => Group.fromJson(j)));

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    sb.write("[");
    for (var group in groups) {
      sb.write(group);
      sb.write(", ");
    }
    String temp = sb.toString();
    sb.clear();
    sb.write(temp.substring(0, math.max(temp.length - 2, 1)));
    sb.write("]");
    return sb.toString();
  }
}