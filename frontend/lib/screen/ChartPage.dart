import 'package:first_app/screen/test.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'HomePage.dart';
import 'SettingPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyChartPage("..--"),
    );
  }
}

class MyChartPage extends StatefulWidget {

  String token;
  MyChartPage(this.token, {Key? key}) : super(key: key);

  @override
  _MyChartPageState createState() => _MyChartPageState();
}

class _MyChartPageState extends State<MyChartPage> {
  List<FlSpot> sp = [
    FlSpot(0, 30),
    FlSpot(1, 10),
    FlSpot(2, 40),
    FlSpot(3, 20),
  ];
  List<Result> rs = [];
  double minX = 0;
  double maxX = 0;

  Future<void> getData(String token) async {
    try {
      final fetchedData = await getTest_result(token);
      rs =fetchedData;
      sp = [];
        for(int i=0 ;i< fetchedData.length;i++){
          sp.add(FlSpot(i.toDouble(), fetchedData[i].result.toDouble()));
          maxX = sp.length-1;
        }
      setState(() {});
    } catch (e) {
      print("Error fetching data: $e");
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
      appBar: AppBar(
        title: const Text('test statistic'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children:[
            const Align(
              alignment: Alignment.topLeft,
                child: Text("     Chart",style: TextStyle(fontSize: 20),)),
            SizedBox(
            height: 200,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: LineChart(
                  LineChartData(
                    // Cấu hình dữ liệu biểu đồ ở đây
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      rightTitles: SideTitles(showTitles: false),
                      topTitles: SideTitles(showTitles: false),
                      leftTitles: SideTitles(
                        showTitles: false,
                        interval: 10,
                        getTitles: (value) {
                          if (value >= 0 && value <=100) {
                            return value.toString();
                          }
                          return '';
                        },
                        margin: 8,
                      ),
                      bottomTitles: SideTitles(
                        showTitles: false,
                        interval: 1.0,
                        //getTextStyles: (value) => const TextStyle(color: Colors.black),
                        getTitles: (value) {
                          if (value >= 0 && value < sp.length) {
                            return sp[value.toInt()].x.toString();
                          }
                          return '';
                        },
                        margin: 8,
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: const Color(0xff37434d), width: 1),
                    ),
                    minX: minX,
                    maxX: maxX,
                    minY: 0,
                    maxY: 100,
                    lineBarsData: [
                      LineChartBarData(
                        spots: sp,
                        isCurved: false,
                        colors: [Colors.blue],
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: true),
                      ),
                    ],
              
                  ),
                ),
            ),
        
          ),
            SizedBox(height: 10,),
            const Align(
                alignment: Alignment.topLeft,
                child: Text("     Detail",style: TextStyle(fontSize: 20),)),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: rs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Stack(children: [
                      ListTile(
                        title: Text("Result: ${rs[rs.length-1-index].result} /100"),
                        subtitle: Text(rs[rs.length-1-index].creat_at),
                        // Customize the appearance of each list item here
                      ),]
        
        
                  ),);
                },
              ),
            ),
          ]
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
            IconButton(onPressed: (){}, icon: Icon(Icons.add_chart,size: 30),color: Colors.black.withOpacity(0.6)),
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