
class CampaignItem {
  List<CampaignProduct> data;

  CampaignItem({
      List<CampaignProduct> data}){
    data = data;
}

  CampaignItem.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(CampaignProduct.fromJson(v));
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


class CampaignProduct {
  dynamic _productId;
  String _image;
  String _name;
  String _price;
  int _campaignId;
  bool _stockOut;
  int _variantStockId;
  List<Variants> _variants;

  dynamic get productId => _productId;
  String get image => _image;
  String get name => _name;
  String get price => _price;
  int get campaignId => _campaignId;
  bool get stockOut => _stockOut;
  int get variantStockId => _variantStockId;
  List<Variants> get variants => _variants;

  CampaignProduct({
      dynamic productId, 
      String image, 
      String name, 
      String price,
      int campaignId,
      bool stockOut, 
      int variantStockId, 
      List<Variants> variants}){
    _productId = productId;
    _image = image;
    _name = name;
    _price = price;
    _campaignId = campaignId;
    _stockOut = stockOut;
    _variantStockId = variantStockId;
    _variants = variants;
}

  CampaignProduct.fromJson(dynamic json) {
    _productId = json["productId"];
    _image = json["image"];
    _name = json["name"];
    _price = json["price"];
    _campaignId = json["campaignId"];
    _stockOut = json["stockOut"];
    _variantStockId = json["variantStockId"];
    if (json["variants"] != null) {
      _variants = [];
      json["variants"].forEach((v) {
        _variants.add(Variants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["productId"] = _productId;
    map["image"] = _image;
    map["name"] = _name;
    map["campaignId"] = _campaignId;
    map["stockOut"] = _stockOut;
    map["variantStockId"] = _variantStockId;
    if (_variants != null) {
      map["variants"] = _variants.map((v) => v.toJson()).toList();
    }
    return map;
  }

}



class Variants {
  bool _stockOut;
  String _discountText;
  String _priceFormat;
  int _price;
  String _extraPriceFormat;
  int _extraPrice;
  String _totalPriceFormat;
  int _totalPrice;
  int _stockId;
  String _variant;

  bool get stockOut => _stockOut;
  String get discountText => _discountText;
  String get priceFormat => _priceFormat;
  int get price => _price;
  String get extraPriceFormat => _extraPriceFormat;
  int get extraPrice => _extraPrice;
  String get totalPriceFormat => _totalPriceFormat;
  int get totalPrice => _totalPrice;
  int get stockId => _stockId;
  String get variant => _variant;

  Variants({
      bool stockOut, 
      String discountText, 
      String priceFormat, 
      int price, 
      String extraPriceFormat, 
      int extraPrice, 
      String totalPriceFormat, 
      int totalPrice, 
      int stockId, 
      String variant}){
    _stockOut = stockOut;
    _discountText = discountText;
    _priceFormat = priceFormat;
    _price = price;
    _extraPriceFormat = extraPriceFormat;
    _extraPrice = extraPrice;
    _totalPriceFormat = totalPriceFormat;
    _totalPrice = totalPrice;
    _stockId = stockId;
    _variant = variant;
}

  Variants.fromJson(dynamic json) {
    _stockOut = json["stockOut"];
    _discountText = json["discountText"];
    _priceFormat = json["priceFormat"];
    _price = json["price"];
    _extraPriceFormat = json["extraPriceFormat"];
    _extraPrice = json["extraPrice"];
    _totalPriceFormat = json["totalPriceFormat"];
    _totalPrice = json["totalPrice"];
    _stockId = json["stockId"];
    _variant = json["variant"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["stockOut"] = _stockOut;
    map["discountText"] = _discountText;
    map["priceFormat"] = _priceFormat;
    map["price"] = _price;
    map["extraPriceFormat"] = _extraPriceFormat;
    map["extraPrice"] = _extraPrice;
    map["totalPriceFormat"] = _totalPriceFormat;
    map["totalPrice"] = _totalPrice;
    map["stockId"] = _stockId;
    map["variant"] = _variant;
    return map;
  }

}