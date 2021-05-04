import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/brand.dart';
import 'package:many_vendor_ecommerce_app/model/campaign.dart';
import 'package:many_vendor_ecommerce_app/model/setting.dart';

import 'package:many_vendor_ecommerce_app/model/shop_product.dart';
import 'package:many_vendor_ecommerce_app/model/trending_category.dart';
import 'package:many_vendor_ecommerce_app/provider/brand_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/campaign_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/trading_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/trending_cat_provider.dart';
import 'package:many_vendor_ecommerce_app/repository/db_connection.dart';
import 'package:many_vendor_ecommerce_app/screen/campaign_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/drawer_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/loader_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/product_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/single.campaign.screen.dart';
import 'package:many_vendor_ecommerce_app/screen/single_brand.dart';
import 'package:many_vendor_ecommerce_app/screen/single_category_screen.dart';
import 'package:provider/provider.dart';

import '../Globals.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  List<ShopProductData> shopProductData = [];
  List<BrandData> brand = [];
  bool isLoading = true;
  List<CampaignData> _campaignData;

  List<TrendingCategoryData> list = [];
  bool isLoadingForCat = true;

  hitCampaignApi() async {
    /*set campaign data*/
    CampaignClass campaign =
        await Provider.of<CampaignProvider>(context, listen: false)
            .campaignHitApi();
    //  set data
    Provider.of<CampaignProvider>(context, listen: false).setData(campaign);

    /*category for tab*/
    TrendingCategoryHub trendingCategoryHub =
        await Provider.of<TrendingCategoryProvider>(context, listen: false)
            .hitApi();
    Provider.of<TrendingCategoryProvider>(context, listen: false)
        .setData(trendingCategoryHub);

    /*trading product*/
    ShopProductHub shopProduct =
        await Provider.of<TradingProductProvider>(context, listen: false)
            .hitApi();
    /*set data*/
    Provider.of<TradingProductProvider>(context, listen: false)
        .setData(shopProduct);

    /*set brand data tab brand*/
    BrandClass brandClass =
        await Provider.of<BrandProvider>(context, listen: false).brandHitApi();
    Provider.of<BrandProvider>(context, listen: false).setData(brandClass);

    setState(() {
      /*campaign*/
      _campaignData =
          Provider.of<CampaignProvider>(context, listen: false).getData();
      /*trending product list update*/
      list = Provider.of<TrendingCategoryProvider>(context, listen: false)
          .getData();
      print(list);
      shopProductData =
          Provider.of<TradingProductProvider>(context, listen: false).getData();
      brand = Provider.of<BrandProvider>(context, listen: false).getData();

      isLoading = false;
    });
  }

  TabController _tabController;
  int _tabIndex = 0;

  final List<Widget> myTabs = [
    Tab(
        child: Text(
      Globals.arabic ? 'التصنيفات' : 'Categories',
      style: TextStyle(color: textBlackColor),
    )),
    Tab(
        child: Text(
      Globals.arabic ? 'ماركة' : 'Brand',
      style: TextStyle(color: textBlackColor),
    )),
  ];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _setupSetting() async {
    /*here the update the database*/
    DatabaseConnection _databaseConnection = DatabaseConnection();
    final appSetting = AppSetting(
      type: 'slid_screen',
      value: 'off',
    );
    await _databaseConnection.addSystemItem(appSetting);
    await _databaseConnection.fetchSetting();
  }

  @override
  void initState() {
    statusCheck(context);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    hitCampaignApi();
    _setupSetting();
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> campaignWidget = [];
    Size size = MediaQuery.of(context).size;
    try {
      if (!isLoading) {
        campaignWidget.clear();
        _campaignData.forEach((element) {
          campaignWidget.add(GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleCampaignScreen(
                            campaignData: element,
                          )));
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.all(8.0),
              child: CachedNetworkImage(
                width: size.width / 2.8,
                height: size.height / 4,
                imageUrl: element.banner,
                fit: BoxFit.fill,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(primaryColor),
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ));
        });
      }
    } catch (e) {
      campaignWidget.add(Center(
        child: Container(
          child: Text(
            'No Campaign is Live',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: textBlackColor, fontWeight: FontWeight.bold),
          ),
        ),
      ));
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppBar(context),
        drawer: Drawer(
          child: DrawerScreen(),
        ),
        body: isLoading
            ? LoaderScreen()
            : Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/background.png'),
                        fit: BoxFit.cover)),
                child: RefreshIndicator(
                  onRefresh: () async {
                    return await hitCampaignApi();
                  },
                  child: ListView(shrinkWrap: true, children: [
                    CustomCarousel(),

                    /*tab screen*/
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 20, left: 20),
                          child: TabBar(
                            labelStyle: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontFamily: fontFamily,
                                fontSize: 12,
                                color: textBlackColor,
                                fontWeight: FontWeight.bold),
                            labelColor: textBlackColor,
                            controller: _tabController,
                            indicatorColor: primaryColor,
                            tabs: myTabs,
                          ),
                        ),
                        Center(
                          child: [
                            /*category*/
                            GridView.builder(
                                itemCount: list.length == 0 ? 0 : list.length,
                                physics: NeverScrollableScrollPhysics(),
                                //this is for not scrollable
                                primary: true,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SingleCategoryScreen(
                                                      trendingCategoryData:
                                                          list[index],
                                                      id: 0,
                                                    )));
                                      },
                                      child: Container(
                                        color: Colors.white,
                                        margin: EdgeInsets.all(4),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  margin: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 0.2),
                                                  ),
                                                  child: list[index].image ==
                                                          null
                                                      ? Container()
                                                      : CachedNetworkImage(
                                                          imageUrl:
                                                              list[index].image,
                                                          fit: BoxFit.cover,
                                                          progressIndicatorBuilder: (context,
                                                                  url,
                                                                  downloadProgress) =>
                                                              Center(
                                                                  child: CircularProgressIndicator(
                                                                      valueColor:
                                                                          AlwaysStoppedAnimation(
                                                                              primaryColor),
                                                                      value: downloadProgress
                                                                          .progress)),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        )),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                Globals.arabic
                                                    ? list[index].nameAr
                                                    : list[index].name,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: textBlackColor,
                                                    fontFamily: fontFamily,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                            /*brand*/
                            GridView.builder(
                                itemCount: brand.length <= 0 ? 0 : brand.length,
                                physics: NeverScrollableScrollPhysics(),
                                //this is for not scrollable
                                primary: true,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  // childAspectRatio: size.width / (size.height / 1.5),
                                  crossAxisCount: 3,
                                ),
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SingleBrandProductScreen(
                                                      brandData: brand[index],
                                                      id: 0,
                                                    )));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 0.2),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  margin: EdgeInsets.all(4.0),
                                                  child: brand[index].logo ==
                                                          null
                                                      ? Container()
                                                      : CachedNetworkImage(
                                                          imageUrl:
                                                              brand[index].logo,
                                                          fit: BoxFit.fill,
                                                          progressIndicatorBuilder: (context,
                                                                  url,
                                                                  downloadProgress) =>
                                                              Center(
                                                                  child: CircularProgressIndicator(
                                                                      valueColor:
                                                                          AlwaysStoppedAnimation(
                                                                              primaryColor),
                                                                      value: downloadProgress
                                                                          .progress)),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        )),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                Globals.arabic
                                                    ? brand[index].nameAr
                                                    : brand[index].name,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: textBlackColor,
                                                    fontFamily: fontFamily,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                          ][_tabIndex],
                        ),
                      ],
                    ),
                    // HomeCampaign(context),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Globals.arabic ? 'كل الحملة' : 'All Campaign',
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    color: textBlackColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              _campaignData.length == 0
                                  ? Container()
                                  : FlatButton(
                                      child: Text(
                                        'See all',
                                        style: TextStyle(
                                            color: secondaryColor,
                                            fontFamily: fontFamily),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CampaignScreen()));
                                      },
                                    )
                            ],
                          ),
                        ),
                        /*campaign scroll*/
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: campaignWidget,
                          ),
                        ),
                      ],
                    ),

                    /*here the product grid*/
                    Container(
                      height: 40,
                      padding: EdgeInsets.all(8),
                      child: Text(
                        Globals.arabic
                            ? 'جميع المنتجات الرائجة'
                            : 'All Trending Products',
                        style: TextStyle(
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.bold,
                            color: textBlackColor),
                      ),
                    ),
                    ProductScreen(shopProductData: shopProductData),
                    Container(
                      height: 100,
                    ),
                  ]),
                ),
              ),
      ),
    );
  }
}
