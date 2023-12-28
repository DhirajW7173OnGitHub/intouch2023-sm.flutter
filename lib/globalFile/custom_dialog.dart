import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GlobalUtils {
  showPositiveSnackBar({
    VoidCallback? onVisible,
    required BuildContext context,
    int sec = 1,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: sec),
        onVisible: onVisible,
      ),
    );
  }

  showNegativeSnackBar({
    BuildContext? context,
    VoidCallback? onVisible,
    required String message,
    int sec = 1,
  }) {
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: sec),
        onVisible: onVisible,
      ),
    );
  }

  showSlabDialog({
    required BuildContext context,
    required Widget widget,
    bool barrierDismissible = true,
    Color barrierColor = Colors.white,
  }) {
    showDialog(
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          backgroundColor: Colors.white,
          child: widget,
        );
      },
    );
  }

  showValidationError(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  showSnackBar(String message, {Color color = Colors.red}) {
    final messenger = scaffoldMessengerKey.currentState;
    messenger?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

GlobalUtils globalUtils = GlobalUtils();
