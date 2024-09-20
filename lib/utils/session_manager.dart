import 'dart:developer';

import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/utils/local_storage.dart';

class SessionManager {
  Future<void> updateLastLoggedInTimeAndLoggedInStatus() async {
    final currentTime = DateTime.now();
    await StorageUtil.putString(localStorageKey.ISLOGGEDIN, "TRUE");
    await StorageUtil.putString(
        localStorageKey.LASTLOGGEDINTIME, currentTime.toIso8601String());

    var loginStatus = StorageUtil.getString(localStorageKey.ISLOGGEDIN);
    var loggedTime = StorageUtil.getString(localStorageKey.LASTLOGGEDINTIME);

    log('islogged: $loginStatus --- loggedONTIME: $loggedTime');
  }

  Future<void> logout() async {
    await StorageUtil.remove(localStorageKey.ISLOGGEDIN);
    await StorageUtil.remove(localStorageKey.LASTLOGGEDINTIME);
  }

  void updateLoggedInTimeAndLoggedStatus() {}
}

SessionManager sessionManager = SessionManager();
