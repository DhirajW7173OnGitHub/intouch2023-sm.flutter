import 'dart:developer';

import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/utils/local_storage.dart';

class SessionManager {
  Future<void> updateLoggedInTimeAndLoggedStatus() async {
    final currentTime = DateTime.now();
    await StorageUtil.putString(localStorageKey.ISLOGGEDIN!, "TRUE");
    await StorageUtil.putString(
        localStorageKey.LASTLOGGEDINTIME!, currentTime.toIso8601String());

    log('Logged In : ${StorageUtil.getString(localStorageKey.ISLOGGEDIN!)} ------------Is LoggedInTIME : ${StorageUtil.getString(localStorageKey.LASTLOGGEDINTIME!)}');
  }
}

SessionManager sessionManager = SessionManager();
