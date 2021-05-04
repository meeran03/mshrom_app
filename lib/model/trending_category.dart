class TrendingCategoryHub {
  List<TrendingCategoryData> data;

  TrendingCategoryHub({List<TrendingCategoryData> data}) {
    data = data;
  }

  TrendingCategoryHub.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(TrendingCategoryData.fromJson(v));
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

class TrendingCategoryData {
  int _catId;
  String _name;
  String _nameAr;
  String _image;

  int get catId => _catId;

  String get name => _name;

  String get nameAr => _nameAr;

  String get image => _image;

  TrendingCategoryData({int catId, String name, String nameAr, String image}) {
    _catId = catId;
    _name = name;
    _nameAr = nameAr;
    _image = image;
  }

  TrendingCategoryData.fromJson(dynamic json) {
    _catId = json["catId"];
    _name = json["name"];
    _nameAr = json["name_ar"];
    _image = json["image"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["catId"] = _catId;
    map["name"] = _name;
    map["name_ar"] = _nameAr;
    map["image"] = _image;
    return map;
  }
}
