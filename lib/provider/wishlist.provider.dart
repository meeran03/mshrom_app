import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/cart.dart';
import 'package:many_vendor_ecommerce_app/model/shop_product.dart';
import 'package:many_vendor_ecommerce_app/repository/db_connection.dart';

class WishlistProvider extends ChangeNotifier {
  bool isLoading = true;
  ShopProductHub _wishlistProductHub = new ShopProductHub();
  List<ShopProductData> list = new List();

  WishlistProvider() {
    _wishlistProductHub.data = list;
  }

  setData(ShopProductHub wishlistProductHub) {
    _wishlistProductHub = wishlistProductHub;
    isLoading = false;
    notifyListeners();
  }

  getData() {
    return _wishlistProductHub.data;
  }

  Future<ShopProductHub> hitApi() async {
    /*get data form database*/
    DatabaseConnection _connection = DatabaseConnection();
    List<Wishlist> datas = await _connection.fetchWishList();
    List<int> list = List();
    datas.forEach((element) {
      list.add(element.productId);
    });
    String wishlist = jsonEncode(list);
    var response = await http
        .post(Uri.parse(baseUrl + 'wishlist'), body: {'wishlists': wishlist});
    ShopProductHub wishlistProductHub;
    if (response.statusCode == 200) {
      final Map parsed = jsonDecode(response.body.toString());
      wishlistProductHub = ShopProductHub.fromJson(parsed);
    }
    return wishlistProductHub;
  }
}
