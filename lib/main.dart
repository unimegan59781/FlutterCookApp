import 'package:app/services/databaseHandler.dart';
import '../dbModels.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:just_audio/just_audio.dart';

import 'package:flutter/material.dart';

import 'package:csv/csv.dart';

void main() => runApp(
      MaterialApp(

                 debugShowCheckedModeBanner: false, 
                 home: DisplayPage()),
      );

class DisplayPage extends StatefulWidget {
  @override
  State<DisplayPage> createState() => DisplayPageWidgetState();
}

class DisplayPageWidgetState extends State<DisplayPage> {
  late DatabaseHandler handler;
  int currentID = 1;
  late String previousID;
  late String lastID;
  late bool visable = false;
  final sound = AudioPlayer();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      await addTodb();
    });
    change(currentID);
  }

  void changeVis(int currentID) {
    if (currentID > 43) {
      visable = true;
    } else {
      visable = false;
    }
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/config.json');
  }

  Future<int> addTodb() async {
    final rawCSV = await rootBundle.loadString("assets/datafile.csv");
    List<List<dynamic>> csvLists = const CsvToListConverter().convert(rawCSV);
    List<CSVdb> csvList = [];
    for (var line in csvLists) {
      var csv = CSVdb(
          id: line[0],
          yes: line[1],
          no: line[2],
          statment: line[3],
          question: line[4]);
      csvList.add(csv);
    }
    return await handler.insertCSV(csvList);
  }

  Future<List<String>> change(int currentID) async {
    List<String> changeList = [];
    String statment = await handler.getDBvalue(currentID, 'statment');
    changeList.add(statment);
    String question = await handler.getDBvalue(currentID, 'question');
    changeList.add(question);
    if (currentID == 30) {
      await sound.setAsset(
          'assets/sounds/fishfriendaudio.mp3'); //if search found true set to it
    } else if (currentID == 44 || currentID == 46) {
      await sound.setAsset('assets/sounds/weirdaudio.mp3');
    } else if (currentID == 48 || currentID == 65) {
      await sound.setAsset('assets/sounds/soupaudio.mp3');
    } else if (currentID == 61) {
      await sound.setAsset('assets/sounds/moneyaudio.mp3');
    } else if (currentID == 67) {
      await sound.setAsset('assets/sounds/blenderaudio.mp3');
    } else if (currentID == 76) {
      await sound.setAsset('assets/sounds/gunaudio.mp3');
    } else if (currentID == 84) {
      await sound.setAsset('assets/sounds/tacoaudio.mp3');
    } else {
      sound.stop();
      await sound.setAsset('assets/sounds/foodartaudio.mp3');
    }
    if (currentID == 30 || currentID > 43) {
      sound.play();
    }
    return changeList;
  }

  String setImg(currentID) {
    String img = 'assets/images/startimg.png';
    String curID;
    if (currentID < 44) {
      img = 'assets/images/startimg.png';
    } else {
      curID = currentID.toString();
      img = 'assets/images/img$curID.png';
    }
    return img;
  }

  @override
  Widget build(BuildContext context) {
    final double screenW = MediaQuery.of(context).size.width;
    final double screenH = MediaQuery.of(context).size.height;
    late String statment;
    late String question;
    int nextID;
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.white,
            body: FutureBuilder(
                future: change(currentID),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  TextStyle titleS = const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 136, 8, 8));
                  TextStyle statmentS = const TextStyle(
                      fontSize: 22, color: Color.fromARGB(255, 202, 87, 87));
                  TextStyle questionS = const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 196, 30, 58));
                  ButtonStyle replayS = ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 105, 214, 120),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      textStyle: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ));
                  ButtonStyle backS = ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 86, 86),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                      textStyle: const TextStyle(
                          fontSize: 34, fontWeight: FontWeight.bold));
                  ButtonStyle yesS = ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 175, 0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ));
                  ButtonStyle noS = ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 71, 181, 206),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ));
                  if (snapshot.hasData == true) {
                    statment = snapshot.data![0];
                    question = snapshot.data![1];
                    changeVis(currentID);
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: screenH * 0.05, width: screenW),
                          SizedBox(
                              height: screenH * 0.05,
                              width: screenW,
                              child: Text('What to cook for dinner?',
                                  style: titleS, textAlign: TextAlign.center)),
                          SizedBox(
                              height: screenH * 0.41,
                              width: screenW,
                              child:
                                  Image(image: AssetImage(setImg(currentID)))),
                          SizedBox(
                              height: screenH * 0.17,
                              width: screenW,
                              child: Column(children: <Widget>[
                                // Only one of them is visible based on 'isMorning' condition
                                if (!visable) ...[
                                  Text(statment,
                                      style: statmentS,
                                      textAlign: TextAlign.center),
                                  Text(question,
                                      style: questionS,
                                      textAlign: TextAlign.center)
                                ] else ...[
                                  SizedBox(
                                    height: screenH * 0.02,
                                    width: screenW,
                                  ),
                                  Text(statment,
                                      style: questionS,
                                      textAlign: TextAlign.center),
                                ]
                              ])),
                          SizedBox(
                              height: screenH * 0.15,
                              width: screenW,
                              child: Visibility(
                                  visible: !visable,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            height: screenH * 0.08,
                                            width: screenW * 0.4,
                                            child: ElevatedButton(
                                              style: yesS,
                                              onPressed: () async {
                                                sound.stop();
                                                nextID =
                                                    await handler.getDBvalue(
                                                        currentID, 'yes');
                                                setState(() {
                                                  if (currentID > 1) {
                                                    lastID = previousID;
                                                  }
                                                  previousID = 'yes';
                                                  currentID = nextID;
                                                });
                                              },
                                              child: const Text('Yes'),
                                            )),
                                        SizedBox(width: screenW * 0.1),
                                        SizedBox(
                                            height: screenH * 0.08,
                                            width: screenW * 0.4,
                                            child: ElevatedButton(
                                              style: noS,
                                              onPressed: () async {
                                                sound.stop();
                                                nextID =
                                                    await handler.getDBvalue(
                                                        currentID, 'no');
                                                setState(() {
                                                  if (currentID > 1) {
                                                    lastID = previousID;
                                                  }
                                                  previousID = 'no';
                                                  currentID = nextID;
                                                });
                                              },
                                              child: const Text('No'),
                                            )),
                                      ]))),
                          SizedBox(
                              height: screenH * 0.1,
                              width: screenW,
                              child: Visibility(
                                  child: Column(
                                children: <Widget>[
                                  if (!visable && currentID > 1)
                                    SizedBox(
                                      height: screenH * 0.08,
                                      width: screenW * 0.6,
                                      child: ElevatedButton(
                                        style: backS,
                                        onPressed: () async {
                                          nextID = await handler.getDBvalue(
                                              previousID, currentID);
                                          setState(() {
                                            currentID = nextID;
                                            previousID = lastID;
                                          });
                                        },
                                        child: const Text('Back'),
                                      ),
                                    )
                                  else if (visable && currentID > 1)
                                    SizedBox(
                                      height: screenH * 0.08,
                                      width: screenW * 0.6,
                                      child: ElevatedButton(
                                        style: replayS,
                                        onPressed: () {
                                          sound.stop();
                                          setState(() {
                                            currentID = 1;
                                          });
                                        },
                                        child: const Text('Replay'),
                                      ),
                                    )
                                ],
                              ))),
                        ],
                      ),
                    );
                  } 
                  return const Center(
                      child: ListTile(contentPadding: EdgeInsets.all(8.0)));
                })));
  }
}
