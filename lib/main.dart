import 'package:flutter/material.dart';
import 'package:tavla/screens/board_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: GameScreen());
  }
}

enum GameState { idle, inProgress, completed }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameState gameState = GameState.inProgress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          gameState == GameState.idle
              ? const Text('Game Idle')
              : gameState == GameState.inProgress
              ? BoardScreen()
              : Text('Game Completed'),
    );
  }
}
