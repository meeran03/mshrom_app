

class ShopProductHub {
  List<ShopProductData> data;

  ShopProductHub({
      List<ShopProductData> data}){
    data = data;
}

  ShopProductHub.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(ShopProductData.fromJson(v));
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



class ShopProductData {
  dynamic _productId;
  String _name;
  String _nameAr;
  String _image;
  String _slug;
  //TODO
  int _sku;
  String _discount;
  bool _discountHave;
  String _price;

  dynamic get productId => _productId;
  String get name => _name;
  String get nameAr => _nameAr;
  String get image => _image;
  String get slug => _slug;
  int get sku => _sku;
  String get discount => _discount;
  bool get discountHave => _discountHave;
  String get price => _price;

  ShopProductData({
      dynamic productId, 
      String name, 
      String nameAr,
      String image,
      String slug, 
      int sku, 
      String discount, 
      bool discountHave,
      String price}){
    _productId = productId;
    _name = name;
    _nameAr = nameAr;
    _image = image;
    _slug = slug;
    _sku = sku;
    _discount = discount;
    _discountHave = discountHave;
    _price = price;
}

  ShopProductData.fromJson(dynamic json) {
    _productId = json["productId"];
    _name = json["name"];
    _nameAr = json["name_ar"];
    _image = json["image"];
    _slug = json["slug"];
    _sku = json["sku"];
    _discount = json["discount"];
    _discountHave = json["discountHave"];
    _price = json["price"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["productId"] = _productId;
    map["name"] = _name;
    map["name_ar"] = _nameAr;
    map["image"] = _image;
    map["slug"] = _slug;
    map["sku"] = _sku;
    map["discount"] = _discount;
    map["discountHave"] = _discountHave;
    map["price"] = _price;
    return map;
  }

}