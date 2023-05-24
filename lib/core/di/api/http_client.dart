import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_demo_structure/core/di/api/api_end_points.dart';
import 'package:flutter_demo_structure/core/di/api/app_exceptions.dart';
import 'package:flutter_demo_structure/core/di/api/dio_util_error.dart';
import 'package:flutter_demo_structure/core/di/api/interceptor/custom_interceptors.dart';
import 'package:flutter_demo_structure/core/di/api/interceptor/internet_interceptor.dart';
import 'package:flutter_demo_structure/core/locator.dart';
import 'package:flutter_demo_structure/router/app_router.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HttpClient {
  late Dio _client;
  Map<String, dynamic> headers = {};

  HttpClient() {
    _client = Dio()
      ..options = BaseOptions(
        baseUrl: APIEndPoints.baseUrl,
      );

    if (kDebugMode) {
      _client.interceptors.add(
        PrettyDioLogger(
          requestHeader: false,
          requestBody: true,
          request: true,
          responseBody: false,
          responseHeader: false,
          compact: true,
        ),
      );
    }
    _client.interceptors.add(CustomInterceptors());

    /// Disable logging into production
    if (kDebugMode) {
      _client.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: false,
          request: false,
          responseBody: true,
          responseHeader: true,
          compact: true,
        ),
      );
    }
    _client.interceptors.add(InternetInterceptors());
  }

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await _client.get(url);
      responseJson = returnResponse(response);
    } on DioError catch (e) {
      debugPrint('Dio Error');
      DioErrorUtil.handleError(e);
    }
    return responseJson;
  }

  Future post(String url, {body}) async {
    var responseJson;
    try {
      final response = await _client.post<String>(
        url,
        data: body,
      );
      responseJson = returnResponse(response);
    } on DioError catch (e) {
      DioErrorUtil.handleError(e);
    }
    return responseJson;
  }

  Future put(String url, {body}) async {
    var responseJson;
    try {
      final response = await _client.put(url, data: body);
      responseJson = returnResponse(response);
    } on DioError catch (e) {
      DioErrorUtil.handleError(e);
    }

    return responseJson;
  }

  Future delete(String url, {body}) async {
    var apiResponse;
    try {
      final response = await _client.delete(url);
      apiResponse = returnResponse(response);
    } on DioError catch (e) {
      DioErrorUtil.handleError(e);
    }
    return apiResponse;
  }

  dynamic returnResponse(Response response) {
    final mapData = jsonDecode((response.data));
    debugPrint("${mapData["code"]}");
    switch (mapData["code"]) {
      case "0":
      case "1":
      case "2":
      case "11":
        return mapData;
      /*     case "-1":
        appDB.logout();
        navigator.pushNamedAndRemoveUntil(RouteName.signupOptionPage);
        //throw UnauthorisedException(response.data.toString());
        return mapData;*/
      default:
        throw FetchDataException('${response.statusCode}');
    }
  }

  dynamic returnResponse2(Response response) {
    switch (response.statusCode) {
      case 200:
      case 302:
        var responseJson = response.data;
        debugPrint(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
      case 403:
        locator<AppRouter>().replaceAll([const LoginRoute()]);
        throw UnauthorisedException(response.data.toString());
      case 500:
      default:
        throw FetchDataException('${response.statusCode}');
    }
  }

  wrapRequest(body) {
    return jsonEncode(body);
  }
}
