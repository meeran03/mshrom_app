

class ShopHub {
  List<ShopData> data;


  ShopHub({
      List<ShopData> data}){
    data = data;
}

  ShopHub.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(ShopData.fromJson(v));
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


class ShopData {
  int _id;
  String _name;
  int _vendorId;
  String _shopLogo;
  String _shopName;
  String _phone;
  String _address;
  String _about;
  String _facebook;
  int _totalProduct;
  int _rating;

  int get id => _id;
  String get name => _name;
  int get vendorId => _vendorId;
  String get shopLogo => _shopLogo;
  String get shopName => _shopName;
  String get phone => _phone;
  String get address => _address;
  String get about => _about;
  String get facebook => _facebook;
  int get totalProduct => _totalProduct;
  int get rating => _rating;

  ShopData({
      int id, 
      String name, 
      int vendorId, 
      String shopLogo, 
      String shopName, 
      String phone, 
      String address, 
      String about, 
      String facebook, 
      int totalProduct, 
      int rating}){
    _id = id;
    _name = name;
    _vendorId = vendorId;
    _shopLogo = shopLogo;
    _shopName = shopName;
    _phone = phone;
    _address = address;
    _about = about;
    _facebook = facebook;
    _totalProduct = totalProduct;
    _rating = rating;
}

  ShopData.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _vendorId = json["vendorId"];
    _shopLogo = json["shopLogo"];
    _shopName = json["shopName"];
    _phone = json["phone"];
    _address = json["address"];
    _about = json["about"];
    _facebook = json["facebook"];
    _totalProduct = json["totalProduct"];
    _rating = json["rating"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["vendorId"] = _vendorId;
    map["shopLogo"] = _shopLogo;
    map["shopName"] = _shopName;
    map["phone"] = _phone;
    map["address"] = _address;
    map["about"] = _about;
    map["facebook"] = _facebook;
    map["totalProduct"] = _totalProduct;
    map["rating"] = _rating;
    return map;
  }

}