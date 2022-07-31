import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Util {
  static List<String> toastStack = [];

  static addToast(String? t) {
    if (t?.isNotEmpty == true) {
      toastStack.add(t!);
      Get.asap(() => toast());
    }
  }

  static toast() async {
    if (toastStack.isNotEmpty) {
      if (!Get.isSnackbarOpen) {
        var m = toastStack.removeAt(0);
        Get.snackbar(m, "",
            messageText: const SizedBox.shrink(),
            margin: const EdgeInsets.all(8),
            duration: 2500.milliseconds,
            snackPosition: SnackPosition.BOTTOM);
      } else {
        2.5.delay(() => toast());
      }
    }
  }
}
