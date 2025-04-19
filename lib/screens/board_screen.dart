import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tavla/model/piece.dart';
import 'package:tavla/utils/game_utils.dart';
import 'package:tavla/widgets/cell_widget.dart';
import 'package:tavla/widgets/dice_widget.dart';
import 'package:tavla/widgets/piece_widget.dart';

enum PlayerTurn { none, player1, player2 }

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  late List<Piece> whitePieces; // beyaz taslarin arrayi
  late List<Piece> blackPieces; // siyah taslarin arrayi

  int diceA = 0;
  int diceB = 0;
  List<int> diceValuesToPlay = [];
  bool isRolling = false;
  Timer? timer;
  double diceSizeCoeficient = 1.0;

  int fromIndex = -1; // nereden
  int toIndex = -1; // nereye

  int player1Score = 0;
  int player2Score = 0;

  PlayerTurn playerTurn = PlayerTurn.none;

  bool didPlayerRolledDice = false;

  String statusText = '';

  @override
  void initState() {
    super.initState();
    bearOffPieces(); // taslari topla
    checkGameState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
                  // dinamik olarak genislik bilgisini `width` parametresine sagliyor
                  // cellWidth -> bir hucrenin genisligi
                  return Container(
                    color: Colors.brown.shade300,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // MARK: Board Display
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
                                          onCellTap(11 - i);
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
                                          onCellTap(12 + i);
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
                                          onCellTap(5 - i);
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
                                    // sag alt ucgen
                                    Positioned(
                                      bottom: 0,
                                      child: CellWidget(
                                        cellIndex: 18 + i,
                                        cellWidth: cellWidth,
                                        isUp: false,
                                        onTap: () {
                                          onCellTap(18 + i);
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
                                  // PLAYER 2
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      color: Colors.green,
                                      width: double.infinity,
                                      height: cellWidth * 2,
                                      child: Column(
                                        children: [
                                          Text(
                                            '${playerTurn == PlayerTurn.player2 ? '--> ' : ''}PLAYER 2',
                                          ),
                                          Text(player2Score.toString()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // ustte toplanan taslar
                                  ...cellContent(
                                    index: 26,
                                    cellWidth: cellWidth,
                                  ),

                                  // ust rakam
                                  // Positioned(top: 0, child: Text('26')),
                                  Center(child: Text('$statusText')),

                                  // PLAYER 1
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      color: Colors.green,
                                      width: double.infinity,
                                      height: cellWidth * 2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(player2Score.toString()),
                                          Text(
                                            '${playerTurn == PlayerTurn.player1 ? '--> ' : ''}PLAYER 1',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // altta toplanan taslar
                                  ...cellContent(
                                    index: 27,
                                    cellWidth: cellWidth,
                                  ),
                                  // alltaki rakam
                                  // Positioned(bottom: 0, child: Text('27')),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // MARK: Dice Display
                        Align(
                          alignment: Alignment(0.3, 0),
                          child: GestureDetector(
                            onTap: rollDice,
                            child: SizedBox(
                              width: cellWidth * 3,
                              height: cellWidth * 2,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment(-0.5, -0.7),
                                    child: Transform.rotate(
                                      angle: -12 * pi / 180,
                                      child: DiceWidget(
                                        value: diceA,
                                        size: cellWidth * diceSizeCoeficient,
                                      ),
                                    ),
                                  ),

                                  Align(
                                    alignment: Alignment(0.7, 0.4),
                                    child: Transform.rotate(
                                      angle: 10 * pi / 180,
                                      child: DiceWidget(
                                        value: diceB,
                                        size: cellWidth * diceSizeCoeficient,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            color: Colors.yellow.withValues(alpha: 0.9),
                            child: Row(
                              spacing: 14,
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
                                Text('F: $fromIndex, T: $toIndex'),

                                Text('Sira kimde: ${playerTurn.name}'),
                                Text('A: $diceA, B: $diceB'),
                                Text('Moves: ${diceValuesToPlay.join(', ')}'),
                                ElevatedButton(
                                  onPressed: rollDice,
                                  child: Text('Roll Dice'),
                                ),
                              ],
                            ),
                          ),
                        ),
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
    checkGameState();
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
    checkGameState();
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
      checkGameState();
    }
  }

  void rollDice() {
    checkGameState();
    if (isRolling) {
      return;
    }

    Random random = Random();

    int totalRollStep = 20;
    int stepDuration = 50;
    int currentStep = 0;
    double maxDiceSizeCoeficient = 1.1;
    double sizeStep = (maxDiceSizeCoeficient - 1) / (totalRollStep / 2);
    setState(() {
      isRolling = true;
      diceSizeCoeficient = 1;
      diceValuesToPlay = [];
      diceA = 0;
      diceB = 0;
    });

    timer = Timer.periodic(Duration(milliseconds: stepDuration), (t) {
      if (currentStep > (totalRollStep / 2)) {
        setState(() {
          diceSizeCoeficient -= sizeStep;
        });
      } else {
        setState(() {
          diceSizeCoeficient += sizeStep;
        });
      }

      if (currentStep < totalRollStep) {
        currentStep++;
        setState(() {
          diceA = random.nextInt(6) + 1;
          diceB = random.nextInt(6) + 1;
        });
      } else {
        setState(() {
          diceA = random.nextInt(6) + 1;
          diceB = random.nextInt(6) + 1;
          diceValuesToPlay =
              diceA == diceB
                  ? List.generate(4, (index) => diceA)
                  : [diceA, diceB];
          isRolling = false;
          diceSizeCoeficient = 1;

          if (playerTurn != PlayerTurn.none) {
            didPlayerRolledDice = true;
          }
        });
        checkGameState();
        t.cancel();
      }
    });
  }

  void checkGameState() {
    // oyun bittimi
    // tum beyaz taslar 26 da ya da tum siyah taslar 27 de ise oyun bitmistir.

    if (whitePieces.every((e) => e.position == 26)) {
      // beyaz kazanir

      setState(() {
        statusText = 'Beyaz kazandi';
        playerTurn = PlayerTurn.none;
        player2Score++;
      });

      performNextRound();
      return;
    }

    if (blackPieces.every((e) => e.position == 27)) {
      // siyah kazanir

      setState(() {
        statusText = 'Siyah kazandi';
        playerTurn = PlayerTurn.none;
        player1Score++;
      });

      performNextRound();
      return;
    }

    if (playerTurn == PlayerTurn.none) {
      // sira hickimsede
      // baslangic
      // zar bekliyor
      if (diceA == diceB) {
        // tekrar zar bekliyor
        setState(() {
          statusText = 'Baslamak icin zar atiniz';
        });
      } else {
        if (diceA > diceB) {
          setState(() {
            playerTurn = PlayerTurn.player1;
            statusText = 'Oyuncu 1 basla';
          });
        } else {
          setState(() {
            playerTurn = PlayerTurn.player2;
            statusText = 'Oyuncu 2 basla';
          });
        }
      }
    } else {
      // zar atildi mi
      if (didPlayerRolledDice) {
        //tum hamleler oynandi mi
        if (diceValuesToPlay.isEmpty) {
          // oynandi
          // sirayi diger oyuncuya gecir
          setState(() {
            playerTurn =
                playerTurn == PlayerTurn.player1
                    ? PlayerTurn.player2
                    : PlayerTurn.player1;
            statusText =
                'Oyuncu ${playerTurn == PlayerTurn.player1 ? 1 : 2} için zar bekleniyor';
            didPlayerRolledDice = false;
          });
        } else {
          // oynanmayan hamle var
          setState(() {
            statusText =
                'Oyuncu ${playerTurn == PlayerTurn.player1 ? 1 : 2} için hamle bekleniyor, hamleler: ${diceValuesToPlay.join(',')}';
          });
          // oyuncuyu bekle
        }
      } else {
        // zar atilmasini bekle
        setState(() {
          statusText =
              'Oyuncu ${playerTurn == PlayerTurn.player1 ? 1 : 2} için zar bekleniyor';
        });
      }
    }
  }

  Future<void> performNextRound() async {
    // taslari sifirla
    resetPieces();
    // yeni oyuna basla
  }

  void onCellTap(int index) {
    if (playerTurn == PlayerTurn.player1) {
      if (diceValuesToPlay.isNotEmpty) {
        if (fromIndex < 0) {
          // henuz ilk click yok
          if (whitePieces.where((e) => e.position == index).isNotEmpty) {
            // tas var
            setState(() {
              fromIndex = index;
              toIndex = -1;

              // oynanabilecek diger index deki ucgenin rengini degistir
            });
          } else {
            // bos ya da rakip
            print('tiklanmaz');
          }
        } else {
          // ikinci yok
          for (final d in diceValuesToPlay) {
            if (index == fromIndex + d) {
              // izin var
              setState(() {
                toIndex = index;
                diceValuesToPlay.remove(d);
              });
              movePiece();
              break;
            } else {
              print('gecersiz hamle');
              setState(() {
                toIndex = -1;
              });
            }
          }
        }
      }
      //
    } else if (playerTurn == PlayerTurn.player2) {
      if (diceValuesToPlay.isNotEmpty) {
        // oynanabilecek hamle mevcut mu

        // hamle yok ise sira rakibe gecer

        // hamle mevcut oynamasini bekle
        if (fromIndex < 0) {
          // henuz ilk click yok
          if (blackPieces.where((e) => e.position == index).isNotEmpty) {
            // tas var
            setState(() {
              fromIndex = index;
              toIndex = -1;
            });
          } else {
            // bos ya da rakip
            print('tiklanmaz');
            setState(() {
              fromIndex = -1;
              toIndex = -1;
            });
          }
        } else {
          // ikinci yok
          for (final d in diceValuesToPlay) {
            if (index == fromIndex - d) {
              // hedefte rakip 1 tas var mi
              // izin var ve rakip tasi kir

              // hedefte rakip 1den fazla tas var mi
              // izin yok

              // hedef bos mu izin var
              setState(() {
                toIndex = index;
                diceValuesToPlay.remove(d);
              });
              movePiece();
              break;
            } else {
              print('gecersiz hamle');
              setState(() {
                toIndex = -1;
              });
            }
          }
        }
      }
    }

    // if (fromIndex >= 0) {
    //   // ikinci tik
    //   setState(() {
    //     toIndex = index;
    //   });
    //   //movePiece();
    // } else {
    //   // birinci tik
    //   setState(() {
    //     fromIndex = index;
    //     toIndex = -1;
    //   });
    // }
  }
}
