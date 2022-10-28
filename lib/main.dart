import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(const FlappyBird());
}

class FlappyBird extends StatelessWidget {
  const FlappyBird({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}