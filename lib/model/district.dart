

class DistrictClass {
  List<DistrictData> data;

  DistrictClass({List<DistrictData> data}){
    data = data;
  }

  DistrictClass.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(DistrictData.fromJson(v));
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


class DistrictData {
  int _id;
  String _district;

  int get id => _id;
  String get district => _district;

  DistrictData({
      int id,
      String district}){
    _id = id;
    _district = district;
}

  DistrictData.fromJson(dynamic json) {
    _id = json["id"];
    _district = json["district"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["district"] = _district;
    return map;
  }

}