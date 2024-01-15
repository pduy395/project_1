import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'HomePage.dart';
import 'ChangePass.dart';
import 'ChartPage.dart';
import 'ChangeInfo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingsPage(""),
    );
  }
}

class SettingsPage extends StatefulWidget {
  String token;
  SettingsPage(this.token,{Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "   myApp setting",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('Change Password'),
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (c) => ChangePasswordPage(widget.token)));
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Update Personal Info'),
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (c) => ChangeInfoPage(widget.token)));

                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Logout'),
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (c) => LoginScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(

        color: const Color.fromRGBO(73, 187, 189, 0.1),
        padding: const EdgeInsets.only(left: 50,right: 50,top: 10,bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => HomeScreen(widget.token)));
            }, icon: Icon(Icons.home_outlined,size: 30),color: Colors.black.withOpacity(0.6)),
            IconButton(onPressed: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => MyChartPage(widget.token)));
            }, icon: Icon(Icons.add_chart,size: 30),color: Colors.black.withOpacity(0.6)),
            IconButton(onPressed: (){}, icon: Icon(Icons.settings,size: 30,),color: Colors.black.withOpacity(0.6),)
          ],
        ),
      ),
    );
  }
}