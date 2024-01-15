import 'package:flutter/material.dart';
import 'topic.dart';
import 'user.dart';
import 'dart:async';
import 'ListVocabularyPage.dart';
import 'SettingPage.dart';
import 'ChartPage.dart';
import 'TestPage.dart';

List<String> image = ["assets/images/topic_img/1.jpg","assets/images/topic_img/2.jpg","assets/images/topic_img/3.jpg","assets/images/topic_img/4.jpg",
  "assets/images/topic_img/5.jpg", "assets/images/topic_img/6.jpg", "assets/images/topic_img/7.jpg","assets/images/topic_img/8.jpg",
  "assets/images/topic_img/9.jpg","assets/images/topic_img/10.jpg", "assets/images/topic_img/11.jpg","assets/images/topic_img/12.jpg",
  "assets/images/topic_img/13.jpg","assets/images/topic_img/4.jpg","assets/images/topic_img/15.jpg","assets/images/topic_img/16.jpg"];

void main() {
  runApp(Page3(".."));
}

class Page3 extends StatelessWidget {
  String token;
  Page3(this.token,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(token),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget{
  String token;

  HomeScreen(this.token,{Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user = User();
  List<Topic> l1 = [Topic.random(),Topic.random(),Topic.random()];
  List<Topic> l2 = [Topic.random(),Topic.random(),Topic.random()];
  List<String> tp_name =[];

  Future<void> getData(String token) async {
    l1 = [];
    l2 = [];
    try {
      final fetchedUser = await showUser(token);
      user = fetchedUser;
      final l = await getTopic(token);
      for(Topic tp in l){
        tp_name.add(tp.topic_name);
        if(tp.user_id == 0) {
          l1.add(tp);
        } else {
          l2.add(tp);
        }
      }
      setState(() {

      });
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Failed'),
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
  void initState() {
    super.initState();
    getData(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                  child: Stack(
                      children:[
                        SizedBox(
                          height: 100,
                          child: Container(color: const Color.fromRGBO(73, 187, 189, 0.1)),
                        ),
                        Positioned(
                          left: 20,
                          top: 40,
                          child: Text(
                            user.username,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        Positioned(
                            left: 20,
                            top: 10,
                            child: Text("Welcome to myApp",
                              style: TextStyle(fontSize: 18,color: Colors.black.withOpacity(0.6)),)),
                        Positioned(
                            right: 40,
                            top: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.asset("assets/images/avatar/1.jpg",width: 50,
                                    fit: BoxFit.fitWidth,)
                              ),
                            ))
                      ]
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text('Available Topic',
                    style: TextStyle(fontSize: 20),),
                ),
                SizedBox(
                  height: 200,
                  child: ListTopic(widget.token, l1),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text('Your Topic',
                    style: TextStyle(fontSize: 20),),
                ),
                SizedBox(
                  height: 200,
                  child: ListTopic(widget.token, l2),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Hiển thị form như thông báo với ô nhập dữ liệu
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String userInput = '';

                                return AlertDialog(
                                  title: Text('Enter your topic name'),
                                  content: TextField(
                                    onChanged: (value) {
                                      // Lắng nghe sự kiện thay đổi giá trị trong ô nhập dữ liệu
                                      userInput = value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Enter the new topic name...',
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        // Đóng thông báo khi nhấn nút và trả về dữ liệu nhập
                                        Navigator.of(context).pop(userInput);
                                      },
                                      child: Text('Confirm'),
                                    ),
                                  ],
                                );
                              },
                            ).then((result) {
                              // Xử lý dữ liệu nhập từ ô nhập khi thông báo đóng
                              if (result != null && result!="") {
                                if(tp_name.contains(result)){
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          content: Text("this topic is existed"),
                                        );
                                      });
                                }else{

                                  addTopic(widget.token,result);
                                  getData(widget.token);
                                  setState(() {

                                  });
                                }
                                // Do something with the user input
                              }
                            }
                            );
                          },
                          child: const Text('Add your topic'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle the second button click
                            Navigator.push(context,MaterialPageRoute(
                                builder: (c) =>QuizPage(widget.token,Topic(),0)));
                          },
                          child: const Text('All Test'),
                        )
                      ]
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(73, 187, 189, 0.1),
        padding: const EdgeInsets.only(left: 50,right: 50,top: 10,bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.home_outlined,size: 30),color: Colors.black.withOpacity(0.6)),
            IconButton(onPressed: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => MyChartPage(widget.token)));
            }, icon: Icon(Icons.add_chart,size: 30),color: Colors.black.withOpacity(0.6)),
            IconButton(onPressed: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => SettingsPage(widget.token)));
            }, icon: Icon(Icons.settings,size: 30,),color: Colors.black.withOpacity(0.6),)
          ],
        ),
      ),
    );
  }
}

