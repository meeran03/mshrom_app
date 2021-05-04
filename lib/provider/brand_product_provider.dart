import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/shop_product.dart';


class BrandProductProvider extends ChangeNotifier{
  ShopProductHub _shopProductHub = new ShopProductHub();
  List<ShopProductData> list = new List();

  BrandProductProvider(){
    _shopProductHub.data = list;
  }

  setData(ShopProductHub shopProductHub){
    _shopProductHub = shopProductHub;
    notifyListeners();
  }

  getData(){
    return _shopProductHub.data;
  }

  Future<ShopProductHub> hitApi(id) async{
    var response = await http.get(Uri.parse(baseUrl+'brand/$id'));
    ShopProductHub shopProductHub;
    if(response.statusCode ==200){
      final Map parsed = jsonDecode(response.body.toString());
      shopProductHub =ShopProductHub.fromJson(parsed);
    }
    return shopProductHub;
  }
}