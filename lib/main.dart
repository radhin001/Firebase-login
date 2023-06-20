import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (BuildContext context) {
          return LoginDemo();
        },
      ),
    );
  }
}
  // child: Text(
                      //   snapshot.hasData ? formatTime(snapshot.data!) : '',
                      //   style: TextStyle(fontSize: 35),
                      // ),