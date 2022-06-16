import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_music/controllers/stream_controller.dart';
import 'package:flutter_music/models/stream.dart';
import 'package:get/get.dart';

class PlayerController extends GetxController {
  final AudioPlayer _advancedPlayer = AudioPlayer();

  Rx<Duration> duration = Duration(seconds: 0).obs;
  Rx<Duration> position = Duration(seconds: 0).obs;
  final Rx<int> currentStreamIndex = 0.obs;
  final Rx<PlayerState> playState = PlayerState.stopped.obs;
  var streams = <Stream>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    final streamController = Get.put(StreamController());
    streams = streamController.streams;

    _advancedPlayer.onDurationChanged.listen((d) => duration.value = d);
    _advancedPlayer.onPositionChanged.listen((p) => position.value = p);
    _advancedPlayer.onPlayerStateChanged.listen((PlayerState state) => playState.value = state);
    _advancedPlayer.onPlayerComplete.listen((event) => position.value = duration.value);
    _advancedPlayer.onPlayerComplete.listen((event) => position.value == duration.value ? next() : null);
  }

  //play
  void smartPlay() async {
    if (playState.value == PlayerState.playing) {
      pause();
    } else {
      resume();
    }
  }

  void play() async {
    stop();
    resume();
  }

  //play
  void resume() async {
    _advancedPlayer.play(UrlSource(streams[currentStreamIndex.value].music));
  }

  //pause
  void pause() async {
    _advancedPlayer.pause();
    if (_advancedPlayer.state == PlayerState.paused) ; //success
  }

  //stop
  void stop() async {
    await _advancedPlayer.stop();
    if (_advancedPlayer.state == PlayerState.stopped) {
      position.value = Duration(seconds: 0);
    }
  }

  void next() {
    if (currentStreamIndex.value + 1 != streams.length) currentStreamIndex.value++;
    play();
  }

  void back() {
    if (currentStreamIndex.value - 1 != -1) currentStreamIndex.value--;
    play();
  }

  set setPositionValue(double value) => _advancedPlayer.seek(Duration(seconds: value.toInt()));
}
