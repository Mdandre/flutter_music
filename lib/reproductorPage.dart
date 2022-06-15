import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music/reproductorController.dart';
import 'package:get/get.dart';
import 'package:kplayer/kplayer.dart';

class Reproductor extends StatefulWidget {
  const Reproductor({Key? key}) : super(key: key);

  @override
  State<Reproductor> createState() => _ReproductorState();
}

class _ReproductorState extends State<Reproductor> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReproductorController>(
      builder: (controller) {
        PlayerController playerAct = controller.players[controller.num];
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Player"),
          ),
          body: Column(
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
                  StreamBuilder(
                      stream: playerAct.streams.position,
                      builder: (context, AsyncSnapshot<Duration> snapsho) {
                        controller.reproduction(playerAct) == true ? setState(() {}) : null;
                        return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: CupertinoSlider(
                              activeColor: Colors.red,
                              value: controller.position,
                              min: 0,
                              max: 100,
                              onChangeStart: (double value) {
                                controller.changingPosition = true;
                              },
                              onChangeEnd: (double value) {
                                controller.changingPosition = false;
                              },
                              onChanged: (double value) {
                                setState(() {
                                  controller.positionVal = Duration(seconds: ((value / 100) * playerAct.duration.inSeconds).toInt());
                                  playerAct.position = controller.positionVal;
                                });
                              },
                            ));
                      }),
                  SizedBox(
                    width: 100,
                    child: StreamBuilder<Object>(
                        stream: playerAct.streams.status,
                        builder: (context, snapshot) {
                          return DefaultTextStyle(
                            style: const TextStyle(color: Colors.black38, fontSize: 12),
                            child: Column(
                              children: [
                                Text("${playerAct.position}"),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: DefaultTextStyle(
                      style: const TextStyle(color: Colors.black87),
                      child: StreamBuilder(
                        stream: playerAct.streams.position,
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
                      controller.changeSong(false);
                      setState(() {});
                    },
                  ),
                  GestureDetector(
                    child: DefaultTextStyle(
                      style: const TextStyle(color: Colors.black87),
                      child: StreamBuilder(
                        stream: playerAct.streams.position,
                        builder: (context, snapshot) {
                          return playerAct.playing
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
                      playerAct.toggle();
                      setState(() {});
                    },
                  ),
                  GestureDetector(
                    child: DefaultTextStyle(
                      style: const TextStyle(color: Colors.black87),
                      child: StreamBuilder(
                        stream: playerAct.streams.position,
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
                      controller.changeSong(true);
                      setState(() {});
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
                        "Duration: ${playerAct.duration}",
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "Volume: ${playerAct.volume * 100}",
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "Speed: ${playerAct.speed}",
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
