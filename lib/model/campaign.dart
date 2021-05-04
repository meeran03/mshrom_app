

class CampaignClass {
  List<CampaignData> data;


  CampaignClass({
      List<CampaignData> data}){
    data = data;
}

  CampaignClass.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(CampaignData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (data != null) {
      map["data"] = data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}



class CampaignData {
  int _id;
  String _title;
  String _banner;
  int _offer;
  String _startFrom;
  String _endAt;

  int get id => _id;
  String get title => _title;
  String get banner => _banner;
  int get offer => _offer;
  String get startFrom => _startFrom;
  String get endAt => _endAt;

  CampaignData({
      int id, 
      String title, 
      String banner, 
      //TODO
      int offer, 
      String startFrom, 
      String endAt}){
    _id = id;
    _title = title;
    _banner = banner;
    _offer = offer;
    _startFrom = startFrom;
    _endAt = endAt;
}

  CampaignData.fromJson(dynamic json) {
    _id = json["id"];
    _title = json["title"];
    _banner = json["banner"];
    _offer = json["offer"];
    _startFrom = json["startFrom"];
    _endAt = json["endAt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["title"] = _title;
    map["banner"] = _banner;
    map["offer"] = _offer;
    map["startFrom"] = _startFrom;
    map["endAt"] = _endAt;
    return map;
  }

}