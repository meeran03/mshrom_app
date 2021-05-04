
import 'package:flutter/material.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/shop_product.dart';
import 'package:many_vendor_ecommerce_app/widget/product_card.dart';


// ignore: must_be_immutable
class ProductScreen extends StatefulWidget {

  List<ShopProductData> shopProductData;
  ProductScreen({this.shopProductData});
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double cellWidth = ((size.width - 24) / ( widget.shopProductData.length <= 9 ? 9 : widget.shopProductData.length >= 40 ? 10 : 20 /2));
    double desiredCellHeight = 70;
    double childAspectRatio = cellWidth / desiredCellHeight;
    return  widget.shopProductData.length == 0 ? Empty(): GridView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.shopProductData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: childAspectRatio,
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, int index) => ProductCard(
          size: size,
          product: widget.shopProductData[index],
        ));
  }
}
