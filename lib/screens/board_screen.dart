import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tavla/model/piece.dart';
import 'package:tavla/utils/game_utils.dart';
import 'package:tavla/widgets/cell_widget.dart';
import 'package:tavla/widgets/piece_widget.dart';
import 'package:tavla/widgets/dice_widget.dart';
import 'dart:math';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  late List<Piece> whitePieces; // beyaz taslarin arrayi
  late List<Piece> blackPieces; // siyah taslarin arrayi
  Timer? _diceRollTimer;

  int fromIndex = -1; // nereden
  int toIndex = -1; // nereye
  int diceA = 0;
  int diceB = 0;
  List<int> diceValuesToPlay = [];
  bool isRolling = false;
  double diceZoomCoefficient = 1;

  @override
  void initState() {
    super.initState();
    bearOffPieces(); // taslari topla
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.brown), // dis arkaplan rengi
        Center(
          // ortala
          child: AspectRatio(
            aspectRatio: 5 / 3, // en-boy oranini sabitler
            child: Container(
              padding: const EdgeInsets.all(20), // padding
              color: Colors.brown.shade300, // tahtanin cercevesi
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final cellWidth = width / 16;
                  final diceSize = cellWidth / 1.2;
                  // dinamik olarak genislik bilgisini `width` parametresine sagliyor
                  // cellWidth -> bir hucrenin genisligi
                  return Container(
                    color: Colors.brown.shade300,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Row(
                          children: [
                            // MARK: sol taraf
                            for (int i = 0; i < 6; i++)
                              Container(
                                color: Colors.brown.shade100,
                                width: cellWidth,
                                child: Stack(
                                  children: [
                                    // ust ucgen
                                    Positioned(
                                      top: 0,
                                      child: CellWidget(
                                        cellIndex: 11 - i,
                                        cellWidth: cellWidth,
                                        isUp: true,
                                        onTap: () {
                                          // bir ucgene tiklandiginda
                                          if (fromIndex >= 0) {
                                            // birinci tik yapilmis ve belirlenmis
                                            // ikinci tik yapilmamis
                                            setState(() {
                                              toIndex = 11 - i;
                                            });
                                            // tasi hareket ettir
                                            movePiece();
                                          } else {
                                            // birinci tik yapilamis
                                            setState(() {
                                              fromIndex =
                                                  11 -
                                                  i; // tiklanan ucgen indexi ile guncelle
                                              toIndex = -1; // sifirla
                                            });
                                          }
                                        },
                                      ),
                                    ),

                                    // ustteki taslar
                                    ...cellContent(
                                      index: 11 - i,
                                      cellWidth: cellWidth,
                                    ),
                                    // index text
                                    Positioned(
                                      top: 0,
                                      child: Text('${11 - i}'),
                                    ),

                                    // alt ucgen
                                    Positioned(
                                      bottom: 0,
                                      child: CellWidget(
                                        cellIndex: 12 + i,
                                        cellWidth: cellWidth,
                                        isUp: false,
                                        onTap: () {
                                          if (fromIndex >= 0) {
                                            // ikinci tik
                                            setState(() {
                                              toIndex = 12 + i;
                                            });
                                            movePiece();
                                          } else {
                                            // birinci tik
                                            setState(() {
                                              fromIndex = 12 + i;
                                              toIndex = -1;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    // alttaki taslar
                                    ...cellContent(
                                      index: 12 + i,
                                      cellWidth: cellWidth,
                                    ),
                                    // alttaki index text
                                    Positioned(
                                      bottom: 0,
                                      child: Text('${12 + i}'),
                                    ),
                                  ],
                                ),
                              ),
                            // MARK: orta cubuk
                            Container(
                              width: cellWidth,
                              color: Colors.brown.shade300,
                              child: Stack(
                                children: [
                                  ...cellContent(
                                    index: 24,
                                    cellWidth: cellWidth,
                                  ),
                                  Positioned(top: 0, child: Text('24')),

                                  ...cellContent(
                                    index: 25,
                                    cellWidth: cellWidth,
                                  ),
                                  Positioned(bottom: 0, child: Text('25')),
                                ],
                              ),
                            ),
                            // MARK: sag taraf
                            for (int i = 0; i < 6; i++)
                              Container(
                                color: Colors.brown.shade100,
                                width: cellWidth,
                                child: Stack(
                                  children: [
                                    // sag ust ucgenler
                                    Positioned(
                                      top: 0,
                                      child: CellWidget(
                                        cellIndex: 5 - i,
                                        cellWidth: cellWidth,
                                        isUp: true,
                                        onTap: () {
                                          if (fromIndex >= 0) {
                                            // ikinci tik
                                            setState(() {
                                              toIndex = 5 - i;
                                            });
                                            movePiece();
                                          } else {
                                            // birinci tik
                                            setState(() {
                                              fromIndex = 5 - i;
                                              toIndex = -1;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    // sag ust taslar
                                    ...cellContent(
                                      index: 5 - i,
                                      cellWidth: cellWidth,
                                    ),
                                    // sag ust index text
                                    Positioned(top: 0, child: Text('${5 - i}')),

                                    // Sag zar yeri
                                    // sag alt ucgen
                                    Positioned(
                                      bottom: 0,
                                      child: CellWidget(
                                        cellIndex: 18 + i,
                                        cellWidth: cellWidth,
                                        isUp: false,
                                        onTap: () {
                                          if (fromIndex >= 0) {
                                            // ikinci tik
                                            setState(() {
                                              toIndex = 18 + i;
                                            });
                                            movePiece();
                                          } else {
                                            // birinci tik
                                            setState(() {
                                              fromIndex = 18 + i;
                                              toIndex = -1;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    // sag alt taslar
                                    ...cellContent(
                                      index: 18 + i,
                                      cellWidth: cellWidth,
                                    ),
                                    // sag alt index text
                                    Positioned(
                                      bottom: 0,
                                      child: Text('${18 + i}'),
                                    ),
                                  ],
                                ),
                              ),
                            // MARK: toplanan yer ve skor
                            Container(
                              width: cellWidth * 3,
                              color: Colors.brown.shade300,
                              child: Stack(
                                children: [
                                  // ustte toplanan taslar
                                  ...cellContent(
                                    index: 26,
                                    cellWidth: cellWidth,
                                  ),
                                  // ust rakam
                                  Positioned(top: 0, child: Text('26')),
                                  // test butonlari
                                  Center(
                                    child: Column(
                                      spacing: 4,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton(
                                          onPressed: resetPieces,
                                          child: Text('basla'),
                                        ),
                                        ElevatedButton(
                                          onPressed: bearOffPieces,
                                          child: Text('topla'),
                                        ),
                                        ElevatedButton(
                                          onPressed: onDiceTap,
                                          child: Text('zar at'),
                                        ),
                                        Text('F: $fromIndex, T: $toIndex'),
                                        Text('Dice: $diceA, $diceB'),
                                        Text(
                                          'MovesLeft: ${diceValuesToPlay.join(', ')}',
                                        ),
                                      ],
                                    ),
                                  ),
                                  // altta toplanan taslar
                                  ...cellContent(
                                    index: 27,
                                    cellWidth: cellWidth,
                                  ),
                                  // alltaki rakam
                                  Positioned(bottom: 0, child: Text('27')),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // MARK: zarlar
                        Align(
                          alignment: Alignment(0.288, 0),
                          child: GestureDetector(
                            onTap: onDiceTap,
                            child: SizedBox(
                              width: cellWidth * 2,
                              height: cellWidth * 1.2,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment(-0.8, 0),
                                    child: Transform.rotate(
                                      angle: -15 * pi / 180,
                                      child: DiceWidget(
                                        value: diceA,
                                        size: diceSize * diceZoomCoefficient,
                                        isDisabled:
                                            !diceValuesToPlay.contains(diceA),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0.8, -0.8),
                                    child: Transform.rotate(
                                      angle: 10 * pi / 180,
                                      child: DiceWidget(
                                        value: diceB,
                                        size:
                                            diceSize *
                                            (diceZoomCoefficient *
                                                (isRolling ? 0.9 : 1)),
                                        isDisabled:
                                            !diceValuesToPlay.contains(diceB),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // ... rest of the code remains the same ...
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  // MARK: cell content
  List<Widget> cellContent({required int index, required double cellWidth}) {
    final whitePiecesOnThisIndex =
        whitePieces.where((e) => e.position == index).toList();

    final blackPiecesOnThisIndex =
        blackPieces.where((e) => e.position == index).toList();

    bool isTop = index < 12 || index == 24 || index == 26;
    double gap =
        cellWidth *
        (index == 24 || index == 25 || index == 26 || index == 27 ? 0.2 : 0.6);

    return [
      for (int i = 0; i < whitePiecesOnThisIndex.length; i++)
        Positioned(
          top: isTop ? (i * gap).toDouble() : null,
          bottom: isTop ? null : (i * gap).toDouble(),
          child: PieceWidget(cellWidth: cellWidth, isWhite: true),
        ),
      for (int i = 0; i < blackPiecesOnThisIndex.length; i++)
        Positioned(
          top: isTop ? (i * gap).toDouble() : null,
          bottom: isTop ? null : (i * gap).toDouble(),
          child: PieceWidget(cellWidth: cellWidth, isWhite: false),
        ),
    ];
  }

  // MARK: topla
  void bearOffPieces() {
    whitePieces = List.generate(
      15,
      (e) => Piece(isWhite: true, position: 26, isHighlighted: false),
    ); // 15 adet beyaz tas yaratip en sagda yerlestirir ve listeye ekler.

    blackPieces = List.generate(
      15,
      (e) => Piece(isWhite: false, position: 27, isHighlighted: false),
    ); // 15 adet siyah tas yaratip en sagda yerlestirir ve listeye ekler.
    fromIndex = -1; // nereden nereye bilgisini sifirlar
    toIndex = -1;
    setState(() {}); // sayfayi gunceller
  }

  // MARK: basla
  void resetPieces() {
    fromIndex = -1;
    toIndex = -1;
    for (int i = 0; i < whitePieces.length; i++) {
      // beyaz taslarin tumunu donguye sok
      var p = whitePieces[i];
      // siradakini tanesini sec
      int index = whitePieces.indexOf(p);
      // indexini bul

      // olmasi gereken pozisyon ile guncelle
      p.position = GameUtils.calculateInitialPosition(i, true);
      // listeye geri koy
      whitePieces.replaceRange(index, index + 1, [p]);
    }

    for (int i = 0; i < blackPieces.length; i++) {
      var p = blackPieces[i];
      int index = blackPieces.indexOf(p);
      p.position = GameUtils.calculateInitialPosition(i, false);

      blackPieces.replaceRange(index, index + 1, [p]);
    }

    setState(() {});
  }

  // MARK: movePiece
  void movePiece() {
    if (fromIndex > -1 && toIndex > -1) {
      // eger from-to bos degilse

      // from indexindeki beyaz taslar listesi
      var whitePiecesOnThisIndex =
          whitePieces.where((e) => e.position == fromIndex).toList();

      // from indexindeki siyah taslar listesi
      var blackPiecesOnThisIndex =
          blackPieces.where((e) => e.position == fromIndex).toList();

      // bir tas tanimla
      Piece? pieceToMove;
      // beyaz mi? su an belli degil
      bool isWhite = false;

      if (whitePiecesOnThisIndex.isNotEmpty) {
        // beyaz liste bos degilse
        // listedeki ilk tasi sec
        pieceToMove = whitePiecesOnThisIndex.first;
        isWhite = true;
      } else if (blackPiecesOnThisIndex.isNotEmpty) {
        // siyah liste bos degilse
        // listedeki ilk tasi sec
        pieceToMove = blackPiecesOnThisIndex.first;
        isWhite = false;
      } else {
        // iki listede bos ise tasi sil
        pieceToMove = null;
      }

      if (pieceToMove != null) {
        // tas varsa
        if (isWhite) {
          // beyaz ise

          // genel beyaz listesindeki kacinci tas
          int pieceIndex = whitePieces.indexOf(pieceToMove);

          // yeni pozisyonu guncelle (to)
          pieceToMove.position = toIndex;

          // genel beyaz listesine geri koy
          whitePieces.replaceRange(pieceIndex, pieceIndex + 1, [pieceToMove]);
        } else {
          // siyah ise

          // genel siyah listesindeki kacinci tas
          int pieceIndex = blackPieces.indexOf(pieceToMove);

          // yeni posizyonu guncelle (to)
          pieceToMove.position = toIndex;

          // listeye geri koy
          blackPieces.replaceRange(pieceIndex, pieceIndex + 1, [pieceToMove]);
        }
      }

      fromIndex = -1;
      toIndex = -1;
      setState(() {});
    }
  }

  // MARK: onDiceTap
  void onDiceTap() {
    // TODO: implement onDiceTap
    _diceRollTimer?.cancel();
    if (isRolling) return;
    setState(() {
      isRolling = true;
      diceValuesToPlay.clear();
    });
    final random = Random();
    int rollDuration = 750; // ms
    int interval = 50; // ms
    int elapsed = 0;
    double maxZoomValue = 1.3;
    int step = (rollDuration / interval).floor();
    double zoomStep = (maxZoomValue - 1) / (step / 2);

    _diceRollTimer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      setState(() {
        diceA = random.nextInt(6) + 1;
        diceB = random.nextInt(6) + 1;
        if ((rollDuration / 2) > elapsed) {
          //zoom in
          diceZoomCoefficient += zoomStep;
        } else {
          // zoom out
          diceZoomCoefficient -= zoomStep;
        }
        diceZoomCoefficient = diceZoomCoefficient.clamp(1, maxZoomValue);
      });
      elapsed += interval;
      if (elapsed >= rollDuration) {
        timer.cancel();
        setState(() {
          diceA = random.nextInt(6) + 1;
          diceB = random.nextInt(6) + 1;
          diceValuesToPlay =
              diceA == diceB ? List.generate(4, (e) => diceA) : [diceA, diceB];
          isRolling = false;
          diceZoomCoefficient = 1;
        });
      }
    });
  }
}
