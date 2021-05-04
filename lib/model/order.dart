class Order {
  List<OrderData> data;

  Order({List<OrderData> data}) {
    data = data;
  }

  Order.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(OrderData.fromJson(v));
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


class OrderData {
  int _id;
  int _userId;
  String _name;
  String _orderNumber;
  String _email;
  String _toPhone;
  String _toAddress;
  String _toDivisionName;
  String _toAreaName;
  String _note;
  String _toLogisticName;
  String _formPhone;
  String _formAddress;
  String _logisticCharge;
  String _appliedCoupon;
  String _payAmount;
  String _paymentType;
  String _orderDate;
  List<OrderProduct> _orderProduct;

  int get id => _id;

  int get userId => _userId;

  String get name => _name;

  String get orderNumber => _orderNumber;

  String get email => _email;

  String get toPhone => _toPhone;

  String get toAddress => _toAddress;

  String get toDivisionName => _toDivisionName;

  String get toAreaName => _toAreaName;

  String get note => _note;

  String get toLogisticName => _toLogisticName;

  String get formPhone => _formPhone;

  String get formAddress => _formAddress;

  String get logisticCharge => _logisticCharge;

  String get appliedCoupon => _appliedCoupon;

  String get payAmount => _payAmount;

  String get paymentType => _paymentType;

  String get orderDate => _orderDate;

  List<OrderProduct> get orderProduct => _orderProduct;

  OrderData(
      {int id,
      int userId,
      String name,
      String orderNumber,
      String email,
      String toPhone,
      String toAddress,
      String toDivisionName,
      String toAreaName,
      String note,
      String toLogisticName,
      String formPhone,
      String formAddress,
      String logisticCharge,
      String appliedCoupon,
      String payAmount,
      String paymentType,
      String orderDate,
      List<OrderProduct> orderProduct}) {
    _id = id;
    _userId = userId;
    _name = name;
    _orderNumber = orderNumber;
    _email = email;
    _toPhone = toPhone;
    _toAddress = toAddress;
    _toDivisionName = toDivisionName;
    _toAreaName = toAreaName;
    _note = note;
    _toLogisticName = toLogisticName;
    _formPhone = formPhone;
    _formAddress = formAddress;
    _logisticCharge = logisticCharge;
    _appliedCoupon = appliedCoupon;
    _payAmount = payAmount;
    _paymentType = paymentType;
    _orderDate = orderDate;
    _orderProduct = orderProduct;
  }

  OrderData.fromJson(dynamic json) {
    _id = json["id"];
    _userId = json["userId"];
    _name = json["name"];
    _orderNumber = json["orderNumber"];
    _email = json["email"];
    _toPhone = json["toPhone"];
    _toAddress = json["toAddress"];
    _toDivisionName = json["toDivisionName"];
    _toAreaName = json["toAreaName"];
    _note = json["note"];
    _toLogisticName = json["toLogisticName"];
    _formPhone = json["formPhone"];
    _formAddress = json["formAddress"];
    _logisticCharge = json["logisticCharge"];
    _appliedCoupon = json["appliedCoupon"];
    _payAmount = json["payAmount"];
    _paymentType = json["paymentType"];
    _orderDate = json["orderDate"];
    if (json["orderProduct"] != null) {
      _orderProduct = [];
      json["orderProduct"].forEach((v) {
        _orderProduct.add(OrderProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["userId"] = _userId;
    map["name"] = _name;
    map["orderNumber"] = _orderNumber;
    map["email"] = _email;
    map["toPhone"] = _toPhone;
    map["toAddress"] = _toAddress;
    map["toDivisionName"] = _toDivisionName;
    map["toAreaName"] = _toAreaName;
    map["note"] = _note;
    map["toLogisticName"] = _toLogisticName;
    map["formPhone"] = _formPhone;
    map["formAddress"] = _formAddress;
    map["logisticCharge"] = _logisticCharge;
    map["appliedCoupon"] = _appliedCoupon;
    map["payAmount"] = _payAmount;
    map["paymentType"] = _paymentType;
    map["orderDate"] = _orderDate;
    if (_orderProduct != null) {
      map["orderProduct"] = _orderProduct.map((v) => v.toJson()).toList();
    }
    return map;
  }
}



class OrderProduct {
  String _bookingCode;
  String _orderNumber;
  String _shop;
  String _productName;
  String _productImage;
  String _productPrice;
  String _quantity;
  String _status;

  String get bookingCode => _bookingCode;

  String get orderNumber => _orderNumber;

  String get shop => _shop;

  String get productName => _productName;

  String get productImage => _productImage;

  String get productPrice => _productPrice;

  String get quantity => _quantity;

  String get status => _status;

  OrderProduct(
      {String bookingCode,
      String orderNumber,
      String shop,
      String productName,
      String productImage,
      String productPrice,
      String quantity,
      String status}) {
    _bookingCode = bookingCode;
    _orderNumber = orderNumber;
    _shop = shop;
    _productName = productName;
    _productImage = productImage;
    _productPrice = productPrice;
    _quantity = quantity;
    _status = status;
  }

  OrderProduct.fromJson(dynamic json) {
    _bookingCode = json["bookingCode"];
    _orderNumber = json["orderNumber"];
    _shop = json["shop"];
    _productName = json["productName"];
    _productImage = json["productImage"];
    _productPrice = json["productPrice"];
    _quantity = json["quantity"];
    _status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["bookingCode"] = _bookingCode;
    map["orderNumber"] = _orderNumber;
    map["shop"] = _shop;
    map["productName"] = _productName;
    map["productImage"] = _productImage;
    map["productPrice"] = _productPrice;
    map["quantity"] = _quantity;
    map["status"] = _status;
    return map;
  }
}
