import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_management/globalFile/custom_dialog.dart';
import 'package:stock_management/utils/base_url_domain.dart';

import 'app_exception.dart';

class ApiWrapper {
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    log('Url : $url');
    final res = await http.get(url);
    return _processResponse(res);
  }

  //Make Post Request Api
  static Future<Map<String, dynamic>> post(
    String endpoint,
    dynamic body,
  ) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    log('Url : $url' + 'Body Data : $body');
    final res = await http.post(
      url,
      //  headers: <String, String>{"Authorization":},
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
          globalUtils.showNegativeSnackBar(
              message: jsonDecode(response.body)['data']['message']);
        } catch (e) {
          print(e);
        }
        throw Exception(jsonDecode(response.body)['data']['message']);
    }
  }
}
