import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/campaign.dart';
import 'package:many_vendor_ecommerce_app/model/campaign_item.dart';
import 'package:many_vendor_ecommerce_app/model/cart.dart';
import 'package:many_vendor_ecommerce_app/provider/campaign.item.provider.dart';
import 'package:many_vendor_ecommerce_app/provider/cart_count_provider.dart';
import 'package:many_vendor_ecommerce_app/repository/db_connection.dart';
import 'package:many_vendor_ecommerce_app/screen/loader_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SingleCampaignScreen extends StatefulWidget {
  CampaignData campaignData;

  SingleCampaignScreen({this.campaignData});

  @override
  _SingleCampaignScreenState createState() => _SingleCampaignScreenState();
}

class _SingleCampaignScreenState extends State<SingleCampaignScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<CampaignProduct> _data;
  bool isLoading = true;

  fetchData() async {
    CampaignItem campaignItem =
        await Provider.of<CampaignItemProvider>(context, listen: false)
            .hitApi(widget.campaignData.id);
    Provider.of<CampaignItemProvider>(context, listen: false)
        .setData(campaignItem);
    setState(() {
      _data =
          Provider.of<CampaignItemProvider>(context, listen: false).getData();
      isLoading = false;
    });
  }

  DatabaseConnection _databaseConnection = new DatabaseConnection();

  _addToCart(stockId, campaignId, context) async {
    final cart = Cart(vendorStockId: stockId, campaignId: campaignId);
    await _databaseConnection.addToCartWithIncrement(cart);
    Provider.of<CartCount>(context, listen: false).totalQuantity();
    showInSnackBar('Added to cart');
  }

  void showInSnackBar(String value) {
    Fluttertoast.showToast(
      msg: value,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
    double cellWidth = ((size.width - 29) / (9 / 2));
    double desiredCellHeight = 140;
    double childAspectRatio = cellWidth / desiredCellHeight;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: customAppBar(context),
        body: isLoading
            ? LoaderScreen()
            : _data.length == 0
                ? Empty()
                : Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/background.png'),
                            fit: BoxFit.cover)),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        return await fetchData();
                      },
                      child: GridView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _data.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: childAspectRatio,
                            crossAxisCount: 3,
                          ),
                          itemBuilder: (BuildContext context, int index) =>
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey, width: 0.5),
                                ),
                                margin: EdgeInsets.only(
                                    left: 8, right: 8, bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CachedNetworkImage(
                                        imageUrl: _data[index].image,
                                        fit: BoxFit.cover,
                                        width: size.width,
                                        height: size.height,
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            Center(
                                                child: CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            primaryColor),
                                                    value: downloadProgress
                                                        .progress)),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 4.0, bottom: 6.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            _data[index].name,
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: fontFamily,
                                                color: textBlackColor),
                                          ),
                                          Text(
                                            _data[index].price,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: textBlackColor,
                                                fontFamily: fontFamily,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    /*here are the natok man*/
                                    GestureDetector(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        margin: EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          'Add to cart',
                                          style: TextStyle(
                                              fontFamily: fontFamily,
                                              color: textWhiteColor),
                                        ),
                                      ),
                                      onTap: () {
                                        if (_data[index].variantStockId == 0) {
                                          showModalBottomSheet(
                                              elevation: elevation,
                                              backgroundColor: Colors.white,
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (BuildContext context) {
                                                var item =
                                                    _data[index].variants;
                                                return GridView.builder(
                                                    itemCount: item.length,
                                                    physics: ScrollPhysics(),
                                                    shrinkWrap: true,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                    ),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int i) {
                                                      return Card(
                                                        margin: EdgeInsets.only(
                                                            bottom: 20, top: 5),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                            side: BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .black45)),
                                                        elevation: elevation,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Text(
                                                              item[i].variant,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      fontFamily,
                                                                  color:
                                                                      textBlackColor),
                                                            ),
                                                            Text(
                                                              item[i]
                                                                  .extraPriceFormat,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color:
                                                                      textBlackColor,
                                                                  fontFamily:
                                                                      fontFamily,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              item[i]
                                                                  .totalPriceFormat,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color:
                                                                      textBlackColor,
                                                                  fontFamily:
                                                                      fontFamily,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            !item[i].stockOut
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      _addToCart(
                                                                          item[i]
                                                                              .stockId,
                                                                          _data[index]
                                                                              .campaignId,
                                                                          context);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8),
                                                                      margin: EdgeInsets.only(
                                                                          bottom:
                                                                              8),
                                                                      decoration: BoxDecoration(
                                                                          color:
                                                                              primaryColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10)),
                                                                      child:
                                                                          Text(
                                                                        'Add to cart',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                fontFamily,
                                                                            color:
                                                                                textWhiteColor),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    child: Text(
                                                                        'Out Off Stock'),
                                                                  ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              });
                                        } else {
                                          _data[index].stockOut
                                              ? showInSnackBar('Out off stock')
                                              : _addToCart(
                                                  _data[index].variantStockId,
                                                  _data[index].campaignId,
                                                  context);
                                        }
                                      },
                                    )
                                  ],
                                ),
                              )),
                    ),
                  ),
      ),
    );
  }
}
