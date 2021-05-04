import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/campaign.dart';
import 'package:http/http.dart' as http;

class CampaignProvider extends ChangeNotifier {
  bool isLoading = true;
  CampaignClass _campaign = new CampaignClass();

  setData(CampaignClass campaign) {
    _campaign = campaign;
    isLoading = false;
    notifyListeners();
  }

  getData() {
    return _campaign.data;
  }

  Future<CampaignClass> campaignHitApi() async {
    var response = await http.get(Uri.parse(baseUrl + 'campaigns'));
    CampaignClass campaign;
    if (response.statusCode == 200) {
      final Map parsed = jsonDecode(response.body.toString());
      campaign = CampaignClass.fromJson(parsed);
    }
    return campaign;
  }
}
