import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/trending_category.dart';

class TrendingCategoryProvider extends ChangeNotifier{
  TrendingCategoryHub _trendingCategoryHub  = TrendingCategoryHub();
  List<TrendingCategoryData> list = new List();

  TrendingCategoryProvider(){
    _trendingCategoryHub.data = list;
  }

  setData(TrendingCategoryHub trendingCategoryHub){
    _trendingCategoryHub = trendingCategoryHub;
    notifyListeners();
  }

  getData(){
    return _trendingCategoryHub.data;
  }

  Future<TrendingCategoryHub> hitApi() async {
    var response = await http.get(Uri.parse(baseUrl+'trending/categories'));
    TrendingCategoryHub trendingCategoryHub;
    if(response.statusCode == 200){
      final Map parsed = jsonDecode(response.body.toString());
      trendingCategoryHub = TrendingCategoryHub.fromJson(parsed);
    }
    return trendingCategoryHub;
  }

}