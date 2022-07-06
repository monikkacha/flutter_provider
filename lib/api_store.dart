import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/todo.dart';

class ApiStore extends ChangeNotifier {
  List<TodoResponse> list = [];

  bool isLoading = true;

  bool isLoadingMoreData = false;

  var limit = 15;

  int page = 1;

  bool get loadingMoreData => isLoadingMoreData;

  String baseUrl = "https://jsonplaceholder.typicode.com";

  Dio dio = Dio();

  ApiStore() {
    init();
  }

  init() {
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
  }

  Future<void> fetchData() async {
    isLoading = true;
    notifyListeners();
    Response response = await dio.get(
        "$baseUrl/todos?_limit=$limit&_page=$page",
        options: buildCacheOptions(Duration(days: 7)));
    if (response.statusCode == 200 || response.statusCode == 201) {
      String body = jsonEncode(response.data);
      list = categoryResponseFromJson(body);
      page++;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoreData() async {
    if (isLoadingMoreData) return;
    isLoadingMoreData = true;
    notifyListeners();

    Response response = await dio.get(
        "$baseUrl/todos?_limit=$limit&_page=$page",
        options: buildCacheOptions(Duration(days: 7)));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var tempList = List.from(list);
      String body = jsonEncode(response.data);
      tempList.addAll(categoryResponseFromJson(body));
      list = List.from(tempList);
      page++;
    }
    isLoadingMoreData = false;
    notifyListeners();
  }
}
