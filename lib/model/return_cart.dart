

class ReturnCart {
  CartData data;


  ReturnCart({
    CartData data}){
    data = data;
}

  ReturnCart.fromJson(dynamic json) {
    data = json["data"] != null ? CartData.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (data != null) {
      map["data"] = data.toJson();
    }
    return map;
  }

}



class CartData {
  dynamic subTotalPrice;
  String subTotalPriceFormat;
  dynamic totalTax;
  String totalTaxFormat;
  String totalPriceFormat;
  dynamic totalPrice;
  List<Products> products;



  CartData({
    dynamic subTotalPrice,
      String subTotalPriceFormat,
    dynamic totalTax,
      String totalTaxFormat, 
      String totalPriceFormat,
    dynamic totalPrice,
      List<Products> products}){
    subTotalPrice = subTotalPrice;
    subTotalPriceFormat = subTotalPriceFormat;
    totalTax = totalTax;
    totalTaxFormat = totalTaxFormat;
    totalPriceFormat = totalPriceFormat;
    totalPrice = totalPrice;
    products = products;
}

  CartData.fromJson(dynamic json) {
    subTotalPrice = json["subTotalPrice"];
    subTotalPriceFormat = json["subTotalPriceFormat"];
    totalTax = json["totalTax"];
    totalTaxFormat = json["totalTaxFormat"];
    totalPriceFormat = json["totalPriceFormat"];
    totalPrice = json["totalPrice"];
    if (json["products"] != null) {
      products = [];
      json["products"].forEach((v) {
        products.add(Products.fromJson(v));
      });
    }
  }


  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["subTotalPrice"] = subTotalPrice;
    map["subTotalPriceFormat"] = subTotalPriceFormat;
    map["totalTax"] = totalTax;
    map["totalTaxFormat"] = totalTaxFormat;
    map["totalPriceFormat"] = totalPriceFormat;
    map["totalPrice"] = totalPrice;
    if (products != null) {
      map["products"] = products.map((v) => v.toJson()).toList();
    }
    return map;
  }

}



class Products {
  int productId;
  int vendorStockId;
  String img;
  String name;
  String nameAr;
  int quantity;
  dynamic campaign;
  dynamic campaignId;
  String priceFormat;
  dynamic price;
  dynamic subPrice;
  String subPriceFormat;
  String shopName;

  Products({
      int productId, 
      int vendorStockId,
      String img,
      String name, 
      String nameAr,
      int quantity,
      dynamic campaign,
      dynamic campaignId,
      String priceFormat,
    dynamic price,
    dynamic subPrice,
      String subPriceFormat, 
      String shopName}){
    productId = productId;
    vendorStockId = vendorStockId;
    img = img;
    name = name;
    nameAr = nameAr;
    quantity = quantity;
    campaign = campaign;
    campaignId = campaignId;
    priceFormat = priceFormat;
    price = price;
    subPrice = subPrice;
    subPriceFormat = subPriceFormat;
    shopName = shopName;
}

  Products.fromJson(dynamic json) {
    productId = json["productId"];
    vendorStockId = json["vendorStockId"];
    img = json["img"];
    name = json["name"];
    nameAr = json["name_ar"];
    quantity = json["quantity"];
    campaign = json["campaign"];
    campaignId = json["campaignId"];
    priceFormat = json["priceFormat"];
    price = json["price"];
    subPrice = json["subPrice"];
    subPriceFormat = json["subPriceFormat"];
    shopName = json["shopName"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["productId"] = productId;
    map["vendorStockId"] = vendorStockId;
    map["img"] = img;
    map["name"] = name;
    map["name_ar"] = nameAr;
    map["quantity"] = quantity;
    map["campaign"] = campaign;
    map["campaignId"] = campaignId;
    map["priceFormat"] = priceFormat;
    map["price"] = price;
    map["subPrice"] = subPrice;
    map["subPriceFormat"] = subPriceFormat;
    map["shopName"] = shopName;
    return map;
  }

}