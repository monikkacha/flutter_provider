import 'package:flutter/material.dart';
import 'package:flutter_provider/todo.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ApiStore extends ChangeNotifier {
  List<TodoResponse> list = [];

  bool isLoading = true;

  bool isLoadingMoreData = false;

  var limit = 15;

  int page = 1;

  bool get loadingMoreData => isLoadingMoreData;

  Future<void> fetchData() async {
    isLoading = true;
    notifyListeners();
    Response response = await http.get(Uri.parse(
        "https://jsonplaceholder.typicode.com/todos?_limit=$limit&_page=$page"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      list = categoryResponseFromJson(response.body);
      page++;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoreData() async {
    if (isLoadingMoreData) return;
    isLoadingMoreData = true;
    notifyListeners();
    Response response = await http.get(Uri.parse(
        "https://jsonplaceholder.typicode.com/todos?_limit=$limit&_page=$page"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      var tempList = List.from(list);
      tempList.addAll(categoryResponseFromJson(response.body));
      list = List.from(tempList);
      page++;
    }
    isLoadingMoreData = false;
    notifyListeners();
  }
}
