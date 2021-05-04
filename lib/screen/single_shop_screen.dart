import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/shop.dart';
import 'package:many_vendor_ecommerce_app/model/shop_product.dart';
import 'package:many_vendor_ecommerce_app/provider/shop_product_provider.dart';
import 'package:many_vendor_ecommerce_app/screen/product_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SingleShopScreen extends StatefulWidget {
  ShopData shopData;
  SingleShopScreen({this.shopData});
  @override
  _SingleShopScreenState createState() => _SingleShopScreenState();
}

class _SingleShopScreenState extends State<SingleShopScreen> {
  List<ShopProductData> shopProductData;
  bool isLoading = true;
  getShopProduct() async {
    ShopProductHub shopProduct =
        await Provider.of<ShopProductProvider>(context, listen: false)
            .hitApi(widget.shopData.vendorId);

    /*set data*/
    Provider.of<ShopProductProvider>(context, listen: false)
        .setData(shopProduct);
    setState(() {
      shopProductData =
          Provider.of<ShopProductProvider>(context, listen: false).getData();
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    statusCheck(context);
    getShopProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppBar(context),
        body: ListView(
          children: [
            Container(
              height: size.height / 3,
              width: size.width,
              child: CachedNetworkImage(
                imageUrl: widget.shopData.shopLogo,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(primaryColor),
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.shopData.shopName ?? '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: fontFamily,
                              color: textBlackColor),
                        ),
                        Text(
                          'Total Product : ' +
                                  widget.shopData.totalProduct.toString() ??
                              '',
                          style: TextStyle(
                              fontFamily: fontFamily, color: textBlackColor),
                        )
                      ],
                    ),
                  ),
                  RatingBar(
                    initialRating: widget.shopData.rating.toDouble(),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 14.0,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                ],
              ),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(primaryColor)),
                  )
                : ProductScreen(
                    shopProductData: shopProductData,
                  )
          ],
        ),
      ),
    );
  }
}
