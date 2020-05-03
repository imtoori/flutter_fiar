import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterfiar/cpu.dart';

import 'match_page.dart';

class CpuLevelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FlatButton(
              color: Colors.yellow,
              child: Text(
                'DUMB',
                style: Theme.of(context)
                    .textTheme
                    .display2
                    .copyWith(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/match',
                  arguments: {
                    'mode': Mode.PVC,
                    'cpu':
                        DumbCpu(Random().nextBool() ? Color.RED : Color.YELLOW),
                  },
                );
              },
            ),
            FlatButton(
              color: Colors.red,
              child: Text(
                'HARD',
                style: Theme.of(context)
                    .textTheme
                    .display2
                    .copyWith(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/match',
                  arguments: {
                    'mode': Mode.PVC,
                    'cpu': HarderCpu(
                        Random().nextBool() ? Color.RED : Color.YELLOW),
                  },
                );
              },
            ),
            FlatButton(
              color: Colors.deepPurpleAccent,
              child: Text(
                'HARDEST',
                style: Theme.of(context)
                    .textTheme
                    .display2
                    .copyWith(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/match',
                  arguments: {
                    'mode': Mode.PVC,
                    'cpu': HardestCpu(
                        Random().nextBool() ? Color.RED : Color.YELLOW),
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
