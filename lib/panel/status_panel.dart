import 'dart:async';

import 'package:flutter/material.dart';
import 'package:clear_bricks/gamer/block.dart';
import 'package:clear_bricks/gamer/gamer.dart';
import 'package:clear_bricks/generated/i18n.dart';
import 'package:clear_bricks/material/briks.dart';
import 'package:clear_bricks/material/images.dart';

class StatusPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(S.of(context)!.highscore, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          SizedBox(height: 4),
          Number(number: GameState.of(context)!.highscore),
          SizedBox(height: 4),
          Text(S.of(context)!.points, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          SizedBox(height: 4),
          Number(number: GameState.of(context)!.points),
          SizedBox(height: 10),
          Text(S.of(context)!.cleans, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          SizedBox(height: 4),
          Number(number: GameState.of(context)!.cleared),
          SizedBox(height: 10),
          Text(S.of(context)!.level, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          SizedBox(height: 4),
          Number(number: GameState.of(context)!.level),
          SizedBox(height: 10),
          Text(S.of(context)!.next, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          SizedBox(height: 4),
          _NextBlock(),
          Spacer(),
          _GameStatus(),
        ],
      ),
    );
  }
}

class _NextBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<List<int>> data = [List.filled(4, 0), List.filled(4, 0)];
    final next = BLOCK_SHAPES[GameState.of(context)!.next.type];
    for (int i = 0; i < next!.length; i++) {
      for (int j = 0; j < next[i].length; j++) {
        data[i][j] = next[i][j];
      }
    }
    return Column(
      children: data.map((list) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: list.map((b) {
            return b == 1 ? Brik.normal() : Brik.empty();
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _GameStatus extends StatefulWidget {
  @override
  _GameStatusState createState() {
    return new _GameStatusState();
  }
}

class _GameStatusState extends State<_GameStatus> {
  Timer? _timer;
  bool _colonEnable = true;
  int? minute;
  int? hour;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        _colonEnable = !_colonEnable;
        minute = now.minute;
        hour = now.hour;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconSound(enable: GameState.of(context)!.muted),
        SizedBox(width: 2),
        IconPause(enable: GameState.of(context)!.states == GameStates.paused),
        //  Spacer(),
        //  Number(number: _hour, length: 2, padWithZero: true),
        //  IconColon(enable: _colonEnable),
        //  Number(number: _minute, length: 2, padWithZero: true),
      ],
    );
  }
}
