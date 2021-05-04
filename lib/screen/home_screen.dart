
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/provider/brand_product_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/brand_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/campaign.item.provider.dart';
import 'package:many_vendor_ecommerce_app/provider/campaign_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/cart.calculate.provider.dart';
import 'package:many_vendor_ecommerce_app/provider/cart_count_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/category_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/district_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/logistic_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/order_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/product.details.provider.dart';
import 'package:many_vendor_ecommerce_app/provider/return.cart.provider.dart';
import 'package:many_vendor_ecommerce_app/provider/shop_product_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/slider_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/thana_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/trading_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/trending_cat_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/wishlist.provider.dart';
import 'package:many_vendor_ecommerce_app/screen/categories_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/main_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/search_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/wishlist_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PersistentTabController _controller;
  String email;
  String name;
  String avatar;
  String token;

  @override
  void initState() {
    statusCheck(context);
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }





  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return showDialog(context: context,builder: (context)=>AlertDialog(
          title: Text('Do you really want to exit the app?'),
          actions: [
            FlatButton(onPressed: () {
              Navigator.of(context).pop(false);
            }, child: Text('NO')),
            FlatButton(onPressed: (){
              exit(0);
            }, child: Text('YES')),
          ],
        ));
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ShopProductProvider>.value(
              value: ShopProductProvider()),
          ChangeNotifierProvider<SliderProvider>.value(value: SliderProvider()),
          ChangeNotifierProvider<TradingProductProvider>.value(
              value: TradingProductProvider()),
          ChangeNotifierProvider<TrendingCategoryProvider>.value(
              value: TrendingCategoryProvider()),
          ChangeNotifierProvider<CampaignProvider>.value(
              value: CampaignProvider()),
          ChangeNotifierProvider<BrandProvider>.value(value: BrandProvider()),
          ChangeNotifierProvider<BrandProductProvider>.value(
              value: BrandProductProvider()),
          ChangeNotifierProvider<CategoryProvider>.value(
              value: CategoryProvider()),
          ChangeNotifierProvider<ProductDetailsProvider>.value(
              value: ProductDetailsProvider()),
          ChangeNotifierProvider<WishlistProvider>.value(
              value: WishlistProvider()),
          ChangeNotifierProvider<CampaignItemProvider>.value(
              value: CampaignItemProvider()),
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
          ChangeNotifierProvider<OrderProvider>.value(value: OrderProvider()),
          ChangeNotifierProvider<TotalPayment>.value(value: TotalPayment()),
        ],
        child: MaterialApp(
          title: appName,
          debugShowCheckedModeBanner: false,
          color: Colors.white,
          theme: ThemeData(
            iconTheme: IconThemeData(
              color: primaryColor,
            ),
            fontFamily : fontFamily,
            brightness: Brightness.light,
            primaryColor: Colors.blue,
            accentColor:Colors.blueAccent,
            primaryIconTheme: IconThemeData(
              color: primaryColor,
            ),
            indicatorColor: secondaryColor,
            textSelectionColor: secondaryColor,
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.light,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home:  PersistentTabView(
            controller: _controller,
            screens: [
              MainScreen(),
              CategoriesScreen(),
              WishListScreen(),
              SearchScreen(),
            ],
            items: [
              PersistentBottomNavBarItem(
                icon: Icon(FontAwesomeIcons.home,size: 16,),
                titleStyle: TextStyle(color: textWhiteColor,fontFamily: fontFamily),
                activeContentColor: primaryColor,
                title: ("Home"),
                activeColor: primaryColor,
                inactiveColor: CupertinoColors.systemGrey,
              ),
              PersistentBottomNavBarItem(
                icon: Icon(FontAwesomeIcons.list,size: 16,),
                titleStyle: TextStyle(color: textWhiteColor,fontFamily: fontFamily),
                title: ("Category"),
                activeContentColor: primaryColor,
                activeColor: primaryColor,
                inactiveColor: CupertinoColors.systemGrey,
              ),
              PersistentBottomNavBarItem(
                icon: Icon(CupertinoIcons.suit_heart),
                titleStyle: TextStyle(color: textWhiteColor,fontFamily: fontFamily),
                title: ("Wishlist"),
                activeContentColor: primaryColor,
                activeColor: primaryColor,
                inactiveColor: CupertinoColors.systemGrey,
              ),
              PersistentBottomNavBarItem(
                icon: Icon(CupertinoIcons.search),
                titleStyle: TextStyle(color: textWhiteColor,fontFamily: fontFamily),
                title: ("Search"),
                activeContentColor:primaryColor,
                activeColor: primaryColor,
                inactiveColor: CupertinoColors.systemGrey,
              ),
            ],
            confineInSafeArea: true,
            backgroundColor: Colors.white,
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            // This needs to be true if you want to move up the screen when keyboard appears.
            stateManagement: true,
            hideNavigationBarWhenKeyboardShows: true,
            // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: ItemAnimationProperties(
              // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimation(
              // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle.style13,
          )

        ),
      ),
    );
  }
}
