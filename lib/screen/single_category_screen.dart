import 'package:flutter/material.dart';
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/shop_product.dart';
import 'package:many_vendor_ecommerce_app/model/trending_category.dart';
import 'package:many_vendor_ecommerce_app/provider/shop_product_provider.dart';
import 'package:many_vendor_ecommerce_app/screen/loader_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/product_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SingleCategoryScreen extends StatefulWidget {
  TrendingCategoryData trendingCategoryData;
  int id;

  SingleCategoryScreen({this.trendingCategoryData, this.id});

  @override
  _SingleCategoryScreenState createState() => _SingleCategoryScreenState();
}

class _SingleCategoryScreenState extends State<SingleCategoryScreen> {
  List<ShopProductData> shopProductData = [];
  bool isLoading = true;

  fetchData() async {
    ShopProductHub shopProductHub;
    if (widget.id == 0) {
      shopProductHub =
          await Provider.of<ShopProductProvider>(context, listen: false)
              .catProductHitApi(widget.trendingCategoryData.catId.toString());
    } else {
      shopProductHub =
          await Provider.of<ShopProductProvider>(context, listen: false)
              .catProductHitApi(widget.id.toString());
    }

    /*set data*/
    Provider.of<ShopProductProvider>(context, listen: false)
        .setData(shopProductHub);
    setState(() {
      shopProductData =
          Provider.of<ShopProductProvider>(context, listen: false).getData();
      isLoading = false;
    });
  }

  @override
  void initState() {
    statusCheck(context);
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppBar(context),
        body: isLoading
            ? Center(
                child: LoaderScreen(),
              )
            : Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/background.png'),
                        fit: BoxFit.cover)),
                child: RefreshIndicator(
                    onRefresh: () async {
                      return await fetchData();
                    },
                    child: ProductScreen(
                      shopProductData: shopProductData,
                    )),
              ),
      ),
    );
  }
}
