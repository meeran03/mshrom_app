
class Cart{
  int id;
  int vendorStockId;
  int campaignId;
  int quantity;

  Cart({this.id,this.vendorStockId,this.quantity,this.campaignId});

  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      'id':id,
       'vendorStockId' : vendorStockId,
       'campaignId' : campaignId,
      'quantity':quantity
    };
  }

}


class Wishlist{
  int id;
  int productId;

  Wishlist({this.id,this.productId});

  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      'id':id,
      'productId':productId
    };
  }
}