

import 'package:flutter/cupertino.dart';
import 'package:many_vendor_ecommerce_app/repository/db_connection.dart';

class CartCount extends ChangeNotifier{
  DatabaseConnection _connection = new DatabaseConnection();
  int count = 0;
   totalQuantity() async{
   count = await _connection.quantity();
    notifyListeners();
  }

  getCount(){
    return count;
  }
}