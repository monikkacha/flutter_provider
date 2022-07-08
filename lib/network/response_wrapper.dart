import 'package:dio/dio.dart';

class ResponseWrapper {
  Response? response;
  String? message;
  bool isSuccess;

  ResponseWrapper(
      {required this.response, required this.message, required this.isSuccess});
}
