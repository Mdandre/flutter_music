import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kplayer/kplayer.dart';

void main() {
  Player.boot();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<PlayerController> players = [
    Player.network("https://luan.xyz/files/audio/ambient_c_motion.mp3", autoPlay: true),
    Player.network("https://luan.xyz/files/audio/nasa_on_a_mission.mp3", autoPlay: false),
    Player.asset("/Users/marco/Development/BRANDTRACK/flutter_music/lib/assets/blue.mp3", autoPlay: false),
    Player.asset("/Users/marco/Development/BRANDTRACK/flutter_music/lib/assets/lig.mp3", autoPlay: false)
  ];
  var num = 0;

  bool _changingPosition = false;
  bool loading = false;
  Duration _position = Duration.zero;
  double get position {
    if (players[num].duration.inSeconds == 0) {
      return 0;
    }
    if (_changingPosition) {
      return _position.inSeconds * 100 / players[num].duration.inSeconds;
    } else {
      return players[num].position.inSeconds * 100 / players[num].duration.inSeconds;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void reproduction() {
    StreamBuilder(
        stream: players[num].streams.position,
        builder: (context, AsyncSnapshot<Duration> snapshot) {
          if (players[num].playing) if (players[num].position.inSeconds == players[num].duration.inSeconds - 2) {
            changeSong(true);
          }
          return const CircularProgressIndicator();
        });
  }

  void changeSong(bool isNext) {
    if (isNext != true) {
      setState(() {
        players[num].stop();
        if (num == 0) {
          num = players.length - 1;
        } else {
          num = num - 1;
        }
      });
      players[num].toggle();
      players[num].replay();
    } else {
      setState(() {
        players[num].stop();
        if (num == players.length - 1) {
          num = 0;
        } else {
          num = num + 1;
        }
      });
      players[num].toggle();
      players[num].replay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text("Player"),
            ),
            body: StreamBuilder(
              stream: players[num].streams.position,
              builder: (context, AsyncSnapshot<Duration> snapshot) {
                return Reproductor(
                  players: players[num],
                  position: _position,
                  positionC: position,
                  changingPosition: _changingPosition,
                );
              },
            )));
  }
}

class Reproductor extends StatelessWidget {
  Reproductor({Key? key, required this.players, required this.position, required this.positionC, required this.changingPosition}) : super(key: key);
  final PlayerController players;
  Duration position;
  final double positionC;
  bool changingPosition;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topCenter,
          child: const Icon(
            Icons.queue_music_outlined,
            size: 150,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CupertinoSlider(
                  activeColor: Colors.red,
                  value: positionC,
                  min: 0,
                  max: 100,
                  onChangeStart: (double value) {
                    changingPosition = true;
                  },
                  onChangeEnd: (double value) {
                    changingPosition = false;
                  },
                  onChanged: (double value) {
                    //setState(() {
                    //  loading = true;
                    position = Duration(seconds: ((value / 100) * players.duration.inSeconds).toInt());
                    players.position = position;
                    //});
                  },
                )),
            Container(
              width: 100,
              child: StreamBuilder<Object>(
                  stream: players.streams.status,
                  builder: (context, snapshot) {
                    return DefaultTextStyle(
                      style: const TextStyle(color: Colors.black38, fontSize: 12),
                      child: Column(
                        children: [
                          Text("${players.position}"),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: DefaultTextStyle(
                style: const TextStyle(color: Colors.black87),
                child: StreamBuilder(
                  stream: players.streams.position,
                  builder: (context, snapshot) {
                    return const Icon(
                      Icons.skip_previous_sharp,
                      color: Colors.black,
                      size: 50,
                    );
                  },
                ),
              ),
              onTap: () {
                // changeSong(false);
                // setState(() {});
              },
            ),
            GestureDetector(
              child: DefaultTextStyle(
                style: const TextStyle(color: Colors.black87),
                child: StreamBuilder(
                  stream: players.streams.position,
                  builder: (context, snapshot) {
                    return players.playing
                        ? const Icon(
                            Icons.pause,
                            color: Colors.black,
                            size: 50,
                          )
                        : const Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 50,
                          );
                  },
                ),
              ),
              onTap: () {
                //setState(() {
                players.toggle();
                // });
              },
            ),
            GestureDetector(
              child: DefaultTextStyle(
                style: const TextStyle(color: Colors.black87),
                child: StreamBuilder(
                  stream: players.streams.position,
                  builder: (context, snapshot) {
                    return const Icon(
                      Icons.skip_next_sharp,
                      color: Colors.black,
                      size: 50,
                    );
                  },
                ),
              ),
              onTap: () {
                // changeSong(true);
                // setState(() {});
              },
            ),
          ],
        ),
        Center(
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.black38, fontSize: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Duration: ${players.duration}",
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Volume: ${players.volume * 100}",
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Speed: ${players.speed}",
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
