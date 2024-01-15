import 'package:http/http.dart' as http;
import 'dart:convert';

String url = "http://192.168.138.199:8000";
//String url = "http://127.0.0.1:8000";
class User {
  final String token;
  final String username;
  final String email;

  const User({
    this.token ="token",
     this.username = "name",
     this.email = "email",
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      token: json['access_token'] ?? '',
      username: json['user_name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

Future<User> getUser(username,password) async {
  final response = await http.post(
      Uri.parse('$url/login'),
      body: {
        'username': username,
        'password': password
      });
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return User.fromJson(data);
  }
  else {
    final data = jsonDecode(response.body);
    throw Exception(data['detail']);
  }

}

Future<User> registerUser(username,email,password) async{

    Map<String, dynamic> jsonData = {
      "user_name": username,
      "email": email,
      "password": password
    };

    String jsonString = jsonEncode(jsonData);
  final response = await http.post(
      Uri.parse('$url/user/create_user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    body: jsonString);


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    }
    else {
      final data = jsonDecode(response.body);
      throw Exception(data['detail']);
    }

}

Future<User> showUser(token) async{


  final response = await http.get(
      Uri.parse('$url/user/show_me'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
         },
      );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return User.fromJson(data);
  }
  else {
    final data = jsonDecode(response.body);
    throw Exception(data['detail']);
  }


}

Future<User> changeInfomation(token,username,email) async{

  Map<String, dynamic> jsonData = {
    "user_name": username,
    "email": email,
    "password": ""
  };

  String jsonString = jsonEncode(jsonData);
  final response = await http.put(
      Uri.parse('$url/user/change_info'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonString);


  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return User.fromJson(data);
  }
  else {
    final data = jsonDecode(response.body);
    throw Exception(data['detail']);
  }

}

Future<User> changePassword(token,newPass,oldPass) async{

  Map<String, dynamic> jsonData = {
    "new_pass": newPass,
    "old_pass": oldPass
  };

  String jsonString = jsonEncode(jsonData);
  final response = await http.put(
      Uri.parse('$url/user/change_pass'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonString);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return User.fromJson(data);
  }
  else {
  final data = jsonDecode(response.body);
  throw Exception(data['detail']);
  }

}


Future<void> main() async {
  //final u = await getUser("string", "string");
  final u = await registerUser("str", "str", "str");
  //final u = await showUser("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiZXhwIjoxNzAzMjIwMjc5fQ.jdBqP4KXgiirSmdyv4Zopr8u1z1z3llTDI3uoSFFqNg");
  print(u.username);
}

