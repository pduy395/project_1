
import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';


String url = "http://192.168.138.199:8000";
//String url = "http://127.0.0.1:8000";

class Question {

  String word;
  String type;
  String correctAnswer;
  List<String> options;

  Question({
    this.word ="",
    this.type ="",
    this.correctAnswer ="",
    required this.options
  });

  factory Question.fromJson(Map<String, dynamic> json){
    List<String> op = [];
    Random random = Random();
    int randomInt = random.nextInt(3);
    op.add(json['crepe1']);
    op.add(json['crepe2']);
    op.add(json['crepe3']);
    op.insert(randomInt, json['meaning']);


    return Question(
        word: json['word'] ,
        type: json['type'] ,
        correctAnswer: json['meaning'],
        options: op ,
    );
  }
}


class Result {
  int result;
  String creat_at;
  Result({
    this.result =0,
    this.creat_at = ""
  });

  factory Result.fromJson(Map<String, dynamic> json){

    return Result(
      result: json['result'] ,
      creat_at: json['created_at'],
    );
  }
}




Future<List<Question>> getTest(token) async {
  final response = await http.get(
    Uri.parse('$url/test/create_test/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    //final List<dynamic> jsonResponse = json.decode(response.body);
    final List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    return jsonResponse.map((json) => Question.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}


Future<List<Question>> getTest_by_topic(token,topic_id) async {
  final response = await http.get(
    Uri.parse('$url/test/create_test_in_topic/?topic_id=$topic_id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    //final List<dynamic> jsonResponse = json.decode(response.body);
    final List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    return jsonResponse.map((json) => Question.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<void> addTest_result(token,result) async {
  Map<String, dynamic> jsonData = {
      "result": result,
    "created_at": "2023-12-31T07:41:54.300Z"
  };

  String jsonString = jsonEncode(jsonData);

  await http.post(
      Uri.parse('$url/test/add_test_result/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonString
  );
}

Future<List<Result>> getTest_result(token) async {
  final response = await http.get(
    Uri.parse('$url/test/get_result'),
    headers: <String, String>{
      //'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );


  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((json) => Result.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}


Future<void> addProgress(token,topic_id,progress) async {
  Map<String, dynamic> jsonData = {
    "progress": progress,
    "topic_id": topic_id
  };

  String jsonString = jsonEncode(jsonData);

  final response = await http.post(
      Uri.parse('$url/topic/post_progress/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonString
  );
  if (response.statusCode == 200) {
  } else {
    throw Exception('Some thing went wrong');
  }
}

Future<void> main() async {

  final u = await addTest_result("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiZXhwIjoxNzAzOTU3NjI4fQ.T-tSDMLyhHiyPaW3lsOVndYKanXm-XdZMVJcP2MSPe0",30);
  // for(Result r in u)
  // print(r.result);

}