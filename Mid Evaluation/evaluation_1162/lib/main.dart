import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MaterialApp(
    home: SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text(
              'DICEE',
              style: TextStyle(fontSize: 50),
            ),
            const SizedBox(
              height: 20,
            ),
            dice(count: 2),
            const SizedBox(
              height: 20,
            ),
            dice(count: 5),
            const SizedBox(
              height: 20,
            ),
            dice(count: 6),
          ],
        ),
      ),
    )),
  ));
}

class dice extends StatefulWidget {
  int count;
  dice({Key? key, required this.count}) : super(key: key);

  @override
  State<dice> createState() => _diceState();
}

class _diceState extends State<dice> {
  double dice = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(
              () {
                dice = Random().nextInt(widget.count) + 1;
                final AudioCache player = AudioCache();
                player.play('assets_note1.wav');
              },
            );
          },
          child: Center(
            child: Image.asset(
              "Images/dice$dice.png",
              height: 150,
              width: 150,
            ),
          ),
        )
      ],
    );
  }
}
