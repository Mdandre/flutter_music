import 'package:get/get.dart';

import 'reproductorController.dart';

class ReproductorBindig extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReproductorController());
  }
}
