
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/category.dart';
import 'package:http/http.dart' as http;

class CategoryProvider extends ChangeNotifier{
  Category _categories = new Category();


  setData(Category categories){
    _categories = categories;
  }
  getData(){
    return _categories.data;
  }

  Future<Category> hitApi() async{
    var response = await http.get(Uri.parse(baseUrl+'categories'));
Category category;
    if(response.statusCode == 200){
       final Map parsed = jsonDecode(response.body.toString());
      category = Category.fromJson(parsed);
    }
    return category;
  }
}