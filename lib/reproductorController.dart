import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:kplayer/kplayer.dart';

class ReproductorController extends GetxController {
  List<PlayerController> players = [
    Player.network("https://luan.xyz/files/audio/ambient_c_motion.mp3", autoPlay: true),
    Player.network("https://luan.xyz/files/audio/nasa_on_a_mission.mp3", autoPlay: false),
    Player.asset("/Users/marco/Development/BRANDTRACK/flutter_music/lib/assets/blue.mp3", autoPlay: false),
    Player.asset("/Users/marco/Development/BRANDTRACK/flutter_music/lib/assets/lig.mp3", autoPlay: false)
  ];

  var num = 0;
  bool changingPosition = false;
  bool loading = false;
  Duration positionVal = Duration.zero;

  double get position {
    if (players[num].duration.inSeconds == 0) {
      return 0;
    }
    if (changingPosition) {
      return positionVal.inSeconds * 100 / players[num].duration.inSeconds;
    } else {
      return players[num].position.inSeconds * 100 / players[num].duration.inSeconds;
    }
  }

  reproduction(PlayerController player) {
    if (player.playing && player.position.inSeconds == player.duration.inSeconds - 2) {
      changeSong(true);
      return true;
    }
  }

  changeSong(bool isNext) {
    if (isNext != true) {
      players[num].stop();
      if (num == 0) {
        num = players.length - 1;
      } else {
        num = num - 1;
      }
      players[num].toggle();
      players[num].replay();
    } else {
      players[num].stop();
      if (num == players.length - 1) {
        num = 0;
      } else {
        num = num + 1;
      }
      players[num].toggle();
      players[num].replay();
    }
  }
}
