import 'dart:developer';

import 'package:stock_management/Database/apiwrapper.dart';

//from This class give call to ApiWrapper
class ApiCaller {
  //UserLoginData
  Future<Map> getUserLoginData(Map body) async {
    var endPoint = 'userlogin';
    try {
      final res = await ApiWrapper.loginPost(endPoint, body);
      log('getUserLoginData Body Data  :$body and response : $res');
      // var userData = User.fromJson(res["user"]);
      // // var response = UserDataModel.fromJson(res["token"]);

      // await StorageUtil.putString(localStorageKey.NAME!, "${userData.name}");
      // StorageUtil.putString(localStorageKey.EMAIL!, "${userData.email}");
      // StorageUtil.putString(localStorageKey.MALLID!, "${userData.mallIds}");
      // StorageUtil.putString(localStorageKey.PHONE!, "${userData.phone}");
      // StorageUtil.putString(localStorageKey.ID!.toString(), "${userData.id}");
      // StorageUtil.putString(
      //     localStorageKey.INACTIVE!.toString(), "${userData.inactive}");
      // StorageUtil.putString(
      //     localStorageKey.MALLID!.toString(), "${userData.mallIds}");
      // StorageUtil.putString(
      //     localStorageKey.ROLLID!.toString(), "${userData.roleId}");
      // StorageUtil.putString(
      //     localStorageKey.TOKEN!.toString(), "${res["token"]}");

      return res;
    } catch (e) {
      log('CATCH API ERROR : $e');
      throw "Something went wrong $e";
    }
  }

  Future<Map<String, dynamic>> getUserErrorCodeData(Map body) async {
    var endPoint = 'userlogin';
    try {
      final res = await ApiWrapper.post(endPoint, body);
      //log('getUserLoginData Body Data  :$body and response : $res');
      return res;
    } catch (e) {
      log('CATCH API ERROR : $e');
      throw "Something went wrong $e";
    }
  }

  //Menu List
  Future<Map<String, dynamic>> getMenuList(Map<String, dynamic> body) async {
    var endPoint = "active-pages";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      log(' bodyData :$body-- res :$res ');
      return res;
    } catch (e) {
      log('CATCH API ERROR : $e');
      throw "Something went wrong for getMenuList :$e";
    }
  }

  //To fetch product List
  Future<Map<String, dynamic>> getProductList(Map<String, dynamic> body) async {
    var endPoint = "products";

    try {
      final res = await ApiWrapper.post(endPoint, body);
      log('getProductList BodyData : $body ---- res : $res');
      return res;
    } catch (e) {
      log('CATCH API ERROR : $e');
      throw "Something Went wrong for product List :$e";
    }
  }

  //Add Product List
  Future<Map<String, dynamic>> placedStockedInOutBySubmit(
      String? condition, String? userId, String? jsonData) async {
    var endPoint = "stockctrl-addrem_stock";
    Map<String, dynamic> bodyData = {
      "condition": condition,
      "userid": userId,
      "json_data": jsonData,
    };
    try {
      final res = await ApiWrapper.post(endPoint, bodyData);
      log('placedStockedInOutBySubmit BodyData : $bodyData ----Res : $res');
      return res;
    } catch (e) {
      log('CATCH API ERROR : $e');
      throw "Something Went wrong in placedStockedInOutBySubmit :$e";
    }
  }

  //
}
