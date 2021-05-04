import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/shop_product.dart';

class TradingProductProvider extends ChangeNotifier{
  bool isLoading = true;
  ShopProductHub _shopProductHub = new ShopProductHub();
  List<ShopProductData> list = new List();

  TradingProductProvider(){
    _shopProductHub.data = list;
  }

  setData(ShopProductHub shopProductHub){
    _shopProductHub = shopProductHub;
    isLoading = false;
    notifyListeners();
  }

  getData(){
    return _shopProductHub.data;
  }

  Future<ShopProductHub> hitApi() async{
    var response = await http.get(Uri.parse(baseUrl+'trending/products'));
    ShopProductHub shopProductHub;
    if(response.statusCode == 200){
      final Map parsed = jsonDecode(response.body.toString());
      shopProductHub = ShopProductHub.fromJson(parsed);
    }
    return shopProductHub;
  }
}