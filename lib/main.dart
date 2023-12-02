import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sentences Creator',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "FiraCode"
      ),
      home: const SentencePage(title: 'Sentence Creator For Words'),
    );
  }
}
