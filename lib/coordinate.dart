class Coordinate {
  final int row, col;

  Coordinate(
    this.col,
    this.row,
  );

  Coordinate copyWith({
    int col,
    int row,
  }) =>
      Coordinate(
        col ?? this.col,
        row ?? this.row,
      );
}
