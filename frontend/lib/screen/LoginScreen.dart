import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'RegisterScreen.dart';
import 'user.dart';


Future<void> main() async {
  runApp(const Page());
}

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  var emailTextController = TextEditingController();
  var passwordTextController = TextEditingController();
  bool obscurePassword = true;
  bool isLoginButtonEnabled = false;
  bool showEmailError = false;
  bool showPasswordError = false;

  @override
  void initState() {
    super.initState();
    emailTextController.addListener(updateLoginButtonState);
    passwordTextController.addListener(updateLoginButtonState);
  }

  void updateLoginButtonState() {
    setState(() {
      isLoginButtonEnabled =
          emailTextController.text.isNotEmpty && passwordTextController.text.isNotEmpty;
      // Hiển thị cảnh báo nếu trường tên người dùng hoặc mật khẩu rỗng
      showEmailError = emailTextController.text.isEmpty;
      showPasswordError = passwordTextController.text.isEmpty;
    });
  }

  Future<void> login() async {
    var userName = emailTextController.text;
    var password = passwordTextController.text;
    try{
    final u = await getUser(userName, password);
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => HomeScreen(u.token)));
    }
        catch(error){
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Login Failed'),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Welcome to myApp',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 250,
                  height: 70,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Container(
                            width: 250,
                            height: 70,
                            color: const Color.fromRGBO(73, 187, 189, 0.6),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 15),
                                backgroundColor:
                                    const Color.fromRGBO(73, 187, 189, 1)),
                            onPressed: () {},
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(255, 255, 255, 1)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        top: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: TextButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              //backgroundColor: const Color.fromRGBO(73, 187, 189, 1)
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => RegisterScreen()));
                            },
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(255, 255, 255, 1)),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ' User name: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: emailTextController,
                  decoration: InputDecoration(
                      hintText: "user name ( enter your email )",
                      hintStyle: const TextStyle(color: Color(0xffCCCCCC)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                    errorText: showEmailError ? 'Please enter your email' : null,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ' Password: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordTextController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    hintText: "password",
                    hintStyle: const TextStyle(color: Color(0xffCCCCCC)),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    errorText: showPasswordError ? 'Please enter your password' : null,
                    suffixIcon: IconButton(
                      icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          backgroundColor:
                              const Color.fromRGBO(73, 187, 189, 1),
                        ),
                        onPressed: isLoginButtonEnabled ? login : null,
                        child: const Text('Login',style: TextStyle(color: Colors.white),)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
