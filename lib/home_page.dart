import 'dart:async';

import 'package:flappy_bird/barriers.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final containerKey1 = GlobalKey();
  final containerKey2 = GlobalKey();

  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  late double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;
  int score = 0;
  int highScore = 0;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });

    print(birdYaxis);
  }

  bool birdIsDead() {
    if (birdYaxis < -1 || birdYaxis > 1) {
      return true;
    } else
      return false;
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 70), (timer) async {
      time += 0.05;
      height = -4.9 * time * time + 2.5 * time;
      setState(() {
        birdYaxis = initialHeight - height;
      });

      if (birdIsDead()) {
        timer.cancel();
        gameHasStarted = false;
        await _showDialog();
      }

      setState(() {
        if (barrierXone < -2) {
          barrierXone += 3.5;
        } else {
          barrierXone -= 0.05;
        }
        if (barrierXtwo < -2) {
          barrierXtwo += 3.5;
        } else {
          barrierXtwo -= 0.05;
        }
      });
     /* if (barrierXone >= -0.25 && barrierXone <= 0.25) {
        if (birdYaxis <= -0.2 || birdYaxis >= 0.6) {
          // timer.cancel();
          // scoreTimer.cancel();
          gameHasStarted = false;
          // if (score > highScore) {
          //   highScore = score;
          //   await prefs.setInt(HIGH_SCORE_KEY, highScore);
          // }
          // await showDialog();
          setState(() {});
          await _showDialog();
        }
      }*/

      // if (barrierXone >= -0.25 && barrierXone <= 0.25) {
      //   if (birdYaxis <= -0.6 || birdYaxis >= 0.2) {
      //     // timer.cancel();
      //     // scoreTimer.cancel();
      //     gameHasStarted = false;
      //     // if (score > highScore) {
      //     //   highScore = score;
      //     //   await prefs.setInt(HIGH_SCORE_KEY, highScore);
      //     // }
      //     setState(() {});

      //     await _showDialog();
      //   }
      // }
    });
  }

  void restGame() {
    Navigator.pop(context);
    setState(() {
      birdYaxis = 0;
      gameHasStarted = false;
      time = 0;
      initialHeight = birdYaxis;
      barrierXone = 1;
      barrierXtwo = barrierXone + 1.5;
    });
  }

  Future<void> _showDialog() async {
    print('show dialog');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Center(
            child: Text(
              'G A M E O V E R',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          content: Text(
            'Score ' + score.toString(),
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            GestureDetector(
              onTap: restGame,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: EdgeInsets.all(7),
                  color: Colors.white,
                  child: Text(
                    'PLAY AGAIN',
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      }),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedContainer(
                    key: containerKey1,
                    alignment: Alignment(0, birdYaxis),
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: MyBird(),
                  ),
                  Container(
                    alignment: Alignment(0, -0.2),
                    child:
                        gameHasStarted ? Text('') : Text('T A P  T O  P L A Y'),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 200.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 200.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 150.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 250.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.green,
              height: 15,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'SCORE',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '$score',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'BEST SCORE',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '10',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
