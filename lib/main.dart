import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tavla/models/piece.dart';
import 'package:tavla/piece_widget.dart';
import 'package:tavla/triangle_painter.dart';

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

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  late List<Piece> whitePieces;
  late List<Piece> blackPieces;
  int _fromValue = -1;
  int _toValue = -1;
  int _hovering = -1;

  @override
  void initState() {
    super.initState();
    resetBoard();
  }

  void resetBoard() {
    _fromValue = -1;
    _toValue = -1;

    whitePieces = List.generate(
      15,
      (e) => Piece(
        id: e,
        position: calculateInitialPosition(e, true),
        isWhite: true,
      ),
    );
    blackPieces = List.generate(
      15,
      (e) => Piece(
        id: e,
        position: calculateInitialPosition(e, false),
        isWhite: false,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints.expand(),
          decoration: const BoxDecoration(color: Colors.brown),
        ),
        Center(
          child: AspectRatio(
            aspectRatio: 5 / 3,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.brown.shade300,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double width = constraints.maxWidth;
                  // double height = constraints.maxHeight;
                  double cellWidth = ((width / 16).ceil() - 1).toDouble();
                  double barWidth = cellWidth * 1;
                  double bearOffTrayWidth = cellWidth * 3;

                  return Row(
                    children: [
                      // MARK: LEFT SIDE
                      for (int i = 0; i < 6; i++)
                        Container(
                          width: cellWidth.toDouble(),
                          height: double.infinity,
                          color: Colors.brown.shade200,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_fromValue > 0) {
                                    setState(() {
                                      _toValue = 11 - i;
                                    });
                                    moveItem();
                                  } else {
                                    setState(() {
                                      _fromValue = 11 - i;
                                      _toValue = -1;
                                    });
                                  }
                                },
                                child: cellTriangle(
                                  cellWidth,
                                  true,
                                  index: 11 - i,
                                ),
                              ),
                              ...cellContent(11 - i, cellWidth, true),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Text('${11 - i}'),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_fromValue > 0) {
                                    setState(() {
                                      _toValue = 12 + i;
                                    });
                                    moveItem();
                                  } else {
                                    setState(() {
                                      _fromValue = 12 + i;
                                      _toValue = -1;
                                    });
                                  }
                                },
                                child: cellTriangle(
                                  cellWidth,
                                  false,
                                  index: 12 + i,
                                ),
                              ),
                              ...cellContent(12 + i, cellWidth, false),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text('${12 + i}'),
                              ),
                            ],
                          ),
                        ),
                      // MARK: BAR
                      Container(
                        width: barWidth.toDouble(),
                        height: double.infinity,
                        color: Colors.brown.shade300,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ...cellContent(24, barWidth, true),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text('24'),
                            ),

                            ...cellContent(25, barWidth, false),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Text('25'),
                            ),
                          ],
                        ),
                      ),
                      // MARK: RIGHT SIDE
                      for (int i = 0; i < 6; i++)
                        Container(
                          width: cellWidth.toDouble(),
                          height: double.infinity,
                          color: Colors.brown.shade200,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_fromValue > 0) {
                                    setState(() {
                                      _toValue = 5 - i;
                                    });
                                    moveItem();
                                  } else {
                                    setState(() {
                                      _fromValue = 5 - i;
                                      _toValue = -1;
                                    });
                                  }
                                },
                                child: cellTriangle(
                                  cellWidth,
                                  true,
                                  index: 5 - i,
                                ),
                              ),
                              ...cellContent(5 - i, cellWidth, true),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Text('${5 - i}'),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_fromValue > 0) {
                                    setState(() {
                                      _toValue = 18 + i;
                                    });
                                    moveItem();
                                  } else {
                                    setState(() {
                                      _fromValue = 18 + i;
                                      _toValue = -1;
                                    });
                                  }
                                },
                                child: cellTriangle(
                                  cellWidth,
                                  false,
                                  index: 18 + i,
                                ),
                              ),
                              ...cellContent(18 + i, cellWidth, false),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text('${18 + i}'),
                              ),
                            ],
                          ),
                        ),
                      // MARK: BEAR OFF
                      Container(
                        width: bearOffTrayWidth.toDouble(),
                        height: double.infinity,
                        color: Colors.brown.shade300,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ...cellContent(26, barWidth, true),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text('26'),
                            ),

                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Wrap(
                                    spacing: 4,
                                    children: [
                                      ElevatedButton(
                                        onPressed: onDevPressed,
                                        child: Text('random'),
                                      ),

                                      ElevatedButton(
                                        onPressed: resetBoard,
                                        child: Text('reset'),
                                      ),
                                      Text('$_fromValue -> $_toValue'),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            ...cellContent(27, barWidth, false),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Text('27'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  // MARK: Triangle
  Widget cellTriangle(double cellWidth, bool isTop, {required int index}) =>
      Align(
        alignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
        child: MouseRegion(
          onEnter: (event) {
            setState(() {
              _hovering = index;
            });
          },
          onExit: (event) {
            setState(() {
              _hovering = -1;
            });
          },
          child: RotatedBox(
            quarterTurns: !isTop ? 0 : 2,
            child: CustomPaint(
              size: Size(cellWidth.toDouble(), cellWidth * 4),
              painter:
                  index == _fromValue
                      ? HighlightedTrianglePainter()
                      : _hovering == index
                      ? HoveredTrianglePainter()
                      : TrianglePainter(),
            ),
          ),
        ),
      );

  // MARK: Content
  List<Widget> cellContent(int cellIndex, double cellWidth, bool isTop) {
    final List<Piece> whitesOnCell =
        whitePieces.where((piece) => piece.position == cellIndex).toList();
    final List<Piece> blacksOnCell =
        blackPieces.where((piece) => piece.position == cellIndex).toList();

    return [
      for (int i = 0; i < whitesOnCell.length; i++)
        Positioned(
          top:
              isTop
                  ? cellIndex == 26 || cellIndex == 27
                      ? (cellWidth * (i * 0.2))
                      : i < 5
                      ? cellWidth * (i * 0.55)
                      : (cellWidth * (3 * 0.55)) + (cellWidth * (i * 0.15))
                  : null,
          bottom:
              isTop
                  ? null
                  : cellIndex == 26 || cellIndex == 27
                  ? (cellWidth * (i * 0.2))
                  : i < 5
                  ? cellWidth * (i * 0.55)
                  : (cellWidth * (3 * 0.55)) + (cellWidth * (i * 0.15)),
          child: PieceWidget(
            // key: cellKeys['w$i'],
            size: cellWidth,
            piece: whitesOnCell[i],
          ),
        ),
      for (int i = 0; i < blacksOnCell.length; i++)
        Positioned(
          top:
              isTop
                  ? cellIndex == 26 || cellIndex == 27
                      ? (cellWidth * (i * 0.2))
                      : i < 5
                      ? cellWidth * (i * 0.55)
                      : (cellWidth * (3 * 0.55)) + (cellWidth * (i * 0.15))
                  : null,
          bottom:
              isTop
                  ? null
                  : cellIndex == 26 || cellIndex == 27
                  ? (cellWidth * (i * 0.2))
                  : i < 5
                  ? cellWidth * (i * 0.55)
                  : (cellWidth * (3 * 0.55)) + (cellWidth * (i * 0.15)),
          child: PieceWidget(
            // key: cellKeys['b$i'],
            size: cellWidth,
            piece: blacksOnCell[i],
          ),
        ),
    ];
  }

  int calculateInitialPosition(int index, bool isWhite) {
    if (!isWhite) {
      switch (index) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
          return 5;
        case 5:
        case 6:
        case 7:
          return 7;
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
          return 12;
        case 13:
        case 14:
          return 23;
        default:
          return 26;
      }
    } else {
      switch (index) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
          return 18;
        case 5:
        case 6:
        case 7:
          return 16;
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
          return 11;
        case 13:
        case 14:
          return 0;
        default:
          return 27;
      }
    }
  }

  int randomCell() => Random().nextInt(3);

  void onDevPressed() {
    //
    setState(() {
      for (int i = 0; i < whitePieces.length; i++) {
        whitePieces[i].position = randomCell();
      }
      for (int i = 0; i < blackPieces.length; i++) {
        blackPieces[i].position = randomCell() + 21;
      }
    });
  }

  void moveItem() {
    var whitePiecesOnFromCell = whitePieces.where(
      (piece) => piece.position == _fromValue,
    );
    var blackPiecesOnFromCell = blackPieces.where(
      (piece) => piece.position == _fromValue,
    );

    if (whitePiecesOnFromCell.isNotEmpty) {
      var piece = whitePiecesOnFromCell.first;
      int index = whitePieces.indexOf(piece);
      setState(() {
        whitePieces[index].position = _toValue;
        _fromValue = -1;
        _toValue = -1;
      });
    } else if (blackPiecesOnFromCell.isNotEmpty) {
      var piece = blackPiecesOnFromCell.first;
      int index = blackPieces.indexOf(piece);
      setState(() {
        blackPieces[index].position = _toValue;
        _fromValue = -1;
        _toValue = -1;
      });
    }
  }
}
