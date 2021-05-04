
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/product_details.dart';
import 'package:http/http.dart' as http;

class ProductDetailsProvider extends ChangeNotifier{
  ProductDetails _details = new ProductDetails();
  Product _product = new Product();
  List<Variants> variants =[];
  /*this for variant change */
  Variant variant;

  ProductDetailsProvider(){
    _details.data = _product;
    _details.data.variants = variants;
  }

  setData(ProductDetails details){
    _details = details;
    variants = _details.data.variants;
    notifyListeners();
  }

  getData(){
    return _details.data;
  }

  getVariant(){
    return variants;
  }

  Future<ProductDetails> hitApi(id) async{
    var response = await http.get(Uri.parse(baseUrl+'product/'+id.toString()));
    ProductDetails details;
    if(response.statusCode == 200){
      print('product details ${response.body.toString()}');
      final Map parsed = jsonDecode(response.body.toString());
      details = ProductDetails.fromJson(parsed);
    }
    return details;
  }
}