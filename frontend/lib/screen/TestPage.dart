import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'topic.dart';
import 'test.dart';


void main() {
  runApp(MaterialApp(
    home: QuizPage("",Topic(),1),
  ));
}

class QuizPage extends StatefulWidget {
  String token;
  Topic tp;
  int flag;

  QuizPage(this.token, this.tp,this.flag, {Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int questionIndex = 0;
  int finish = 0;
  int correctAnswers = 0;
  bool answerSelected = false;
  String selectedAnswer = '';
  List<Question> questions = [Question(options: [])];

  Future<void> getData(String token,int flag,int tp_id) async {
    try {
      if(flag == 0)
        questions = await getTest(token);
      else
        questions = await getTest_by_topic(token,tp_id);

      setState(() {});
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getData(widget.token,widget.flag,widget.tp.id);
  }

  void answerQuestion(String answer) {
    if (!answerSelected) {
      setState(() {
        answerSelected = true;
        selectedAnswer = answer;
        if (questions[questionIndex].correctAnswer == answer) {
          correctAnswers++;
        }
        if (questionIndex == questions.length-1){
          finish=1;
        }
      });
    }
  }

  void nextQuestion() {
    setState(() {
      answerSelected = false;
      selectedAnswer = '';
      questionIndex = (questionIndex + 1) % questions.length;
    });
  }
  Future<void> addressult() async {
    await addTest_result(widget.token, (correctAnswers/questions.length*100).toInt() );
    if(widget.flag ==1){
      await addProgress(widget.token, widget.tp.id, (correctAnswers/questions.length*100).toInt());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test vocabulary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Question ${questionIndex+1} : ${questions[questionIndex].word} (${questions[questionIndex].type})",
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            ...questions[questionIndex].options.map((option) {
              return ElevatedButton(
                onPressed: () => answerQuestion(option),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    answerSelected
                        ? option == questions[questionIndex].correctAnswer
                        ? Colors.green
                        : option == selectedAnswer
                        ? Colors.red
                        : Colors.grey
                        : Colors.white,
                  ),
                ),
                child: Text(option),
              );
            }),
            const SizedBox(height: 20.0),
            if(finish ==0)
            ElevatedButton(
              onPressed: answerSelected ? nextQuestion : null,
              child: Text(answerSelected ? 'Next Question' : 'Select an Answer'),
            ),
            if(finish ==1)
              ElevatedButton(
                onPressed: () {
                  addressult();
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => HomeScreen(widget.token)));
                },
                child: const Text('Return home page'),
              ),

            const SizedBox(height: 20.0),
            Text(
              'Correct Answers: $correctAnswers / ${questions.length}',
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}

