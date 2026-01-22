import 'package:dronees/utils/constants/colors.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TFullScreenLoader {
  TFullScreenLoader._();

  static Future<void> show({required Widget loader}) async {
    Get.dialog(Center(child: loader), barrierDismissible: false);
  }

  static void hide() {
    if (Get.isDialogOpen ?? false) {
      Navigator.pop(Get.context!);
    }
  }
}