class ListTopic extends StatefulWidget{
  List<Topic> listTopic;
  String
  token;
  ListTopic(this.token,this.listTopic,{Key? key}) : super(key: key);

  @override
  State<ListTopic> createState() => _ListTopicState();
}

class _ListTopicState extends State<ListTopic> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.listTopic.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          child: TopicItem(
            widget.listTopic[index],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VocabularyListPage(widget.token,widget.listTopic[index])));
          },
          onLongPress: (){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                String userInput = '';

                return AlertDialog(
                  title: Text('Enter \'${widget.listTopic[index].topic_name}\' to delete this topic'),
                  content: TextField(
                    onChanged: (value) {
                      // Lắng nghe sự kiện thay đổi giá trị trong ô nhập dữ liệu
                      userInput = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter the topic name to delete...',
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        // Đóng thông báo khi nhấn nút và trả về dữ liệu nhập
                        Navigator.of(context).pop(userInput);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            ).then((result) {
              // Xử lý dữ liệu nhập từ ô nhập khi thông báo đóng
              if (result != null) {
                if(result != widget.listTopic[index].topic_name){
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          content: Text("Your confirm is wrong"),
                        );
                      });
                }else{
                  deleteTopic(widget.token, widget.listTopic[index].id);
                  setState(() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen(widget.token)),
                    );
                  });
                }
                // Do something with the user input
              }
            }
            );
          },
        );
      },
    );
  }
}

class TopicItem extends StatefulWidget{
  final Topic topic;

  const TopicItem( this.topic, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _TopicItemState(topic);
  }
}

class _TopicItemState extends State<TopicItem> {
  final Topic topic;

  _TopicItemState(this.topic);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return  Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(8),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: SizedBox(
              height: 70,
              child: Container(color: const Color.fromRGBO(73, 187, 189, 0.45)),
            ),
          ),
          Positioned(
              left: 20,
              top: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: SizedBox(
                  width: 80,
                  height: 50,
                  child: Image.asset(image[topic.id % 16], fit: BoxFit.fitWidth),
                ),
              )),
          Positioned(
              left: 110,
              top: 20,
              child: Text(topic.topic_name, style: const TextStyle(fontSize: 20),)),
          Positioned(
              right: 40,
              top: 15,
              child: MyDualColorCircle(progress: topic.progress.toDouble()))
        ],
      ),
    );
  }
}

class MyDualColorCircle extends StatelessWidget {
  final double progress;

  const MyDualColorCircle({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          // Hình tròn nền (màu xám)
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
          ),
          // Hình tròn viền (màu xanh)
          Positioned.fill(
            child: CircularProgressIndicator(
              value: progress / 100,
              color: Colors.green,
              strokeWidth: 5.0, // Độ rộng của viền
              backgroundColor: Colors.grey, // Màu nền của viền
            ),
          ),
          // Phần trăm hoàn thành ở giữa hình tròn
          Positioned.fill(
            child: Center(
              child: Text(
                '${(progress).toInt()}%', // Hiển thị phần trăm hoàn thành
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}