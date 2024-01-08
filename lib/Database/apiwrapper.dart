import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/utils/base_url_domain.dart';
import 'package:stock_management/utils/local_storage.dart';

import 'app_exception.dart';

class ApiWrapper {
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    log('Url : $url');
    final res = await http.get(url);
    return _processResponse(res);
  }

  static Future<Map<String, dynamic>> loginPost(
    String endpoint,
    dynamic body,
  ) async {
    // final token = StorageUtil.getString(localStorageKey.TOKEN!);
    final url = Uri.parse('$baseUrl/$endpoint');
    log('Url : $url' + 'Body Data : $body');
    final res = await http.post(
      url,
      body: body,
    );

    return _processResponse(res);
  }

  //Make Post Request Api
  static Future<Map<String, dynamic>> post(
    String endpoint,
    dynamic body,
  ) async {
    final token = StorageUtil.getString(localStorageKey.TOKEN!);
    final url = Uri.parse('$baseUrl/$endpoint');
    log('Url : $url' + 'Body Data : $body');
    final res = await http.post(
      url,
      headers: <String, String>{"Authorization": "Bearer $token"},
      body: body,
    );

    return _processResponse(res);
  }

  static dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        var responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        debugPrint('${response.body}');
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 401:
      case 403:
        throw UnAuthorizedException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 422:
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 404:
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());

      default:
        try {
          // globalUtils.showNegativeSnackBar(
          //     message: jsonDecode(response.body)['data']['message']);
        } catch (e) {
          print(e);
        }
        throw Exception(jsonDecode(response.body)['data']['message']);
    }
  }
}
