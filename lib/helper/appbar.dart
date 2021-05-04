
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:many_vendor_ecommerce_app/provider/cart.calculate.provider.dart';
import 'package:many_vendor_ecommerce_app/provider/cart_count_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/return.cart.provider.dart';
import 'package:many_vendor_ecommerce_app/screen/cart_screen.dart';
import 'package:provider/provider.dart';
import 'helper.dart';

Widget customAppBar(BuildContext context) {
  Provider.of<CartCount>(context, listen: false).totalQuantity();
  return AppBar(
    elevation: elevation+5,
    iconTheme: IconThemeData(
      color: iconColor,
    ),
    actionsIconTheme: IconThemeData(
      color: iconColor,
    ),
    backgroundColor: Colors.white,
    title: Center(child: Container(
        padding: EdgeInsets.all(40),
        child: Image.asset('assets/mshroobLogo.png',fit: BoxFit.contain,))),
    actions: <Widget>[
      Padding(
        padding:  EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MultiProvider(
                                providers: [
                                  ChangeNotifierProvider<CartCount>.value(value:
                                  CartCount()),
                                  ChangeNotifierProvider<ReturnCartProvider>.value(
                                      value: ReturnCartProvider()),
                                  ChangeNotifierProvider<CartCalculationProvider>.value(
                                      value: CartCalculationProvider()),
                                ],
                                child: CartScreen())));
              },
              child: Stack(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.cart_fill,
                      size: 18,
                      color: iconWhiteColor,),
                    onPressed: null,
                  ),
                  Positioned(
                    left: 21.5,
                      child: Stack(
                        children: <Widget>[
                          Icon(
                              Icons.brightness_1_sharp,
                              size: 16, color: Colors.white),
                          Positioned(
                              top: 2.5,
                              right: 4,
                              child: Center(
                                child: Text(
                                  context
                                      .watch<CartCount>()
                                      .count
                                      .toString(),
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              )),
                        ],
                      )),
                ],
              ),
            )
        ),
      )
    ],
  );
}


Widget customSingleAppBar(BuildContext context, title, colors) {
  Provider.of<CartCount>(context, listen: false).totalQuantity();
  return AppBar(
    elevation: 0,
    iconTheme: IconThemeData(
      color: iconColor,
    ),
    actionsIconTheme: IconThemeData(
      color: iconColor,
    ),
    backgroundColor: Colors.white,
    title: Text(title.toString(),
      style: TextStyle(fontFamily: fontFamily, color: textBlackColor),),
  );
}



