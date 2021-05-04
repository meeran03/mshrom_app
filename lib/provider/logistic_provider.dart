
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/logistic.dart';
import 'package:http/http.dart' as http;
class LogisticProvider extends ChangeNotifier{
  LogisticClass _logisticClass =  LogisticClass();
  List<LogisticData> list = new List();

  LogisticProvider(){
    _logisticClass.data =list;
  }

  setData(LogisticClass logisticClass){
    _logisticClass = logisticClass;
  }


  getData(){
    return _logisticClass.data;
  }


  Future<LogisticClass> hitApi(d,a) async{
    var response = await http.get(Uri.parse(baseUrl+'logistic/'+d.toString()+'/'+a.toString()));
    LogisticClass logisticClass;
    if(response.statusCode == 200){
      final Map parsed = jsonDecode(response.body.toString());
      logisticClass = LogisticClass.fromJson(parsed);
    }
    return logisticClass;
  }
}