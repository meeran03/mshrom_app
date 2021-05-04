
import 'package:flutter/cupertino.dart';
import 'package:many_vendor_ecommerce_app/model/cart.dart';
import 'package:many_vendor_ecommerce_app/model/return_cart.dart';
import 'package:many_vendor_ecommerce_app/provider/cart_count_provider.dart';
import 'package:many_vendor_ecommerce_app/repository/db_connection.dart';
import 'package:provider/provider.dart';


class CartCalculationProvider extends ChangeNotifier{
  DatabaseConnection _connection = new DatabaseConnection();
  int quantity;
  double price =0;
  double subPrice =0;


  void show(Products products){
     quantity = products.quantity;
     price = double.parse(products.price.toStringAsFixed(3));
     subPrice = double.parse(products.subPrice.toStringAsFixed(3));
  }

  void increment(Products products,context) async{
    Products _product =  products;
    /*increment in data base*/
    var cart = Cart();
    /*auto increment*/
    cart.campaignId  = _product.campaignId;
    cart.vendorStockId = _product.vendorStockId;
    await _connection.addToCartWithIncrement(cart);
    _product.quantity +=1;
    double subPrice = _product.price* _product.quantity;
    _product.subPrice = subPrice;
    /*change the total price*/

    Provider.of<CartCount>(context,listen: false).totalQuantity();
    notifyListeners();
  }

  void remove(Products product,context) async{
    /*change the total price*/

    await _connection.removeCart(product.vendorStockId);

    Provider.of<CartCount>(context,listen: false).totalQuantity();
    notifyListeners();
  }

  void decrement(Products products,context) async{
    Products _product = products;
    if(_product.quantity == 1){
      remove(products,context);
    }else{
      /*decrement in data base*/
      var cart = Cart();
      /*auto increment*/
      cart.campaignId  = _product.campaignId;
      cart.vendorStockId = _product.vendorStockId;
      _product.quantity -=1;
      cart.quantity = _product.quantity;
      double subPrice = _product.price* _product.quantity;
      _product.subPrice = subPrice;
      await _connection.addToCartUpdate(cart.vendorStockId,cart);
      /*change the total price*/
      Provider.of<CartCount>(context,listen: false).totalQuantity();
      notifyListeners();
    }
  }


}


class TotalPayment extends ChangeNotifier{
  int quantity;
  double price =0;
  double subPrice =0;

  double subTotalPrice = 0;
  double totalTax = 0;
  double totalPrice = 0;


  setData(CartData cartData){
    totalPrice = cartData.totalPrice;
    totalTax = cartData.totalTax;
    subTotalPrice =cartData.subTotalPrice;
    notifyListeners();
  }

  plusPayment(price){
    subTotalPrice = subTotalPrice +price;
    notifyListeners();
  }

  minusPayment(price){
    subTotalPrice = subTotalPrice - price;
    notifyListeners();
  }
}