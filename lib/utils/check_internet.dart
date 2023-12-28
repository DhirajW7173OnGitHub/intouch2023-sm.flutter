import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class CheckInternetConnection {
  Future<bool> checkInternet() async {
    ConnectivityResult result = ConnectivityResult.none;
    Connectivity connectivity = Connectivity();

    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    bool resultBool = false;
    switch (result) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
      case ConnectivityResult.none:
        resultBool = true;
        break;
      default:
        resultBool = false;
        break;
    }
    return resultBool;
  }
}
