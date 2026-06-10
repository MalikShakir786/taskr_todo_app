import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

class Utils {
  static Widget get apiLoader => Center(
    child: SizedBox(
      height: 25,
      width: 25,
      child: CircularProgressIndicator(color: Colors.white),
    ),
  );

  static void showLoader() {
    if (!(Get.isDialogOpen ?? true)) {
      Get.dialog(
        barrierDismissible: false,
        Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }
  }

  static void hideLoader() {
    if ((Get.isDialogOpen ?? false)) {
      Navigator.pop(Get.context!);
    }
  }

  static toastMessage(String message) {
    showToast(
      message,
      radius: 30,
      position: ToastPosition.bottom,
      backgroundColor: Colors.black87,
      textPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      textStyle: TextStyle(color: Colors.white),
      duration: Duration(seconds: 3),
    );
  }

}
