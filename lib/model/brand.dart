

class BrandClass {
  List<BrandData> data;



  BrandClass({
      List<BrandData> data}){
    data = data;
}

  BrandClass.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(BrandData.fromJson(v));
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


class BrandData {
  int _id;
  String _name;
  String _nameAr;
  String _logo;
  String _banner;

  int get id => _id;
  String get name => _name;
  String get nameAr => _nameAr;
  String get logo => _logo;
  String get banner => _banner;

  BrandData({
      int id, 
      String name, 
      String nameAr,
      String logo,
      String banner}){
    _id = id;
    _name = name;
    _nameAr = nameAr;
    _logo = logo;
    _banner = banner;
}

  BrandData.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _nameAr = json["name_ar"];
    _logo = json["logo"];
    _banner = json["banner"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name_ar"] = _nameAr;
    map["logo"] = _logo;
    map["banner"] = _banner;
    return map;
  }

}