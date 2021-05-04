import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/thana.dart';
import 'package:http/http.dart' as http;


class ThanaProvider extends ChangeNotifier{
  ThanaClass _thanaClass=new ThanaClass();
  List<ThanaData> list = new List();

  ThanaProvider(){
    _thanaClass.data = list;
  }

  setData(ThanaClass thanaClass){
    _thanaClass = thanaClass;
  }

  getData(){
    return _thanaClass.data;
  }

  Future<ThanaClass> hitApi(id) async{
    var response = await http.get(Uri.parse(baseUrl+'city/'+id.toString()));
    ThanaClass thanaClass;
    if(response.statusCode == 200){
      final Map parsed = jsonDecode(response.body.toString());
      thanaClass = ThanaClass.fromJson(parsed);
    }
    return thanaClass;
  }
}