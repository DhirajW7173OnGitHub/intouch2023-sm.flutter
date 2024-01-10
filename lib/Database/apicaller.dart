import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:stock_management/Database/apiwrapper.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/utils/base_url_domain.dart';
import 'package:stock_management/utils/local_storage.dart';

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
      throw "IN getUserLoginData Something went wrong $e";
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
      throw "In getUserErrorCodeData Something went wrong $e";
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
      throw "in getMenuList Something went wrong for getMenuList :$e";
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
      throw "In getProductList Something Went wrong for product List :$e";
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
      throw "In placedStockedInOutBySubmit Something Went wrong :$e";
    }
  }

  //Do Fetch List Of Stock
  Future<Map<String, dynamic>> getStockListData(
      Map<String, dynamic> body) async {
    var endPoint = "requestdetail";

    try {
      final res = await ApiWrapper.post(endPoint, body);
      print("getStockListData Response : $res");
      return res;
    } catch (e) {
      log('getStockListData get Error :$e');
      throw "I getStockListData Something Went Wrong :$e";
    }
  }

  //Do Fetch Product Details
  Future<Map<String, dynamic>> getProductDetailsData(
      Map<String, dynamic> body) async {
    var endPoint = "requestinformation";

    try {
      final res = await ApiWrapper.post(endPoint, body);
      print("getProductDetailsData Response : $res");

      return res;
    } catch (e) {
      log("getProductDetailsData Error :$e");
      throw "IN getProductDetailsData Something went wrong :$e";
    }
  }

  //do Fetch Profile Details

  Future<Map<String, dynamic>> getProfileDetailsData(
      Map<String, dynamic> body) async {
    var endPoint = "shareProfile";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      print("getProfileDetailsData Response : $res");
      return res;
    } catch (e) {
      throw "IN getProfileDetailsData Error :$e";
    }
  }

  //Upload Profile Picture

  Future<Map> uploadProfilePicture(
      {String? userId, File? profilePicture}) async {
    final url = Uri.parse('$baseUrl/saveProfileImage');

    final token = StorageUtil.getString(localStorageKey.TOKEN!);

    ///Authorization
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    //Request headers
    final request = http.MultipartRequest('POST', url)
      ..fields['userid'] = userId!
      ..files.add(
        await http.MultipartFile.fromPath('userprofile', profilePicture!.path),
      );
    request.headers.addAll(headers);

    try {
      final res = await request.send();
      if (res.statusCode == 200) {
        //convert the data in String
        final resBody = await res.stream.bytesToString();
        final decodeRes = json.decode(resBody);
        log('ApiResponse : $decodeRes');
        return decodeRes as Map;
      } else {
        print('Request failed with status: ${res.statusCode}');
        throw Exception('Request failed with status: ${res.statusCode}');
      }
    } catch (e) {
      print('Error sending the request: $e');
      throw Exception('Error sending the request: $e');
    }
  }
}
