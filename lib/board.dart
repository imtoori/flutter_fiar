import 'match_page.dart';

class Board {
  final List<List<Player>> _boxes = List.generate(
    7,
    (i) => List.generate(
      7,
      (i) => null,
    ),
  );

  Player getBox(int col, int row) => _boxes[col][row];

  int getColumnTarget(int col) => _boxes[col].lastIndexOf(null);

  void setBox(int col, int row, Player player) => _boxes[col][row] = player;

  void reset() {
    _boxes.forEach((r) => r.forEach((p) => p = null));
  }
}
