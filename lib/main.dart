import 'package:flutter/material.dart';

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

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int zoneCountInOneRegion = 6;
    return Row(
      spacing: 20,
      children: [
        for (int i = 0; i < zoneCountInOneRegion; i++)
          Expanded(
            child: Container(
              width: 20,
              height: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.red,
                    height: 150,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10,
                          left: 6,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 36,
                          left: 6,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 62,
                          left: 6,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 88,
                          left: 6,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 114,
                          left: 6,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        Positioned(
                          top: 15,
                          left: 12,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.red,
                    height: 150,
                  ),
                ],
              ),
            ),
          ),

        Container(color: Colors.yellow, width: 60, height: double.infinity),
        for (int i = 0; i < zoneCountInOneRegion; i++)
          Expanded(
            child: Container(
              width: 20,
              height: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.red,
                    height: 150,
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.red,
                    height: 150,
                  ),
                ],
              ),
            ),
          ),
        Container(color: Colors.yellow, width: 60, height: double.infinity),
        Container(width: 120, height: double.infinity),
      ],
    );
  }
}
