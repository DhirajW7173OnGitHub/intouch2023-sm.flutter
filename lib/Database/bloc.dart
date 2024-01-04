import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rxdart/subjects.dart';
import 'package:stock_management/Database/apicaller.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/Scanner/Model/product_list_model.dart';
import 'package:stock_management/StockList/Model/stock_details_model.dart';
import 'package:stock_management/StockList/Model/stock_list_model.dart';
import 'package:stock_management/model/menu_list_model.dart';
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
      throw "In getMenuListData Something went wrong $e";
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
      throw "In doFetchProductList Something went wrong :$e";
    }
  }

  //Fetch List Of Stock

  BehaviorSubject<List<Stockdiary>> get getStockListdata => _liveStockList;

  final BehaviorSubject<List<Stockdiary>> _liveStockList =
      BehaviorSubject<List<Stockdiary>>();

  Future<List<Stockdiary>> doFetchListOfStockByDate({
    String? userId,
    String? startDate,
    String? endDate,
  }) async {
    Map<String, dynamic> bodyData = {
      "userid": userId,
      "sdate": startDate,
      "edate": endDate,
    };

    Map<String, dynamic> res = await apiCaller.getStockListData(bodyData);
    log("doFetchListOfStockByDate BodyDate : $bodyData --- Response : $res");

    var data = StockListModel.fromJson(res);
    _liveStockList.add(data.stockdiaries);
    return (data.stockdiaries);
  }

  //DoFetch Product Details
  BehaviorSubject<List<StockDatum>> get getProductDetails =>
      _liveProductDetails;

  final BehaviorSubject<List<StockDatum>> _liveProductDetails =
      BehaviorSubject<List<StockDatum>>();

  Future<List<StockDatum>> dofetchStockDetailsData(
      {String? userId, String? reqId}) async {
    Map<String, dynamic> bodyData = {
      "reqid": reqId,
      "userid": userId,
    };

    Map<String, dynamic> res = await apiCaller.getProductDetailsData(bodyData);
    log('dofetchStockDetailsData BodyData : $bodyData --- Response : $res');

    var data = StockDetailsModel.fromJson(res);

    _liveProductDetails.add(data.stockDetails);
    return (data.stockDetails);
  }
}

GlobalBloc globalBloc = GlobalBloc();
