class ProductDetails {
  Product data;

  ProductDetails({Product data}) {
    data = data;
  }

  ProductDetails.fromJson(dynamic json) {
    data = json["data"] != null ? Product.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (data != null) {
      map["data"] = data.toJson();
    }
    return map;
  }
}

class Product {
  int productId;
  String name;
  String nameAr;
  dynamic shortDesc;
  String bigDesc;
  bool discountHave;
  String discount;
  String price;
  String catName;
  int catId;
  String brand;
  int brandId;
  int productStockId;
  List<Images> images;
  List<Variants> variants;

  Product(
      {int productId,
      String name,
      String nameAr,
      dynamic shortDesc,
      String bigDesc,
      bool discountHave,
      String discount,
      String price,
      String catName,
      int catId,
      String brand,
      int brandId,
      int productStockId,
      List<Images> images,
      List<Variants> variants}) {
    productId = productId;
    name = name;
    nameAr = nameAr;
    shortDesc = shortDesc;
    bigDesc = bigDesc;
    discountHave = discountHave;
    discount = discount;
    price = price;
    catName = catName;
    catId = catId;
    brand = brand;
    brandId = brandId;
    productStockId = productStockId;
    images = images;
    variants = variants;
  }

  Product.fromJson(dynamic json) {
    productId = json["productId"];
    name = json["name"];
    nameAr = json["name_ar"];
    shortDesc = json["shortDesc"];
    bigDesc = json["bigDesc"];
    discountHave = json["discountHave"];
    discount = json["discount"];
    price = json["price"];
    catName = json["catName"];
    catId = json["catId"];
    brand = json["brand"];
    brandId = json["brandId"];
    productStockId = json["productStockId"];
    if (json["images"] != null) {
      images = [];
      json["images"].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
    if (json["variants"] != null) {
      variants = [];
      json["variants"].forEach((v) {
        variants.add(Variants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["productId"] = productId;
    map["name"] = name;
    map["name_ar"] = nameAr;
    map["shortDesc"] = shortDesc;
    map["bigDesc"] = bigDesc;
    map["discountHave"] = discountHave;
    map["discount"] = discount;
    map["price"] = price;
    map["catName"] = catName;
    map["catId"] = catId;
    map["brand"] = brand;
    map["brandId"] = brandId;
    map["productStockId"] = productStockId;
    if (images != null) {
      map["images"] = images.map((v) => v.toJson()).toList();
    }
    if (variants != null) {
      map["variants"] = variants.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Variants {
  String _unit;
  List<Variant> _variant;

  String get unit => _unit;

  List<Variant> get variant => _variant;

  Variants({String unit, List<Variant> variant}) {
    _unit = unit;
    _variant = variant;
  }

  Variants.fromJson(dynamic json) {
    _unit = json["unit"];
    if (json["variant"] != null) {
      _variant = [];
      json["variant"].forEach((v) {
        _variant.add(Variant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["unit"] = _unit;
    if (_variant != null) {
      map["variant"] = _variant.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Variant {
  int _variantId;
  String _unit;
  bool active;
  String _variant;
  String _code;

  int get variantId => _variantId;

  String get unit => _unit;

  String get variant => _variant;

  String get code => _code;

  Variant(
      {int variantId, String unit, bool active, String variant, String code}) {
    _variantId = variantId;
    _unit = unit;
    active = active;
    _variant = variant;
    _code = code;
  }

  Variant.fromJson(dynamic json) {
    _variantId = json["variantId"];
    _unit = json["unit"];
    active = json["active"];
    _variant = json["variant"];
    _code = json["code"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["variantId"] = _variantId;
    map["unit"] = _unit;
    map["active"] = active;
    map["variant"] = _variant;
    map["code"] = _code;
    return map;
  }
}

class Images {
  String _url;

  String get url => _url;

  Images({String url}) {
    _url = url;
  }

  Images.fromJson(dynamic json) {
    _url = json["url"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["url"] = _url;
    return map;
  }
}
