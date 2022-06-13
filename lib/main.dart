import 'package:flutter/material.dart';

import 'app/signin/signin_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Where You At',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: SigninPage());
  }
}
