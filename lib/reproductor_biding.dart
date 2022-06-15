import 'package:flutter_music/reproductorController.dart';
import 'package:get/get.dart';

class ReproductorBindig extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReproductorController());
  }
}
