import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/api_wrapper.dart';
import 'package:flutter_provider/todo.dart';

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

    var tempList1 = await ApiWrapper.getTodoList(limit, page);
    if (tempList1 != null) {
      var tempList2 = List.from(list);
      tempList2.addAll(tempList1);
      list = List.from(tempList2);
      page++;
    } else {
      print('got null from getTodoList');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoreData() async {
    if (isLoadingMoreData) return;
    isLoadingMoreData = true;
    notifyListeners();

    var tempList1 = await ApiWrapper.getTodoList(limit, page);
    if (tempList1 != null) {
      var tempList2 = List.from(list);
      tempList2.addAll(tempList1);
      list = List.from(tempList2);
      page++;
    } else {
      print('got null from getTodoList');
    }

    isLoadingMoreData = false;
    notifyListeners();
  }
}
