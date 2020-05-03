import 'package:flutter/material.dart';

import 'match_page.dart';

class GameChip extends StatelessWidget {
  const GameChip({
    Key key,
    this.translation,
    @required this.color,
  }) : super(key: key);

  final Animation<double> translation;
  final Color color;

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
          color: color == Color.RED ? Colors.red : Colors.yellow,
        ),
      ),
    );
  }
}
