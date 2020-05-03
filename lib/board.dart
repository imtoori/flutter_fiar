import 'package:flutterfiar/coordinate.dart';

import 'match_page.dart';

class Board {
  List<List<Color>> _boxes = List.generate(
    7,
    (i) => List.generate(
      7,
      (i) => null,
    ),
  );

  Board();

  Board.from(List<List<Color>> boxes) {
    _boxes = boxes;
  }

  Color getBox(Coordinate coordinate) => _boxes[coordinate.col][coordinate.row];

  int getColumnTarget(int col) => _boxes[col].lastIndexOf(null);

  void setBox(Coordinate coordinate, Color player) =>
      _boxes[coordinate.col][coordinate.row] = player;

  void reset() {
    _boxes.forEach((r) => r.forEach((p) => p = null));
  }

  bool checkWinner(Coordinate coordinate, Color player) {
    return checkHorizontally(coordinate, player) ||
        checkVertically(coordinate, player) ||
        checkDiagonally(coordinate, player);
  }

  bool checkHorizontally(Coordinate coordinate, Color player) {
    var r = 0;
    for (;
        coordinate.col + r < 7 &&
            r < 4 &&
            getBox(coordinate.copyWith(col: coordinate.col + r)) == player;
        ++r) {}
    if (r >= 4) {
      return true;
    }

    var l = 0;
    for (;
        coordinate.col - l >= 0 &&
            l < 4 &&
            getBox(coordinate.copyWith(col: coordinate.col - l)) == player;
        ++l) {}
    if (l >= 4 || l + r >= 5) {
      return true;
    }

    return false;
  }

  bool checkDiagonally(Coordinate coordinate, Color player) {
    var ur = 0;
    for (;
        coordinate.col + ur < 7 &&
            coordinate.row + ur < 7 &&
            ur < 4 &&
            getBox(coordinate.copyWith(
                  col: coordinate.col + ur,
                  row: coordinate.row + ur,
                )) ==
                player;
        ++ur) {}
    if (ur >= 4) {
      return true;
    }
    var dl = 0;
    for (;
        coordinate.col - dl >= 0 &&
            coordinate.row - dl >= 0 &&
            dl < 4 &&
            getBox(coordinate.copyWith(
                  col: coordinate.col - dl,
                  row: coordinate.row - dl,
                )) ==
                player;
        ++dl) {}
    if (dl >= 4 || dl + ur >= 5) {
      return true;
    }

    var dr = 0;
    for (;
        coordinate.col + dr < 7 &&
            coordinate.row - dr >= 0 &&
            dr < 4 &&
            getBox(coordinate.copyWith(
                  col: coordinate.col + dr,
                  row: coordinate.row - dr,
                )) ==
                player;
        ++dr) {}
    if (dr >= 4) {
      return true;
    }

    var ul = 0;
    for (;
        coordinate.col - ul >= 0 &&
            coordinate.row + ul < 7 &&
            ul < 4 &&
            getBox(coordinate.copyWith(
                  col: coordinate.col - ul,
                  row: coordinate.row + ul,
                )) ==
                player;
        ++ul) {}
    if (ul >= 4 || dr + ul >= 5) {
      return true;
    }
    return false;
  }

  bool checkVertically(Coordinate coordinate, Color player) {
    var u = 0;
    for (;
        coordinate.row + u < 7 &&
            u < 4 &&
            getBox(coordinate.copyWith(
                  row: coordinate.row + u,
                )) ==
                player;
        ++u) {}
    if (u >= 4) {
      return true;
    }
    var d = 0;
    for (;
        coordinate.row - d >= 0 &&
            d < 4 &&
            getBox(coordinate.copyWith(
                  row: coordinate.row - d,
                )) ==
                player;
        ++d) {}
    if (d >= 4 || d + u >= 5) {
      return true;
    }

    return false;
  }

  Board clone() {
    return Board.from(_boxes.map((c) => c.map((b) => b).toList()).toList());
  }
}
