
class JoinRequests {
  List<JoinRequest> requests;

  JoinRequests({required this.requests});

  JoinRequests.fromJson(List<dynamic> json)
    : requests = List<JoinRequest>.from(json.map((j) => JoinRequest.fromJson(j)));

  @override
  String toString() {
    return requests.toString();
  }
}

class JoinRequest {
  String message;
  int requestId;
  int teamId;
  int userId;

  JoinRequest({
    required this.message,
    required this.requestId,
    required this.teamId,
    required this.userId});

  JoinRequest.fromJson(dynamic json)
    : message = json["message"] ?? "",
      requestId = json["requestId"],
      teamId = json["teamId"],
      userId = json["userId"];

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    sb.write("{\"message\": \""); sb.write(message);
    sb.write("\", \"requestId\": "); sb.write(requestId);
    sb.write(", \"teamId\": "); sb.write(teamId);
    sb.write(", \"userId\": "); sb.write(userId);
    sb.write("}");
    return sb.toString();
  }
}