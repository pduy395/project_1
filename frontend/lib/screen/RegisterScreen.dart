import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'user.dart';



class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<RegisterScreen> {
  var emailTextController = TextEditingController();
  var usernameTextController = TextEditingController();
  var passwordTextController = TextEditingController();
  bool obscurePassword = true;
  bool isLoginButtonEnabled = false;
  bool showEmailError = false;
  bool showUsernameError = false;
  bool showPasswordError = false;

  @override
  void initState() {
    super.initState();
    emailTextController.addListener(updateLoginButtonState);
    usernameTextController.addListener(updateLoginButtonState);
    passwordTextController.addListener(updateLoginButtonState);
  }

  void updateLoginButtonState() {
    setState(() {
      isLoginButtonEnabled =
          emailTextController.text.isNotEmpty && passwordTextController.text.isNotEmpty && usernameTextController.text.isNotEmpty;
      // Hiển thị cảnh báo nếu trường tên người dùng hoặc mật khẩu rỗng
      showEmailError = emailTextController.text.isEmpty;
      showPasswordError = passwordTextController.text.isEmpty;
      showUsernameError = usernameTextController.text.isEmpty;
    });
  }

  Future<void> register() async {
    var userName = usernameTextController.text;
    var password = passwordTextController.text;
    var email = emailTextController.text;

    try {
      final u = await registerUser(userName,email,password);
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("register successfully"),
            );
          });
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => LoginScreen()));
    }
    catch(error){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Register Failed'),
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
      body: SafeArea(child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30.0),
          child: Column(

              children: [
                const SizedBox(height: 30,),
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
                          child: TextButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              //backgroundColor: const Color.fromRGBO(73, 187, 189, 1)
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (c) => LoginScreen()));
                            },
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                backgroundColor:
                                const Color.fromRGBO(73, 187, 189, 1)),
                            onPressed: () {},
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
                    'User name: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: usernameTextController,

                  decoration:  InputDecoration(
                      hintText: " enter your user name",
                      hintStyle: const TextStyle(color: Color(0xffCCCCCC)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                    errorText: showUsernameError ? 'Please enter your username' : null,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: emailTextController,
                  decoration:  InputDecoration(
                      hintText: " enter your email ",
                      hintStyle: const TextStyle(color: Color(0xffCCCCCC)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                    errorText: showEmailError ? 'Please enter your email' : null,),
                ),
                const SizedBox(
                  height: 20,
                ),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordTextController,
                  obscureText: obscurePassword,
                  decoration:  InputDecoration(
                      hintText: " enter your password",
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
                          backgroundColor: const Color.fromRGBO(73, 187, 189, 1),
                        ),
                        onPressed: isLoginButtonEnabled ? register : null,
                        child: const Text('Register',style: TextStyle(color: Colors.white))),
                  ),
                ),
              ],
            ),
        ),

        ),
      )
    );
  }
}
