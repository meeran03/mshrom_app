import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/order.dart';
import 'package:http/http.dart' as http;

class OrderProvider extends ChangeNotifier {
  Order order = new Order();
  List<OrderData> orderDataList = new List();

  OrderProvider() {
    order.data = orderDataList;
  }

  setDate(Order order) {
    order = order;
    orderDataList = order.data;
    notifyListeners();
  }

  getData() {
    return orderDataList;
  }

  Future<Order> hitApi(tok) async {
    var token = await getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var response =
        await http.get(Uri.parse(baseUrl + 'order/list'), headers: headers);
    Order orderData;
    if (response.statusCode == 200) {
      final Map parsed = jsonDecode(response.body.toString());
      orderData = Order.fromJson(parsed);
    }
    return orderData;
  }
}
