import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/brand.dart';


class BrandProvider extends ChangeNotifier{
  bool isLoading = true;
  BrandClass _brand = new BrandClass();

  setData(BrandClass brand){
    _brand = brand;
    isLoading = false;
    notifyListeners();
  }

  getData(){
    return _brand.data;
  }

 Future<BrandClass>  brandHitApi() async{
    var response = await http.get(Uri.parse(baseUrl+'brands'));
    BrandClass brand;
    if(response.statusCode == 200){
      final Map parsed = jsonDecode(response.body.toString());
      brand = BrandClass.fromJson(parsed);
    }
    return brand;
  }
}