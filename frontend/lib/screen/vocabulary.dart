
import 'package:first_app/screen/topic.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


String url = "http://192.168.138.199:8000";
//String url = "http://127.0.0.1:8000";

class Vocabulary {
  String word;
  String meaning;
  String type;

  Vocabulary({
    this.word = "word",
    this.meaning = "meaning",
    this.type = "type"
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json){
    return Vocabulary(
        word: json['word'] ,
        meaning: json['meaning'] ,
        type: json['type']
    );
  }
}




Future<List<Vocabulary>> getAllVocabulary(token) async {
  final response = await http.get(
    Uri.parse('$url/vocabulary/get_all/'),
    headers: <String, String>{
      //'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );


  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((json) => Vocabulary.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<Vocabulary>> getVocabulary(token,topic_id) async {
  final response = await http.get(
    Uri.parse('$url/vocabulary/get_by_id/?topic_id=$topic_id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );


  if (response.statusCode == 200) {
    //final List<dynamic> jsonResponse = json.decode(response.body);
    final List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    return jsonResponse.map((json) => Vocabulary.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<void> deleteVocabulary(token,word) async {
  final response = await http.delete(
    Uri.parse('$url/vocabulary/delete_vocabulary/?word=$word'),
    headers: <String, String>{
      //'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );


  if (response.statusCode == 200) {
  } else {
    throw Exception('Failed to load data');
  }
}

Future<void> addVocabulary(token,topic_id, Vocabulary v) async {
  Map<String, dynamic> jsonData = {
    "word": v.word,
    "meaning": v.meaning,
    "type": v.type
  };

  String jsonString = jsonEncode(jsonData);

  final response = await http.post(
    Uri.parse('$url/vocabulary/add/?topic_id=$topic_id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonString
  );


  if (response.statusCode == 201) {
  } else {
    throw Exception('Failed to add data');
  }
}

Future<void> main() async {
  final u = await getVocabulary("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiZXhwIjoxNzA0MDgxOTk0fQ.91s8US_T9nWW1tde30uJQV48mzQ4m0QM5BqlgcFCQhQ",21);

}
