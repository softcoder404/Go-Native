import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:speech_to_text_plugins/speech_to_text_plugins.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _suggestions = [];
  String _tapText = "Tap to start speaking";
  String _msg = "";
  final _textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _textController.text = "";
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[700],
          title: const Text('Go Native'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        SpeechToTextPlugins speechToTextPlugins =
                            SpeechToTextPlugins();
                        speechToTextPlugins.activate().then((onValue) {
                          print(onValue);
                          onValue
                              ? setState(() {
                                  _tapText = "Start speaking....";
                                })
                              : setState(() {
                                  _tapText = "Tap again to start speaking";
                                });
                        });
                        speechToTextPlugins.listen().then((onValue) {
                          print(onValue);
                          setState(() {
                            _tapText = "Tap again to start speaking";
                            _suggestions.clear();
                            onValue.forEach((text) => _suggestions.add(text));
                          });
                        });
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.0),
                          image: DecorationImage(
                            image: AssetImage("assets/images/speak.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Text(_tapText),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
            if (_suggestions.length > 0) suggestionResult(),
            Expanded(
              child: Container(),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5.0),
              decoration: BoxDecoration(
                color: Colors.red[700],
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: TextField(
                style:
                    TextStyle(color: Colors.white, fontSize: 20.0, height: 1.2),
                cursorColor: Colors.white,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _msg = _textController.text;
                          });
                        },
                        icon: Icon(Icons.send, color: Colors.white)),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.message, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget suggestionResult() {
    return Column(
      children: [
        Container(
          child: Text(
            'Pls tap on the correct sentence',
            style: TextStyle(fontSize: 16.0, color: Colors.redAccent),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children: [
            ..._suggestions
                .map((text) => Container(
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      margin: EdgeInsets.all(10),
                      child: Text(text),
                    ))
                .toList(),
          ],
        ),
      ],
    );
  }
}
