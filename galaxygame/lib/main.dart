import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'galaxy.dart';

void main() {
  runApp(const GalaxyApp());
}

class GalaxyApp extends StatelessWidget {
  const GalaxyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: GameWidget(game: Galaxy()),
        ),
      ),
    );
  }
}
