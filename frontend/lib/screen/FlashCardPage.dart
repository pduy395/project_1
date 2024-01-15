import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'vocabulary.dart';





class FlashCardPage extends StatefulWidget {
  String token;
  int topic_id;
  FlashCardPage(this.token,this.topic_id,{Key? key}) : super(key: key);



  @override
  _FlashCardPageState createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> {
  List<Vocabulary> flashcards = [
    Vocabulary(),
  ];

  int currentIndex = 0;

  Future<void> getData(String token,int topic_id) async {
    try {
      final fetchedVocabulary = await getVocabulary(token,topic_id);
      flashcards = fetchedVocabulary;
      if(flashcards.isEmpty){
        Navigator.pop(context);
      }
      setState(() {

      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getData(widget.token,widget.topic_id);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn with Flashcards'),
      ),
      body: Center(
        child: FlipCard(

          direction: FlipDirection.HORIZONTAL, // or FlipDirection.VERTICAL
          flipOnTouch: true,
          front: FlashcardSide(
              text: flashcards[currentIndex].word + " (" + flashcards[currentIndex].type + ")"),
          back: FlashcardSide(text: flashcards[currentIndex].meaning),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                currentIndex = (currentIndex - 1)%(flashcards.length);
              });
            },
            child: Icon(Icons.arrow_back),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                currentIndex = (currentIndex + 1)%(flashcards.length );
              });
            },
            child: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}

class FlashcardSide extends StatelessWidget {
  final String text;

  FlashcardSide({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}