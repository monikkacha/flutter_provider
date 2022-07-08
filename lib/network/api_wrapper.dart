import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_provider/model/send_data_model.dart';
import 'package:flutter_provider/network/response_wrapper.dart';
import 'package:flutter_provider/model/todo.dart';

import '../utils/log_util.dart';

class ApiWrapper {
  static String baseUrl = "https://jsonplaceholder.typicode.com/";

  static Dio? dio;

  static LogInterceptor _logInterceptor = LogInterceptor(
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
      request: true,
      error: true,
      requestBody: true,
      logPrint: (obj) =>
          Log.info(obj is Map ? jsonEncode(obj) : obj.toString()));

  static init() {
    dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 10000,
        receiveTimeout: 10000,
        contentType: Headers.jsonContentType));
    dio!.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
    dio!.interceptors.add(_logInterceptor);
  }

  static Future<ResponseWrapper> _getRequest({required String endPoint}) async {
    ResponseWrapper responseWrapper =
        ResponseWrapper(response: null, message: null, isSuccess: false);
    try {
      // requesting for the data
      Response response = await dio!
          .get(endPoint, options: buildCacheOptions(Duration(days: 1)));

      // checking for the request success and status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        responseWrapper =
            ResponseWrapper(response: response, isSuccess: true, message: "");
      } else if (response.statusCode == 400) {
        responseWrapper = ResponseWrapper(
            response: null, isSuccess: false, message: "BAD REQUEST");
        return responseWrapper;
      } else if (response.statusCode == 401) {
        responseWrapper = ResponseWrapper(
            response: null, isSuccess: false, message: "UNAUTHORIZED");
      } else if (response.statusCode == 404) {
        responseWrapper = ResponseWrapper(
            response: null, isSuccess: false, message: "NOT FOUND");
      } else if (response.statusCode == 403) {
        responseWrapper = ResponseWrapper(
            response: null, isSuccess: false, message: "FORBIDDEN");
      } else {
        responseWrapper = ResponseWrapper(
            response: null,
            isSuccess: false,
            message: "REQUEST GOT FAILED DUE TO : ${response.statusCode}");
      }
      return responseWrapper;
    } on DioError catch (e) {
      String msg = "";
      switch (e.type) {
        case DioErrorType.connectTimeout:
          msg = "CONNECTION TIMEOUT";
          print(msg);
          break;
        case DioErrorType.receiveTimeout:
          msg = "RECEIVE TIMEOUT";
          print(msg);
          break;
        case DioErrorType.sendTimeout:
          msg = "SEND TIMEOUT";
          print(msg);
          break;
        case DioErrorType.other:
          msg = "OTHER DIO ERROR";
          print(msg);
          break;
      }
      responseWrapper =
          ResponseWrapper(response: null, message: msg, isSuccess: false);
      return responseWrapper;
    } catch (e) {
      String msg = 'error : ${e.toString()}';
      print(msg);
      responseWrapper =
          ResponseWrapper(response: null, message: msg, isSuccess: false);
      return responseWrapper;
    }
  }

  static Future<ResponseWrapper> _postRequest(
      {required String endPoint, required Map<String, dynamic> data}) async {
    ResponseWrapper responseWrapper =
        ResponseWrapper(response: null, message: null, isSuccess: false);
    try {
      Response response = await dio!.post(endPoint,
          options: buildCacheOptions(Duration(days: 1)), data: data);

      // checking for the request success and status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('response : $response');
        responseWrapper =
            ResponseWrapper(response: response, isSuccess: true, message: "");
      } else if (response.statusCode == 400) {
        responseWrapper = ResponseWrapper(
            response: null, isSuccess: false, message: "BAD REQUEST");
        return responseWrapper;
      } else if (response.statusCode == 401) {
        responseWrapper = ResponseWrapper(
            response: null, isSuccess: false, message: "UNAUTHORIZED");
      } else if (response.statusCode == 404) {
        responseWrapper = ResponseWrapper(
            response: null, isSuccess: false, message: "NOT FOUND");
      } else if (response.statusCode == 403) {
        responseWrapper = ResponseWrapper(
            response: null, isSuccess: false, message: "FORBIDDEN");
      } else {
        responseWrapper = ResponseWrapper(
            response: null,
            isSuccess: false,
            message: "REQUEST GOT FAILED DUE TO : ${response.statusCode}");
      }
      return responseWrapper;
    } on DioError catch (e) {
      String msg = "";
      switch (e.type) {
        case DioErrorType.connectTimeout:
          msg = "CONNECTION TIMEOUT";
          print(msg);
          break;
        case DioErrorType.receiveTimeout:
          msg = "RECEIVE TIMEOUT";
          print(msg);
          break;
        case DioErrorType.sendTimeout:
          msg = "SEND TIMEOUT";
          print(msg);
          break;
        case DioErrorType.other:
          msg = "OTHER DIO ERROR";
          print(msg);
          break;
      }
      responseWrapper =
          ResponseWrapper(response: null, message: msg, isSuccess: false);
      return responseWrapper;
    } catch (e) {
      String msg = 'error : ${e.toString()}';
      print(msg);
      responseWrapper =
          ResponseWrapper(response: null, message: msg, isSuccess: false);
      return responseWrapper;
    }
  }

  static Future<List<TodoResponse>?> getTodoList(int limit, int page) async {
    String endPoint = "/todos?_limit=$limit&_page=$page";
    ResponseWrapper responseWrapper = await _getRequest(endPoint: endPoint);
    if (responseWrapper.isSuccess) {
      String body = jsonEncode(responseWrapper.response!.data);
      return categoryResponseFromJson(body);
    } else {
      print('getTodoList : error : ${responseWrapper.message}');
      return null;
    }
  }

  static Future<bool> postData(SendDataModel sendDataModel) async {
    String endPoint = "/posts";
    ResponseWrapper responseWrapper =
        await _postRequest(endPoint: endPoint, data: sendDataModel.toJson());
    return responseWrapper.isSuccess;
  }
}
