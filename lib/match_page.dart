import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterfiar/coordinate.dart';

import 'board.dart';
import 'cpu.dart';
import 'game_chip.dart';
import 'hole_painter.dart';

enum Color {
  YELLOW,
  RED,
}

enum Mode {
  PVP,
  PVC,
  DEMO,
}

class MatchPage extends StatefulWidget {
  final Mode mode;
  final Cpu cpu;
  final Cpu cpu2;

  const MatchPage({
    Key key,
    this.mode,
    this.cpu,
    this.cpu2,
  }) : super(key: key);

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> with TickerProviderStateMixin {
  final board = Board();
  Color turn;
  Color winner;

  List<List<Animation<double>>> translations = List.generate(
    7,
    (i) => List.generate(
      7,
      (i) => null,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(
                constraints: BoxConstraints.loose(
                  Size(
                    500,
                    532,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Stack(
                    overflow: Overflow.clip,
                    fit: StackFit.loose,
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
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: winner != null
                    ? Text(
                        '${winner == Color.RED ? 'RED' : 'YELLOW'} WINS',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .display3
                            .copyWith(color: Colors.white),
                      )
                    : Column(
                        children: <Widget>[
                          Text(
                            '${turn == Color.RED ? 'RED' : 'YELLOW'} SPEAKS',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GameChip(color: turn),
                          ),
                          _buildPlayerName(context),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text _buildPlayerName(BuildContext context) {
    String name;

    if (widget.mode == Mode.PVC) {
      if (turn == widget.cpu.color) {
        name = 'CPU - ${widget.cpu.toString()}';
      } else {
        name = 'USER';
      }
    } else if (widget.mode == Mode.PVP) {
      if (turn == Color.RED) {
        name = 'PLAYER1';
      } else {
        name = 'PLAYER2';
      }
    } else {
      if (turn == widget.cpu.color) {
        name = 'CPU1 - ${widget.cpu.toString()}';
      } else {
        name = 'CPU2 - ${widget.cpu2.toString()}';
      }
    }
    return Text(
      name,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),
    );
  }

  @override
  void initState() {
    super.initState();
    turn = widget.cpu?.otherPlayer ??
        (Random().nextBool() ? Color.RED : Color.YELLOW);
    if (widget.mode == Mode.PVC && turn == widget.cpu.color) {
      cpuMove(widget.cpu);
    } else if (widget.mode == Mode.DEMO) {
      if (turn == widget.cpu.color) {
        cpuMove(widget.cpu);
      } else {
        cpuMove(widget.cpu2);
      }
    }
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

          if (board.getBox(Coordinate(col, row)) == null) {
            return SizedBox();
          }

          return GameChip(
            translation: translations[col][row],
            color: board.getBox(Coordinate(col, row)),
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
                userMove(col);
              }
            },
            child: CustomPaint(
              size: Size(50, 50),
              willChange: false,
              painter: HolePainter(),
            ),
          );
        },
        childCount: 49,
      ),
    );
  }

  void userMove(int col) {
    putChip(col);
    if (winner == null && widget.mode == Mode.PVC) {
      cpuMove(widget.cpu);
    }
  }

  void cpuMove(Cpu cpu) async {
    int col = await cpu.chooseCol(board);
    putChip(col);

    if (winner == null && widget.mode == Mode.DEMO) {
      if (turn == widget.cpu.color) {
        cpuMove(widget.cpu);
      } else {
        cpuMove(widget.cpu2);
      }
    }
  }

  void putChip(int col) {
    final target = board.getColumnTarget(col);
    final player = turn;

    if (target == -1) {
      return;
    }

    final controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

    if (mounted) {
      setState(() {
        board.setBox(Coordinate(col, target), turn);
        turn = turn == Color.RED ? Color.YELLOW : Color.RED;
      });
    }

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

    if (board.checkWinner(Coordinate(col, target), player)) {
      showWinnerDialog(context, player);
    }
  }

  void showWinnerDialog(BuildContext context, Color player) {
    setState(() {
      winner = player;
    });

    Future.delayed(
      Duration(seconds: 5),
      () => mounted ? Navigator.popUntil(context, (r) => r.isFirst) : null,
    );
  }

  void resetBoard() {
    setState(() {
      winner = null;
      board.reset();
    });
  }
}
