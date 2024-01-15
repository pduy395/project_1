/// -*- coding: utf-8 -*-

import 'package:flutter/material.dart';
import 'vocabulary.dart';
import 'topic.dart';
import 'FlashCardPage.dart';
import 'TestPage.dart';





class VocabularyListPage extends StatefulWidget {
  int removeState = 0;
  List<String> rm = [];
  String token;
  Topic tp;

  VocabularyListPage(this.token, this.tp, {Key? key}) : super(key: key);

  @override
  _VocabularyListPageState createState() => _VocabularyListPageState();
}

class _VocabularyListPageState extends State<VocabularyListPage> {
  String a = 'tôi là duy';
  List<Vocabulary> vocabularyList = [
    Vocabulary(),
    Vocabulary(),
    Vocabulary(),
    Vocabulary()
  ];


  Future<void> getData(String token, int topic_id) async {
    try {
      final fetchedVocabulary = await getVocabulary(token, topic_id);
      vocabularyList = fetchedVocabulary;
      for(Vocabulary v in vocabularyList){
        print(v.meaning);
      }
      setState(() {});
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
    getData(widget.token, widget.tp.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.tp.topic_name),
          automaticallyImplyLeading: true),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children:[
                SizedBox(
                height: 510,
                child: ListView.builder(
                  itemCount: vocabularyList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Stack(children: [
                        ListTile(
                          title: Text("${vocabularyList[index].word} (${vocabularyList[index].type})"),
                          subtitle: Text(vocabularyList[index].meaning),
                          // Customize the appearance of each list item here

                        ),
                        if (widget.removeState == 1)
                          Positioned(
                              top: 25,
                              right: 30,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black, // Màu sắc của viền
                                    width: 2.0, // Độ dày của viền
                                  ),
                                ),
                              )),
                        if (widget.rm.contains(vocabularyList[index].word))
                          const Positioned(
                              top: 25,
                              right: 30,
                              child: Icon(
                                Icons.check,
                                size: 15,
                              )),
                      ]),
                      onLongPress: () {
                        if (widget.tp.user_id != 0) {
                          widget.removeState = 1;
                          widget.rm.add(vocabularyList[index].word);
                        }
                        setState(() {});
                      },
                      onTap: () {
                        if (widget.removeState == 1) {
                          if (widget.rm.contains(vocabularyList[index].word)) {
                            widget.rm.remove(vocabularyList[index].word);
                          } else {
                            widget.rm.add(vocabularyList[index].word);
                          }
                        }
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            if (widget.tp.user_id != 0)
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    alignment: Alignment.topLeft,
                    //padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        // Hiển thị form như thông báo với ô nhập dữ liệu
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String word = '';
                            String meaning = '';
                            String type = 'Verb';

                            return AlertDialog(
                              title: const Text('Enter your vocabulary'),
                              content: Column(
                                children:[ TextField(
                                  onChanged: (value) {
                                    // Lắng nghe sự kiện thay đổi giá trị trong ô nhập dữ liệu
                                    word = value;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Enter the word...',
                                  ),
                                ),
                                  TextField(
                                    onChanged: (value) {
                                      // Lắng nghe sự kiện thay đổi giá trị trong ô nhập dữ liệu
                                      meaning = value;

                                    },
                                    decoration:  const InputDecoration(
                                      hintText: 'Enter the meaning...',
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      //const Text('Select the type:',style: TextStyle(fontSize: 18),),
                                      //const SizedBox(width: 15,),
                                      DropdownButton<String>(
                                        value: type,
                                        onChanged: (String? value) {
                                          // Handle the selected value (value may be null if nothing is selected)
                                          if (value != null) {
                                            setState(() {
                                              type = value;
                                            });
                                          }
                                        },
                                        items: ['Verb', 'Noun', 'Adjective','Adverb']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  )
                                ]
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    // Đóng thông báo khi nhấn nút và trả về dữ liệu nhập
                                    List<String> l = [];
                                    l.add(word);
                                    l.add(type);
                                    l.add(meaning);
                                    Navigator.of(context).pop(l);
                                  },
                                  child: Text('Confirm'),
                                ),
                              ],
                            );
                          },
                        ).then((result) {
                          // Xử lý dữ liệu nhập từ ô nhập khi thông báo đóng
                          String t='';
                          if(result[1]=='Verb') t = "v";
                          if(result[1]=='Noun') t = "n";
                          if(result[1]=='Adjective') t = "adj";
                          if(result[1]=='Adverb') t = "adv";

                          if(result[0] != "" && result[2]!=""){
                          Vocabulary v = Vocabulary(word: result[0], meaning: result[2],type: t);
                          addVocabulary(widget.token, widget.tp.id, v);
                          getData(widget.token, widget.tp.id);
                          }
                        }
                        );
                      },
                      child: const Text('Add your vocabulary'),
                    ),
                  ),
                ),
              ]
            ),
            ),
      ),


      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             if(widget.removeState ==0)
              ElevatedButton(
                onPressed: () {
                  if(vocabularyList.isNotEmpty)
                  Navigator.push(context,MaterialPageRoute(
                      builder: (c) =>FlashCardPage(widget.token, widget.tp.id)));},
                child: const Text('Learn with flashcard'),
              )
            else
            ElevatedButton(
              onPressed: () {
                for (String v in widget.rm){
                      deleteVocabulary(widget.token, v);
                }
                widget.removeState =0;
                widget.rm=[];
                getData(widget.token, widget.tp.id);
                },
              child: const Text('Delete'),
            ),

            if(widget.removeState ==0)
            ElevatedButton(
              onPressed: () {
                // Handle the second button click
                if(vocabularyList.isNotEmpty)
                Navigator.push(context,MaterialPageRoute(
                    builder: (c) =>QuizPage(widget.token, widget.tp,1)));
              },
              child: const Text('Test'),
            )
            else
              ElevatedButton(
                onPressed: () {
                  widget.removeState =0;
                  widget.rm=[];
                  setState(() {

                  });
                },
                child: const Text('Cancel'),
              )
          ],
        ),
      ),
    );
  }
}


