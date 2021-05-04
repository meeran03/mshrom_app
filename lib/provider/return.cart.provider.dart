
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/return_cart.dart';
import 'package:many_vendor_ecommerce_app/repository/db_connection.dart';
import 'package:http/http.dart' as http;

class ReturnCartProvider extends ChangeNotifier{
  ReturnCart _returnCart =  ReturnCart();
  CartData  _cartData = CartData();

  ReturnCartProvider(){
    _returnCart.data = _cartData;
  }

  setData(ReturnCart returnCart){
    _returnCart = returnCart;
    notifyListeners();
  }

  getData(){
    return _returnCart;
  }



  Future<ReturnCart> hitApi() async{
    ReturnCart returnCart = new ReturnCart();
    DatabaseConnection _databaseConnection =new DatabaseConnection();
    var carts = await _databaseConnection.fetchCart();
    List<String> list = [];
    carts.forEach((element) {
      String data = element.vendorStockId.toString()+'-'+element.campaignId.toString()+'-'+element.quantity.toString();
      list.add(data);
    });

    String cartsJson = jsonEncode(list);
    var response = await http.get(Uri.parse(baseUrl+'shop/carts/'+cartsJson));

    if(response.statusCode == 200){

      final Map parsed = jsonDecode(response.body.toString());
      returnCart = ReturnCart.fromJson(parsed);
    }
    return returnCart;
  }
  

}