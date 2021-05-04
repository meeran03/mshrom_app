

class SliderClass {
  List<SliderData> data;

  SliderClass({
    List<SliderData> data}){
    data = data;
  }

  SliderClass.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(SliderData.fromJson(v));
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



class SliderData {
  int _id;
  String _image;
  String _appActivate;

  int get id => _id;
  String get image => _image;
  String get appActivate => _appActivate;

  SliderData({
    int id,
    String appActivate,
    String image}){
    _id = id;
    _appActivate = appActivate;
    _image = image;
  }

  SliderData.fromJson(dynamic json) {
    _id = json["id"];
    _appActivate = json["appActivate"];
    _image = json["image"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["appActivate"] = _appActivate;
    map["image"] = _image;
    return map;
  }

}

