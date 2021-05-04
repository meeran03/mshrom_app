import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/slider.dart';
import 'package:http/http.dart' as http;

class SliderProvider extends ChangeNotifier {
  bool isLoading = true;
  SliderClass _slider = new SliderClass();
  List<SliderData> list = new List();

  SliderProvider() {
    _slider.data = list;
  }

  setData(SliderClass slider) {
    _slider = slider;
    isLoading = false;
    notifyListeners();
  }

  getData() {
    return _slider.data;
  }

  Future<SliderClass> hitApi() async {
    try {
      var response = await http.get(Uri.parse(baseUrl + 'sliders'));
      SliderClass slider;
      if (response.statusCode == 200) {
        final Map parsed = jsonDecode(response.body.toString());
        slider = SliderClass.fromJson(parsed);
      }
      return slider;
    } catch (e) {

      return null;
    }

  }
}
