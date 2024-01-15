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
      home: ChangePasswordPage(""),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  String token;
  ChangePasswordPage(this.token,{Key? key}) : super(key: key);
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  bool obscureOldPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmNewPassword = true;
  bool isLoginButtonEnabled = false;
  bool showOldError = false;
  bool showNewError = false;
  bool showPasswordError = false;

  @override
  void initState() {
    super.initState();
    oldPasswordController.addListener(updateLoginButtonState);
    newPasswordController.addListener(updateLoginButtonState);
    confirmNewPasswordController.addListener(updateLoginButtonState);
  }

  void updateLoginButtonState() {
    setState(() {
      isLoginButtonEnabled =
          oldPasswordController.text.isNotEmpty && newPasswordController.text.isNotEmpty && confirmNewPasswordController.text.isNotEmpty;
      // Hiển thị cảnh báo nếu trường tên người dùng hoặc mật khẩu rỗng
      showNewError = newPasswordController.text.isEmpty;
      showPasswordError = confirmNewPasswordController.text.isEmpty;
      showOldError = oldPasswordController.text.isEmpty;
    });
  }

  void change(){
    if (newPasswordController.text == confirmNewPasswordController.text) {
      changePass(widget.token,newPasswordController.text, oldPasswordController.text);

    } else {
      // Mật khẩu mới nhập lại không khớp
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('New passwords do not match.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> changePass(token,newPass, oldPass) async {

    try{
      User u = await changePassword(token,newPass, oldPass);
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("Password is changed"),
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
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: obscureOldPassword,
              decoration: InputDecoration(
                hintText: 'Old Password',
                hintStyle: const TextStyle(color: Color(0xffCCCCCC)),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                errorText: showOldError ? 'Please enter your old password' : null,
                suffixIcon: IconButton(
                  icon: Icon(obscureOldPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      obscureOldPassword = !obscureOldPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: newPasswordController,
              obscureText: obscureNewPassword,
              decoration: InputDecoration(
                hintText: 'New Password',
                hintStyle: const TextStyle(color: Color(0xffCCCCCC)),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                errorText: showNewError ? 'Please enter your new password' : null,
                suffixIcon: IconButton(
                  icon: Icon(obscureNewPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      obscureNewPassword = !obscureNewPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: confirmNewPasswordController,
              obscureText: obscureConfirmNewPassword,

              decoration: InputDecoration(
                hintText: 'Confirm New Password',

                  hintStyle: const TextStyle(color: Color(0xffCCCCCC)),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                errorText: showPasswordError ? 'Please enter your confirm password' : null,
                suffixIcon: IconButton(
                  icon: Icon(obscureConfirmNewPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      obscureConfirmNewPassword = !obscureConfirmNewPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: isLoginButtonEnabled ? change : null,
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}