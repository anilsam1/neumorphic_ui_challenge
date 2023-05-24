import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/core/db/app_db.dart';
import 'package:flutter_demo_structure/core/di/api/app_exceptions.dart';
import 'package:flutter_demo_structure/core/locator.dart';
import 'package:flutter_demo_structure/router/app_router.dart';

class DioErrorUtil {
  // general methods:------------------------------------------------------------
  static handleError(DioError error) {
    String errorDescription = "";

    debugPrint(error.toString());
    switch (error.type) {
      case DioErrorType.unknown:
        if (error.error is SocketException) {
          throw ConnectionException(
              "Connection to server failed due to internet connection.");
        } else if (error.response!.statusCode == -9) {
          throw NoInternetException("No Active Internet Connection");
        } else {
          throw InvalidInputException(
              "Something went wrong. Please try after sometime.");
        }

      case DioErrorType.cancel:
        errorDescription = "Request to server was cancelled";
        break;
      case DioErrorType.connectionTimeout:
        throw RequestCanceledException("Connection timeout with server");

      case DioErrorType.receiveTimeout:
        throw ServerSideException(
            "Request can't be handled for now. Please try after sometime.");

      case DioErrorType.badResponse:
        debugPrint("Response:");
        debugPrint(error.toString());
        if (error.response!.statusCode == 12039 ||
            error.response!.statusCode == 12040) {
          throw ConnectionException(
              "Connection to server failed due to internet connection.");
        } else if (401 == error.response!.statusCode) {
          appDB.logout();
          locator<AppRouter>().replaceAll([const LoginRoute()]);
          //throw UnauthorisedException(response.data.toString());
          throw UnauthorisedException("Please login again.");
        } else if (401 < error.response!.statusCode! &&
            error.response!.statusCode! <= 417) {
          throw BadRequestException("Something when wrong. Please try again.");
        } else if (500 <= error.response!.statusCode! &&
            error.response!.statusCode! <= 505) {
          throw ServerSideException(
              "Request can't be handled for now. Please try after sometime.");
        } else {
          throw InvalidInputException(
              "Something went wrong. Please try after sometime.");
        }

      case DioErrorType.sendTimeout:
        throw ServerSideException(
            "Request can't be handled for now. Please try after sometime.");
      case DioErrorType.badCertificate:
        throw ServerSideException(
            "Request can't be handled for now. Please try after sometime.");
      case DioErrorType.connectionError:
        throw RequestCanceledException("Connection timeout with server");
    }

    return errorDescription;
  }
}
