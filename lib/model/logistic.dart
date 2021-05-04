

class LogisticClass {
  List<LogisticData> data;



  LogisticClass({
      List<LogisticData> data}){
    data = data;
}

  LogisticClass.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(LogisticData.fromJson(v));
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



class LogisticData {
  double _rate;
  int _id;
  String _name;
  String _days;

  double get rate => _rate;
  int get id => _id;
  String get name => _name;
  String get days => _days;

  LogisticData({
      double rate, 
      int id, 
      String name, 
      String days}){
    _rate = rate;
    _id = id;
    _name = name;
    _days = days;
}

  LogisticData.fromJson(dynamic json) {
    _rate = json["rate"];
    _id = json["id"];
    _name = json["name"];
    _days = json["days"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["rate"] = _rate;
    map["id"] = _id;
    map["name"] = _name;
    map["days"] = _days;
    return map;
  }

}