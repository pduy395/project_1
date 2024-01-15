
import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';


String url = "http://192.168.138.199:8000";
//String url = "http://127.0.0.1:8000";

class Topic {
  int id;
  String topic_name;
  double progress;
  int user_id;
  Topic({
    this.id = 0,
    this.user_id = 0,
    this.topic_name ="topic name",
    this.progress = 0
});
  factory Topic.random() {
    return Topic(
      topic_name: 'Random Topic',
      user_id: 1,
      id: 0,
      progress: Random().nextInt(100).toDouble(),
    );
  }
  factory Topic.fromJson(Map<String, dynamic> json){
    return Topic(
      id: json['id'] ?? 0,
      user_id: json['user_id'] ?? 0,
      topic_name: json['topic_name'] ?? 0,
      progress: json['progress'].toDouble() ?? 0,
    );
  }
}




Future<List<Topic>> getTopic(token) async {
  final response = await http.get(
    Uri.parse('$url/topic/get_all_topic'),
    headers: <String, String>{
      //'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );
  print("---");
  print(response.statusCode);

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((json) => Topic.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}


Future<Topic> addTopic(token,topicName) async {
  Map<String, dynamic> jsonData = {
    "id": 0,
    "user_id": 0,
    "progress": 0,
    "topic_name": topicName,
  };

  String jsonString = jsonEncode(jsonData);

  final response = await http.post(
    Uri.parse('$url/topic/create_topic/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
      body: jsonString
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return Topic.fromJson(data);
  }
  else {
    final data = jsonDecode(response.body);
    throw Exception(data['detail']);
  }
}


Future<void> deleteTopic(token,topicId) async {

  final response = await http.delete(
      Uri.parse('$url/topic/delete_topic/$topicId/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
  );
  if (response.statusCode == 200) {
  }
  else {
    final data = jsonDecode(response.body);
    throw Exception(data['detail']);
  }
}

Future<void> main() async {

  final u = await getTopic("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiZXhwIjoxNzAzOTI0NTI5fQ.KJ7xkJmofCnNZhn6JR2xyX54G2grkbpRHm4GOkdfhGc");
  for(Topic k in u){
  print(k.topic_name);
  print(k.progress);
  }

}
