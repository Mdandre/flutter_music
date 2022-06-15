import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_music/reproductorController.dart';
import 'package:flutter_music/reproductorPage.dart';
import 'package:get/get.dart';
import 'package:kplayer/kplayer.dart';

void main() {
  Player.boot();
  runApp(const MyApp());
  Get.put<ReproductorController>(ReproductorController());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Reproductor(),
    );
  }
}
