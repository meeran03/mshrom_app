import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/brand.dart';
import 'package:many_vendor_ecommerce_app/model/cart.dart';
import 'package:many_vendor_ecommerce_app/model/product_details.dart';
import 'package:many_vendor_ecommerce_app/model/shop_product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:many_vendor_ecommerce_app/model/trending_category.dart';
import 'package:many_vendor_ecommerce_app/provider/cart_count_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/product.details.provider.dart';
import 'package:many_vendor_ecommerce_app/provider/variant_satus.dart';
import 'package:many_vendor_ecommerce_app/repository/db_connection.dart';
import 'package:many_vendor_ecommerce_app/screen/loader_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/single_brand.dart';
import 'package:many_vendor_ecommerce_app/screen/single_category_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../Globals.dart';

// ignore: must_be_immutable
class SingleProductScreen extends StatefulWidget {
  ShopProductData shopProductData;

  SingleProductScreen({@required this.shopProductData});

  @override
  _SingleProductScreenState createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = true;
  ProductDetails details;

  int productStockId = 0;

  // final forCart
  Product _product;
  bool isLove = false;
  List<Widget> images = new List();
  String cartText = Globals.arabic ? 'أضف إلى السلة' : 'Add To Cart';
  bool stock = true;
  List<Variants> apiVariant = [];

  void sortingForCartShop(Variant data) async {
    Provider.of<VariantStatus>(context, listen: false).changeStatus(data);
    String variantForSorting = "";
    /*here the call api with variant data*/
    details.data.variants.forEach((element) {
      element.variant.forEach((element2) {
        if (element2.active) {
          if (variantForSorting == "") {
            variantForSorting += element2.variantId.toString();
          } else {
            variantForSorting += '-' + element2.variantId.toString();
          }
        }
      });
    });
    try {
      /*here the call api for product stock id*/
      var response = await http.get(Uri.parse(baseUrl +
          'variant/stock/id/$variantForSorting/${_product.productId}'));
      var value = jsonDecode(response.body.toString());
      if (value['productHave'] == true) {
        setState(() {
          productStockId = value['productStockId'];
          _product.price = value['totalPriceFormat'];
          if (value['stock'] == true) {
            stock = true;
            cartText = value['stock_out'];
          } else {
            stock = false;
            cartText = value['stock_out'];
          }
        });
      } else {
        setState(() {
          productStockId = 0;
        });
        showInSnackBar(value['message']);
      }
    } catch (e) {
      setState(() {
        productStockId = 0;
        showInSnackBar('Please Select the variant');
      });
    }
  }

