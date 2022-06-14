import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  var player1 = Player.network("https://luan.xyz/files/audio/ambient_c_motion.mp3", autoPlay: false);
  var player2 = Player.network("https://luan.xyz/files/audio/nasa_on_a_mission.mp3", autoPlay: false);

  @override
  void initState() {
    super.initState();
  }

  bool _changingPosition = false;
  bool loading = false;
  Duration _position = Duration.zero;
  double get position {
    if (player1.duration.inSeconds == 0) {
      return 0;
    }
    if (_changingPosition) {
      return _position.inSeconds * 100 / player1.duration.inSeconds;
    } else {
      return player1.position.inSeconds * 100 / player1.duration.inSeconds;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      color: Colors.teal,
      theme: const CupertinoThemeData(
        primaryColor: Colors.teal,
        primaryContrastingColor: Colors.teal,
      ),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: StreamBuilder(
              stream: player1.streams.position,
              builder: (context, snapshot) {
                return Text(player1.status.toString());
              }),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: StreamBuilder(
                      stream: player1.streams.position,
                      builder: (context, snapshot) {
                        return CircularProgressIndicator(
                          strokeWidth: 1,
                          color: Colors.teal,
                          value: loading ? null : player1.position.inSeconds / max(player1.duration.inSeconds, 0.01),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: FloatingActionButton(
                      disabledElevation: 0,
                      elevation: 0,
                      focusElevation: 0,
                      hoverElevation: 0,
                      highlightElevation: 0,
                      backgroundColor: Colors.teal.withOpacity(0.1),
                      onPressed: () {
                        reproductor(player1, player2);
                      },
                      child: DefaultTextStyle(
                        style: const TextStyle(color: Colors.black87),
                        child: StreamBuilder(
                          stream: player1.streams.position,
                          builder: (context, snapshot) {
                            return player1.playing
                                ? const Icon(
                                    Icons.pause,
                                    color: Colors.teal,
                                    size: 80,
                                  )
                                : const Icon(
                                    Icons.play_arrow,
                                    color: Colors.teal,
                                    size: 80,
                                  );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                width: double.infinity,
                child: StreamBuilder(
                    stream: player1.streams.position,
                    builder: (context, AsyncSnapshot<Duration> snapshot) {
                      loading = false;
                      return CupertinoSlider(
                        activeColor: Colors.red,
                        value: position,
                        min: 0,
                        max: 100,
                        onChangeStart: (double value) {
                          _changingPosition = true;
                        },
                        onChangeEnd: (double value) {
                          _changingPosition = false;
                        },
                        onChanged: (double value) {
                          setState(() {
                            loading = true;
                            _position = Duration(seconds: ((value / 100) * player1.duration.inSeconds).toInt());
                            player1.position = _position;
                          });
                          var left = player1.duration.inSeconds - 2;
                          if (position == left) {
                            //player1.stop();
                            player2.play();
                            print("CAMBIO");
                          }
                        },
                      );
                    }),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                width: double.infinity,
                child: Row(
                  children: [
                    const Icon(Icons.volume_up),
                    Expanded(
                      child: StreamBuilder(
                        stream: player1.streams.position,
                        builder: (context, AsyncSnapshot<Duration> snapshot) {
                          return CupertinoSlider(
                            value: player1.volume * 100,
                            min: 0,
                            max: 100,
                            // label: player.volume.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                player1.volume = value / 100;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                width: double.infinity,
                child: Row(
                  children: [
                    const Icon(Icons.speed),
                    Expanded(
                      child: StreamBuilder(
                        stream: player1.streams.position,
                        builder: (context, AsyncSnapshot<Duration> snapshot) {
                          return CupertinoSlider(
                            value: player1.speed * 10,
                            min: 0,
                            max: 10,
                            divisions: 10,
                            onChanged: (double value) {
                              setState(() {
                                player1.speed = value / 10;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: DefaultTextStyle(
                  style: const TextStyle(color: Colors.black38, fontSize: 12),
                  child: Column(
                    children: [
                      Text("Duration: ${player1.duration}"),
                      Text("Position: ${player1.position}"),
                      Text("Volume: ${player1.volume * 100}"),
                      Text("Speed: ${player1.speed}"),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void reproductor(PlayerController player1, PlayerController player2) {
    StreamBuilder(
        stream: player1.streams.position,
        builder: (context, snapshot) {
          var left = player1.duration.inSeconds - 2;
          if (position == left) {
            //player1.stop();
            player2.toggle();
            print("CAMBIO");
          }
          throw 0;
        });

    player1.play();
    //subida de vol en 3 segundos
  }

  void cambio(PlayerController player1, PlayerController player2) {}
}
