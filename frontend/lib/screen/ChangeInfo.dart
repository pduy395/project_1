
import 'package:flutter/material.dart';
import 'user.dart';
import 'HomePage.dart';
import 'LoginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeInfoPage(""),
    );
  }
}

class ChangeInfoPage extends StatefulWidget {
  String token;
  ChangeInfoPage(this.token,{Key? key}) : super(key: key);
  @override
  _ChangeInfoPageState createState() => _ChangeInfoPageState();
}

class _ChangeInfoPageState extends State<ChangeInfoPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  bool isLoginButtonEnabled = false;
  bool showEmailError = false;
  bool showUsernameError = false;


  @override
  void initState() {
    super.initState();
    emailController.addListener(updateLoginButtonState);
    usernameController.addListener(updateLoginButtonState);

  }

  void updateLoginButtonState() {
    setState(() {
      isLoginButtonEnabled =
          emailController.text.isNotEmpty && usernameController.text.isNotEmpty ;
      // Hiển thị cảnh báo nếu trường tên người dùng hoặc mật khẩu rỗng
      showEmailError = emailController.text.isEmpty;
      showUsernameError = usernameController.text.isEmpty;
    });
  }

  void change(){

      changeInfo(widget.token,emailController.text, usernameController.text);

    }


  Future<void> changeInfo(token,email, username) async {

    try{
      User u = await changeInfomation(token,username, email);
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("Info is changed"),
            );
          });
    }catch(error){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Change Failed'),
            content: Text('$error'), // Sử dụng Text không phải const
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change your info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: const TextStyle(color: Color(0xffCCCCCC)),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                errorText: showEmailError ? 'Please enter your new email' : null,

              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                hintText: 'Username',
                hintStyle: const TextStyle(color: Color(0xffCCCCCC)),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                errorText: showUsernameError ? 'Please enter your new password' : null,
              ),
            ),
            const SizedBox(height: 16.0),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: isLoginButtonEnabled ? change : null,
              child: const Text('Change Info'),
            ),
          ],
        ),
      ),
    );
  }
}