  fetchSingleData() async {
    details = await Provider.of<ProductDetailsProvider>(context, listen: false)
        .hitApi(widget.shopProductData.productId);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .setData(details);
    setState(() {
      apiVariant = Provider.of<ProductDetailsProvider>(context, listen: false)
          .getVariant();
      _product =
          Provider.of<ProductDetailsProvider>(context, listen: false).getData();
      productStockId = _product.productStockId;
      _product.images.forEach((element) {
        images.add(CachedNetworkImage(
          imageUrl: element.url,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  valueColor: AlwaysStoppedAnimation(primaryColor))),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ));
        isLoading = false;
      });

      /*here the variant*/
    });
  }

  DatabaseConnection _databaseConnection = new DatabaseConnection();

  removeWishlist() async {
    await _databaseConnection.removeWishlist(widget.shopProductData.productId);
    setState(() {
      isLove = false;
    });
  }

  checkIsLove() async {
    var allData = await _databaseConnection.fetchWishList();
    allData.forEach((element) {
      if (widget.shopProductData.productId == element.productId) {
        setState(() {
          isLove = true;
        });
      }
    });
  }

  _addToCart(stokid, context) async {
    if (stokid == 0) {
      showInSnackBar('Please select the variant');
    } else {
      final cart = Cart(vendorStockId: stokid);
      await _databaseConnection.addToCartWithIncrement(cart);
      Provider.of<CartCount>(context, listen: false).totalQuantity();
      showInSnackBar('Added to cart');
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        padding: EdgeInsets.all(snackBarPadding),
        content: Text(value),
        duration: barDuration));
  }

  @override
  void initState() {
    statusCheck(context);
    fetchSingleData();
    checkIsLove();
    super.initState();
  }

  Widget _variantsData(BuildContext context) {
    List<Widget> variantWidget = [];
    List<Variant> allVariant = [];
    apiVariant.forEach((element) {
      if (element.variant.length > 0) {
        /*here setup the variant*/
        List<Widget> variants = [];
        element.variant.forEach((variant) {
          variants.add(
            variant.code == null
                ? GestureDetector(
                    onTap: () {
                      sortingForCartShop(variant);
                    },
                    child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius:
                                BorderRadius.circular(variant.active ? 10 : 1),
                            color: !variant.active
                                ? textWhiteColor
                                : textBlackColor),
                        child: Text(
                          variant.variant.toUpperCase(),
                          style: TextStyle(
                              color: variant.active
                                  ? textWhiteColor
                                  : textBlackColor),
                        )),
                  )
                : GestureDetector(
                    onTap: () {
                      sortingForCartShop(variant);
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Color(
                            int.parse(variant.code.replaceAll('#', '0xff'))),
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius:
                            BorderRadius.circular(variant.active ? 10 : 1),
                      ),
                    ),
                  ),
          );
          allVariant.add(variant);
        });

        /*setup the variant ways unit*/
        variantWidget.add(Container(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  element.unit.toString(),
                  style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 18,
                      color: textBlackColor,
                      fontWeight: FontWeight.bold),
                ),
                Divider(
                  height: 5,
                  color: Colors.transparent,
                ),
                Wrap(
                  runSpacing: 20.0,
                  spacing: 10.0,
                  children: variants,
                )
                /*here the list*/
              ],
            )));
      }
    });
    Provider.of<VariantStatus>(context, listen: false).setVariant(allVariant);
    return Column(children: variantWidget);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoaderScreen()
        : Scaffold(
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            appBar: customAppBar(context),
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover)),
              child: ListView(
                children: <Widget>[
                  ProductSlider(
                    img: images,
                    discountHave: _product.discountHave,
                    productId: widget.shopProductData.productId,
                  ),

                  Container(
                    padding: EdgeInsets.only(
                        top: 30, bottom: 10, right: 10, left: 10),
                    color: colorConvert('#f5f9ff'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            Globals.arabic
                                ? _product.nameAr ?? _product.name
                                : _product.name,
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.bold,
                                color: textBlackColor,
                                fontSize: 18)),
                        Divider(
                          color: Colors.transparent,
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Price : ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontFamily,
                                  color: textBlackColor,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              _product.price,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontFamily,
                                  color: textBlackColor,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        _product.bigDesc != null
                            ? Padding(
                                padding: EdgeInsets.all(8),
                                child: ExpandablePanel(
                                  header: Text(
                                    'Item Description',
                                    style: TextStyle(
                                        color: textBlackColor,
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  collapsed: Text(
                                    _product.bigDesc,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  expanded: Text(
                                    _product.bigDesc,
                                    softWrap: true,
                                    style: TextStyle(color: textBlackColor),
                                  ),
                                ),
                              )
                            : Container(),
                        //todo:there are variant
                        SizedBox(
                          height: 10,
                        ),
                        /*todo:here the variant*/
                        _variantsData(context),
                        SizedBox(
                          height: 30,
                        ),
                        Wrap(
                          children: [
                            GestureDetector(
                              onTap: () {
                                TrendingCategoryData _re;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SingleCategoryScreen(
                                              id: _product.catId,
                                              trendingCategoryData: _re,
                                            )));
                              },
                              child: Row(
                                children: [
                                  Text('Category : ',
                                      style: TextStyle(
                                          fontFamily: fontFamily,
                                          color: textBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  Text(_product.catName,
                                      style: TextStyle(
                                          fontFamily: fontFamily,
                                          color: textBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                                onTap: () {
                                  BrandData brandData;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SingleBrandProductScreen(
                                                brandData: brandData,
                                                id: _product.brandId,
                                              )));
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'Brand : ',
                                      style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: 14,
                                          color: textBlackColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      _product.brand,
                                      style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: 14,
                                          color: textBlackColor,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 30,
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          cartText.contains("add to cart")
                              ? Globals.arabic
                                  ? 'أضف إلى السلة'
                                  : 'Add To Cart'
                              : cartText,
                          style: TextStyle(
                              fontFamily: fontFamily, color: textWhiteColor),
                        ),
                      ),
                    ),
                    onTap: () {
                      if (productStockId == 0) {
                        showInSnackBar('Please select the Variant');
                      } else {
                        if (stock) {
                          _addToCart(productStockId, context);
                        } else {
                          showInSnackBar(cartText.contains("add to cart")
                              ? Globals.arabic
                                  ? 'أضف إلى السلة'
                                  : 'Add To Cart'
                              : cartText);
                        }
                      }
                    },
                  ),
                  //todo :Related Product
                  Container(
                    height: 100,
                  )
                ],
              ),
            ));
  }
}

// ignore: must_be_immutable
class ProductSlider extends StatefulWidget {
  List<Widget> img = [];
  bool discountHave;
  int productId;

  ProductSlider({this.img, this.discountHave, this.productId});

  @override
  _ProductSliderState createState() => _ProductSliderState();
}

class _ProductSliderState extends State<ProductSlider> {
  int currentIndex = 0;
  PageController pageController = new PageController(initialPage: 0);

  bool isLove = false;
  DatabaseConnection _databaseConnection = new DatabaseConnection();

  _addToWishList() async {
    final wish = Wishlist(productId: widget.productId);
    await _databaseConnection.addWishList(wish);
    setState(() {
      isLove = true;
    });
  }

  removeWishlist() async {
    await _databaseConnection.removeWishlist(widget.productId);
    setState(() {
      isLove = false;
    });
  }

  checkIsLove() async {
    var allData = await _databaseConnection.fetchWishList();
    allData.forEach((element) {
      if (widget.productId == element.productId) {
        setState(() {
          isLove = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkIsLove();
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (currentIndex < widget.img.length) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
      pageController.animateToPage(
        currentIndex,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  Widget pageIndexIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? primaryColor : Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 4, bottom: 4),
          height: size.height / 2,
          width: size.width,
          child: widget.img.length > 0
              ? PageView.builder(
                  onPageChanged: (val) {
                    setState(() {
                      currentIndex = val;
                    });
                  },
                  controller: pageController,
                  itemCount: widget.img.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      fit: StackFit.loose,
                      overflow: Overflow.visible,
                      children: [
                        Container(width: size.width, child: widget.img[index]),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (int i = 0; i < widget.img.length; i++)
                                      currentIndex == i
                                          ? pageIndexIndicator(true)
                                          : pageIndexIndicator(false)
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    );
                  })
              : Container(),
        ),
        Positioned(
          width: size.width,
          left: size.width - (size.width - 150),
          child: widget.discountHave == true
              ? Container(
                  height: 100,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/discount.png'),
                      )),
                )
              : Container(),
        ),
        Positioned(
            width: size.width,
            bottom: 40,
            left: size.width - (size.width - 150),
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () {
                  isLove ? removeWishlist() : _addToWishList();
                },
                icon: isLove
                    ? Icon(
                        FontAwesomeIcons.solidHeart,
                        color: secondaryColor,
                      )
                    : Icon(
                        FontAwesomeIcons.heart,
                        color: secondaryColor,
                      ),
              ),
            )),
      ],
    );
  }
}
