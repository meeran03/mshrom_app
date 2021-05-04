import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/return_cart.dart';
import 'package:many_vendor_ecommerce_app/provider/cart.calculate.provider.dart';
import 'package:many_vendor_ecommerce_app/provider/cart_count_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/district_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/logistic_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/return.cart.provider.dart';
import 'package:many_vendor_ecommerce_app/provider/thana_provider.dart';
import 'package:many_vendor_ecommerce_app/screen/loader_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/signin_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import '../Globals.dart';
import 'checkout.stepper.screen.dart';
import 'drawer_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _keyScaffold = GlobalKey<ScaffoldState>();
  CartData _cartData = new CartData();
  bool isLoading = true;
  dynamic subTotalPrice = 0;
  dynamic totalTax = 0;
  dynamic totalPrice = 0;
  ReturnCart returnCart;

  fetchData() async {
    returnCart =
        await Provider.of<ReturnCartProvider>(context, listen: false).hitApi();
    Provider.of<ReturnCartProvider>(context, listen: false).setData(returnCart);
    setState(() {
      subTotalPrice = returnCart.data.subTotalPrice;
      totalPrice = returnCart.data.totalPrice;
      totalTax = returnCart.data.totalTax;
      _cartData = Provider.of<ReturnCartProvider>(context, listen: false)
          .getData()
          .data;
      isLoading = false;
    });
  }

  _removeCart(index) async {
    _keyScaffold.currentState.showSnackBar(SnackBar(
      padding: EdgeInsets.all(snackBarPadding),
      content: Text('Removed from cart'),
      duration: barDuration,
    ));
    Provider.of<CartCalculationProvider>(context, listen: false)
        .remove(_cartData.products[index], context);
    setState(() {
      _cartData.products.removeAt(index);
    });
    fetchData();
  }

  _checkout(context) async {
    if (await authCheck() != null) {
      pushNewScreen(context,
          screen: MultiProvider(providers: [
            ChangeNotifierProvider<ReturnCartProvider>.value(
                value: ReturnCartProvider()),
            ChangeNotifierProvider<CartCalculationProvider>.value(
                value: CartCalculationProvider()),
            ChangeNotifierProvider<DistrictProvider>.value(
                value: DistrictProvider()),
            ChangeNotifierProvider<ThanaProvider>.value(value: ThanaProvider()),
            ChangeNotifierProvider<LogisticProvider>.value(
                value: LogisticProvider()),
            ChangeNotifierProvider<CartCount>.value(value: CartCount()),
          ], child: MyHomePage()),
          withNavBar: false);
    } else {
      _keyScaffold.currentState.showSnackBar(SnackBar(
        padding: EdgeInsets.all(snackBarPadding),
        content: Text('You need to login first!'),
        duration: barDuration,
      ));

      Timer(Duration(seconds: 1), () {
        pushNewScreen(context, screen: SignInScreen(), withNavBar: false);
      });
    }
  }

  @override
  void initState() {
    statusCheck(context);
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      key: _keyScaffold,
      appBar: customAppBar(context),
      drawer: Drawer(
        child: DrawerScreen(),
      ),
      body: isLoading
          ? LoaderScreen()
          : _cartData.products.length == 0
              ? Empty()
              : RefreshIndicator(
                  onRefresh: () async {
                    return await fetchData();
                  },
                  child: Container(
                    color: Colors.white,
                    height: size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: size.height - (size.height / 2.7),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/background.png'),
                                  fit: BoxFit.cover)),
                          child: ListView.builder(
                              itemCount: _cartData.products.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = _cartData.products[index];
                                /*read the context*/
                                Provider.of<CartCalculationProvider>(context,
                                        listen: false)
                                    .show(item);
                                return Card(
                                  color: Colors.white,
                                  elevation: elevation,
                                  margin: EdgeInsets.all(12),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 100,
                                            child: CachedNetworkImage(
                                              imageUrl: item.img,
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder: (context,
                                                      url, downloadProgress) =>
                                                  Center(
                                                      child: CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation(
                                                                  primaryColor),
                                                          value:
                                                              downloadProgress
                                                                  .progress)),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  Globals.arabic
                                                      ? item.nameAr ?? item.name
                                                      : item.name,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: fontFamily,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: textBlackColor),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 8.0),
                                                  child: Text(
                                                    'Price :' +
                                                        item.price
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: textBlackColor,
                                                        fontFamily: fontFamily,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 8.0),
                                                  child: Text(
                                                    'Sub Price : ${context.watch<CartCalculationProvider>().subPrice}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: textBlackColor,
                                                        fontFamily: fontFamily,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _removeCart(index);
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          child: Icon(
                                                            Icons.add,
                                                            color: Colors.red,
                                                            size: 14,
                                                          ),
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 0.5)),
                                                          height: 30,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          'Remove',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontFamily:
                                                                  fontFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: Colors.white,
                                            padding: EdgeInsets.all(4),
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: IconButton(
                                                    onPressed: () {
                                                      context
                                                          .read<
                                                              CartCalculationProvider>()
                                                          .increment(
                                                              item, context);
                                                      _keyScaffold.currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                        padding: EdgeInsets.all(
                                                            snackBarPadding),
                                                        content: Text(
                                                            'Product quantity increased'),
                                                        duration: barDuration,
                                                      ));
                                                      Future.delayed(
                                                          Duration(
                                                              milliseconds:
                                                                  500), () {
                                                        fetchData();
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: primaryColor,
                                                      size: 14,
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: primaryColor,
                                                          width: 0.5)),
                                                  height: 30,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    context
                                                        .watch<
                                                            CartCalculationProvider>()
                                                        .quantity
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: textBlackColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: primaryColor,
                                                          width: 0.5)),
                                                  height: 30,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      if (item.quantity <= 1) {
                                                        _removeCart(index);
                                                      } else {
                                                        _keyScaffold
                                                            .currentState
                                                            .showSnackBar(
                                                                SnackBar(
                                                          padding: EdgeInsets.all(
                                                              snackBarPadding),
                                                          content: Text(
                                                              'Product quantity decreased'),
                                                          duration: barDuration,
                                                        ));
                                                      }
                                                      context
                                                          .read<
                                                              CartCalculationProvider>()
                                                          .decrement(
                                                              item, context);
                                                      Future.delayed(
                                                          Duration(
                                                              milliseconds:
                                                                  500), () {
                                                        fetchData();
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.remove,
                                                      color: primaryColor,
                                                      size: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: primaryColor, width: 1),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${Globals.arabic ? 'السعر الكلي' : 'Total Price'} : ${subTotalPrice == 0 ? 0 : subTotalPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: 14,
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: FlatButton(
                                    onPressed: () {
                                      _checkout(context);
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          Globals.arabic ? 'الدفع' : 'Checkout',
                                          style: TextStyle(
                                              color: textWhiteColor,
                                              fontFamily: fontFamily),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Icon(
                                          CupertinoIcons.cart_fill,
                                          color: iconWhiteColor,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    ));
  }
}
