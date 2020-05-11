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
List<String> _suggestions;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Go Native'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlatButton(
          child: Text("Speak"),
          onPressed: () {
            try {
              SpeechToTextPlugins speechToTextPlugins = SpeechToTextPlugins();
              speechToTextPlugins.activate().then((onValue) {
                print(onValue);
              });
              speechToTextPlugins.listen().then((onValue) {
                print(onValue);
               setState(() {
                 _suggestions.clear();
                  onValue.forEach((text)=>_suggestions.add(text));
               });
              });
            } on PlatformException {
              // platformVersion = 'Failed to get platform version.';
            }
          },
        ),

        Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children: [
            ..._suggestions.map((text)=>Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(text),
            )).toList(),
          ],
        )

          ],
        )
      ),
    );
  }
}
