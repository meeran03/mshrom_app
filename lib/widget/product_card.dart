import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:many_vendor_ecommerce_app/Globals.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/cart.dart';
import 'package:many_vendor_ecommerce_app/model/shop_product.dart';
import 'package:many_vendor_ecommerce_app/provider/product.details.provider.dart';
import 'package:many_vendor_ecommerce_app/provider/variant_satus.dart';
import 'package:many_vendor_ecommerce_app/repository/db_connection.dart';
import 'package:many_vendor_ecommerce_app/screen/single_product_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final Size size;
  final ShopProductData product;

  ProductCard({Key key, @required this.size, this.product}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isLove = false;
  DatabaseConnection _databaseConnection = new DatabaseConnection();

  _addToWishList() async {
    final wish = Wishlist(productId: widget.product.productId);
    await _databaseConnection.addWishList(wish);
    setState(() {
      isLove = true;
    });
  }

  removeWishlist() async {
    await _databaseConnection.removeWishlist(widget.product.productId);
    setState(() {
      isLove = false;
    });
  }

  checkIsLove() async {
    var allData = await _databaseConnection.fetchWishList();
    allData.forEach((element) {
      if (widget.product.productId == element.productId) {
        setState(() {
          isLove = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkIsLove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushNewScreen(context,
            screen: MultiProvider(
              providers: [
                ChangeNotifierProvider<ProductDetailsProvider>.value(
                    value: ProductDetailsProvider()),
                ChangeNotifierProvider<VariantStatus>.value(
                    value: VariantStatus()),
              ],
              child: SingleProductScreen(
                shopProductData: widget.product,
              ),
            ));
      },
      child: Card(
        color: Colors.transparent,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.5)),
                  padding: EdgeInsets.all(8),
                  child: CachedNetworkImage(
                    imageUrl: widget.product.image,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(primaryColor),
                                value: downloadProgress.progress)),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 70,
                  child: IconButton(
                    onPressed: () {
                      isLove ? removeWishlist() : _addToWishList();
                    },
                    icon: Icon(
                      isLove
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: secondaryColor,
                      size: 15,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    Globals.arabic
                        ? widget.product.nameAr ?? widget.product.name
                        : widget.product.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w700,
                        color: textBlackColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.product.price,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: fontFamily,
                        color: textBlackColor,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
