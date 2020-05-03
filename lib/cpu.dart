import 'dart:math';

import 'board.dart';
import 'coordinate.dart';
import 'match_page.dart';

abstract class Cpu {
  final Color color;
  final Random _random = Random(DateTime.now().millisecond);

  Cpu(this.color);

  Color get otherPlayer => color == Color.RED ? Color.YELLOW : Color.RED;

  Future<int> chooseCol(Board board);
}

class DumbCpu extends Cpu {
  DumbCpu(Color player) : super(player);

  Color get otherPlayer => color == Color.RED ? Color.YELLOW : Color.RED;

  @override
  Future<int> chooseCol(Board board) async {
    await Future.delayed(Duration(seconds: _random.nextInt(2)));
    int col = _random.nextInt(7);

    return col;
  }

  @override
  String toString() => 'DUMB CPU';
}

class HarderCpu extends Cpu {
  HarderCpu(Color player) : super(player);

  @override
  Future<int> chooseCol(Board board) async {
    final List<double> scores = List.filled(7, 0);

    await Future.delayed(Duration(seconds: 1 + _random.nextInt(2)));
    return _compute(board, 0, 1, scores);
  }

  int _compute(Board board, int step, int deepness, List<double> scores) {
    for (var i = 0; i < 7; ++i) {
      final boardCopy = board.clone();

      final target = boardCopy.getColumnTarget(i);
      if (target == -1) {
        scores[i] = null;
        continue;
      }

      final coordinate = Coordinate(i, target);

      boardCopy.setBox(coordinate, color);
      if (boardCopy.checkWinner(coordinate, color)) {
        scores[i] += deepness / (step + 1);
        continue;
      }

      for (var j = 0; j < 7; ++j) {
        final target = boardCopy.getColumnTarget(j);
        if (target == -1) {
          continue;
        }

        final coordinate = Coordinate(j, target);

        boardCopy.setBox(coordinate, otherPlayer);
        if (boardCopy.checkWinner(coordinate, otherPlayer)) {
          scores[i] -= deepness / (step + 1);
          continue;
        }

        if (step + 1 < deepness) {
          _compute(board, step + 1, deepness, scores);
        }
      }
    }

    return _getBestScoreIndex(scores);
  }

  int _getBestScoreIndex(List<double> scores) {
    int bestScoreIndex = scores.indexWhere((s) => s != null);
    scores.asMap().forEach((index, score) {
      if (score != null &&
          (score > scores[bestScoreIndex] ||
              (score == scores[bestScoreIndex] && _random.nextBool()))) {
        bestScoreIndex = index;
      }
    });
    return bestScoreIndex;
  }

  @override
  String toString() => 'HARDER CPU';
}

class HardestCpu extends HarderCpu {
  HardestCpu(Color player) : super(player);

  @override
  Future<int> chooseCol(Board board) async {
    final List<double> scores = List.filled(7, 0);

    await Future.delayed(Duration(seconds: 2 + _random.nextInt(2)));
    return _compute(board, 0, 4, scores);
  }

  @override
  String toString() => 'HARDEST CPU';
}
