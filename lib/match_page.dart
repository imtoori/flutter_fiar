import 'package:flutter/material.dart';

import 'hole_painter.dart';

enum Player {
  YELLOW,
  RED,
}

class MatchPage extends StatefulWidget {
  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> with TickerProviderStateMixin {
  List<List<Player>> board = List.generate(
    7,
    (i) => List.generate(
      7,
      (i) => null,
    ),
  );

  Player turn = Player.RED;
  List<List<Animation<double>>> translations = List.generate(
    7,
    (i) => List.generate(
      7,
      (i) => null,
    ),
  );

  Player winner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    buildPieces(),
                    buildBoard(),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: winner != null
                    ? Text(
                        '${winner == Player.RED ? 'RED' : 'YELLOW'} WINS',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .display3
                            .copyWith(color: Colors.white),
                      )
                    : Column(
                        children: <Widget>[
                          Text(
                            '${turn == Player.RED ? 'RED' : 'YELLOW'} SPEAKS',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Chip(color: turn),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GridView buildPieces() {
    return GridView.custom(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
      childrenDelegate: SliverChildBuilderDelegate(
        (context, i) {
          final col = i % 7;
          final row = i ~/ 7;

          if (board[col][row] == null) {
            return SizedBox();
          }

          return Chip(
            translation: translations[col][row],
            color: board[col][row],
          );
        },
        childCount: 49,
      ),
    );
  }

  GridView buildBoard() {
    return GridView.custom(
      padding: const EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
      shrinkWrap: true,
      childrenDelegate: SliverChildBuilderDelegate(
        (context, i) {
          final col = i % 7;

          return GestureDetector(
            onTap: () {
              if (winner == null) {
                putPiece(col, context);
              }
            },
            child: CustomPaint(
              size: Size(50, 50),
              painter: HolePainter(),
            ),
          );
        },
        childCount: 49,
      ),
    );
  }

  void putPiece(int col, BuildContext context) {
    final target = board[col].lastIndexOf(null);
    final color = turn;

    if (target == -1) {
      return;
    }

    final controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });

    setState(() {
      board[col][target] = turn;
      turn = turn == Player.RED ? Player.YELLOW : Player.RED;
    });

    translations[col][target] = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      curve: Curves.bounceOut,
      parent: controller,
    ))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.dispose();
        }
      });

    controller.forward().orCancel;

    if (checkWinner(col, target, color)) {
      showWinnerDialog(context, color);
    }
  }

  void showWinnerDialog(BuildContext context, Player player) {
    setState(() {
      winner = player;
    });

    Future.delayed(Duration(seconds: 5), () => Navigator.pop(context));
  }

  void resetBoard() {
    setState(() {
      winner = null;
      board = List.generate(
        7,
        (i) => List.generate(
          7,
          (i) => null,
        ),
      );
    });
  }

  bool checkWinner(int col, int target, Player color) {
    return checkHorizontal(col, target, color) ||
        checkVertical(col, target, color) ||
        checkDiagonally(col, target, color);
  }

  bool checkHorizontal(int col, int target, Player color) {
    var i = 0;
    for (; col + i < 7 && i < 4 && board[col + i][target] == color; ++i) {}
    if (i == 4) {
      return true;
    }
    for (i = 0;
        col - i >= 0 && i < 4 && board[col - i][target] == color;
        ++i) {}
    if (i == 4) {
      return true;
    }

    return false;
  }

  bool checkDiagonally(int col, int target, Player color) {
    var i = 0;
    for (;
        col + i < 7 &&
            target + i < 7 &&
            i < 4 &&
            board[col + i][target + i] == color;
        ++i) {}
    if (i == 4) {
      return true;
    }

    for (i = 0;
        col - i >= 0 &&
            target - i >= 0 &&
            i < 4 &&
            board[col - i][target - i] == color;
        ++i) {}
    if (i == 4) {
      return true;
    }

    for (i = 0;
        col + i < 7 &&
            target - i >= 0 &&
            i < 4 &&
            board[col + i][target - i] == color;
        ++i) {}
    if (i == 4) {
      return true;
    }

    for (i = 0;
        col - i >= 0 &&
            target + i < 7 &&
            i < 4 &&
            board[col - i][target + i] == color;
        ++i) {}
    if (i == 4) {
      return true;
    }

    return false;
  }

  bool checkVertical(int col, int target, Player color) {
    var i = 0;
    for (; target + i < 7 && i < 4 && board[col][target + i] == color; ++i) {}
    if (i == 4) {
      return true;
    }
    for (i = 0;
        target - i >= 0 && i < 4 && board[col][target - i] == color;
        ++i) {}
    if (i == 4) {
      return true;
    }

    return false;
  }
}

class Chip extends StatelessWidget {
  const Chip({
    Key key,
    this.translation,
    @required this.color,
  }) : super(key: key);

  final Animation<double> translation;
  final Player color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        transform: Matrix4.translationValues(
          0,
          ((translation?.value ?? 1) * 400) - 400,
          0,
        ),
        height: 40,
        width: 40,
        child: Material(
          shape: CircleBorder(),
          color: color == Player.RED ? Colors.red : Colors.yellow,
        ),
      ),
    );
  }
}
