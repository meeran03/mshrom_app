

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/district.dart';
import 'package:http/http.dart' as http;

class DistrictProvider extends ChangeNotifier{
  DistrictClass _districtClass = new DistrictClass();
  List<DistrictData> list = new List();

  DistrictProvider(){
    _districtClass.data = list;
  }

  setData(DistrictClass districtClass){
    _districtClass = districtClass;
    notifyListeners();
  }

  getData(){
   return _districtClass.data;
  }

  Future<DistrictClass> htiApi()async {
    var response= await http.get(Uri.parse(baseUrl+'districts'));
    DistrictClass districtClass;
    if(response.statusCode == 200){
      final Map parsed = jsonDecode(response.body.toString());
      districtClass = DistrictClass.fromJson(parsed);
    }
    return districtClass;
  }

}