import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rxdart/subjects.dart';
import 'package:stock_management/Database/apicaller.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/model/menu_list_model.dart';
import 'package:stock_management/model/product_list_model.dart';
import 'package:stock_management/model/user_login_data_model.dart';
import 'package:stock_management/utils/local_storage.dart';

class GlobalBloc {
  ApiCaller apiCaller = ApiCaller();

  final BehaviorSubject<Map> _liveUserLogindata = BehaviorSubject<Map>();
  BehaviorSubject<Map> get getLoginUserData => _liveUserLogindata;
  //for User Data
  final BehaviorSubject<User> _liveUserdata = BehaviorSubject<User>();
  BehaviorSubject<User> get getOnlyUserData => _liveUserdata;

  //menuList
  BehaviorSubject<MenuModel> get getMenuListForUser => _liveMenuListData;
  final BehaviorSubject<MenuModel> _liveMenuListData =
      BehaviorSubject<MenuModel>();

  BehaviorSubject<UserDataModel> get getErrorCodeData => _liveErrorCodeData;
  final BehaviorSubject<UserDataModel> _liveErrorCodeData =
      BehaviorSubject<UserDataModel>();

  //product List
  BehaviorSubject<List<Product>> get getProductListofItem =>
      _liveProductListData;
  final BehaviorSubject<List<Product>> _liveProductListData =
      BehaviorSubject<List<Product>>();

  //-------------------------------------------------------------------------------//

  Future<Map> doFetchUserLoginData({
    String? mobileNu,
    String? password,
  }) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {
      "password": password,
      "phone": mobileNu,
    };
    Map res = await apiCaller.getUserLoginData(bodyData);

    // if (res["errorcode"] == 1) {
    //   print('@@@@@@@@@@@@@@: ${res["errorcode"]} && ${res["msg"]}');
    //   EasyLoading.dismiss();
    //   globalUtils.showSnackBar(res["msg"]);
    //   return Future.error(res["msg"]);
    // }

    var userData = User.fromJson(res["user"]);

    await StorageUtil.putString(localStorageKey.NAME!, "${userData.name}");
    StorageUtil.putString(localStorageKey.EMAIL!, "${userData.email}");
    StorageUtil.putString(localStorageKey.MALLID!, "${userData.mallIds}");
    StorageUtil.putString(localStorageKey.PHONE!, "${userData.phone}");
    StorageUtil.putString(localStorageKey.ID!.toString(), "${userData.id}");
    StorageUtil.putString(
        localStorageKey.INACTIVE!.toString(), "${userData.inactive}");
    StorageUtil.putString(
        localStorageKey.MALLID!.toString(), "${userData.mallIds}");
    StorageUtil.putString(
        localStorageKey.ROLLID!.toString(), "${userData.roleId}");

    StorageUtil.putString(localStorageKey.TOKEN!, "${res["token"]}");

    EasyLoading.dismiss();

    _liveUserLogindata.add(res);
    _liveUserdata.add(userData);
    return res;
  }

  //---------------Menu List------------------------------//
  Future<MenuModel> getMenuListData(String roleId) async {
    EasyLoading.show(dismissOnTap: false);
    Map<String, dynamic> bodyData = {
      "role": roleId,
    };
    try {
      Map<String, dynamic> res = await apiCaller.getMenuList(bodyData);
      log('getMenuListData BodyData : $bodyData');
      var responseData = MenuModel.fromJson(res);
      _liveMenuListData.add(responseData);
      EasyLoading.dismiss();
      return responseData;
    } catch (e) {
      throw "Something went wrong $e";
    }
  }

  //product List

  Future<List<Product>> doFetchProductList({String? userId}) async {
    EasyLoading.show(dismissOnTap: false);
    Map<String, dynamic> bodyData = {
      "userid": userId,
      // "token": CommonString.TOKEN,
    };

    try {
      Map<String, dynamic> res = await apiCaller.getProductList(bodyData);
      print("doFetchProductList Body Data : $bodyData----Response: $res");
      var data = ProductListModel.fromJson(res);
      _liveProductListData.add(data.products);
      EasyLoading.dismiss();
      return (data.products);
    } catch (e) {
      throw "Something went wrong :$e";
    }
  }
}

GlobalBloc globalBloc = GlobalBloc();
