import 'package:flutter/material.dart';

import 'announcement.dart';

class FilterProvider with ChangeNotifier{
  Category category = Category.All;
  String keyword = "";

  void setCategory(Category category) {
    this.category = category;
    keyword = "";
    notifyListeners();
  }

  void setKeyword(String keyword) {
    this.keyword = keyword;
    notifyListeners();
  }
}