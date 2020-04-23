import 'package:flutter/material.dart';
import 'package:flutterfiar/home_page.dart';
import 'package:flutterfiar/match_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter fiar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/match': (context) => MatchPage(),
      },
    );
  }
}
