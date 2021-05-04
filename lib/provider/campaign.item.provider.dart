
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/campaign_item.dart';
import 'package:http/http.dart' as http;


class CampaignItemProvider extends ChangeNotifier{
  CampaignItem _campaignItem = new CampaignItem();

  setData(CampaignItem item){
    _campaignItem = item;
    notifyListeners();
  }

  getData(){
    return _campaignItem.data;
  }

  Future<CampaignItem> hitApi(id) async{
    var response = await http.get(Uri.parse(baseUrl+'campaign/'+id.toString()));
    CampaignItem campaignItem;
    if(response.statusCode == 200){
      final Map parsed = jsonDecode(response.body.toString());
      campaignItem = CampaignItem.fromJson(parsed);
    }
    return campaignItem;
  }

}