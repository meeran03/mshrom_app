import 'package:flutter/material.dart';
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/brand.dart';
import 'package:many_vendor_ecommerce_app/model/shop_product.dart';
import 'package:many_vendor_ecommerce_app/provider/brand_product_provider.dart';
import 'package:many_vendor_ecommerce_app/screen/loader_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/product_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SingleBrandProductScreen extends StatefulWidget {
  BrandData brandData;
  int id;
  SingleBrandProductScreen({this.brandData,this.id});

  @override
  _SingleBrandProductScreenState createState() =>
      _SingleBrandProductScreenState();
}

class _SingleBrandProductScreenState extends State<SingleBrandProductScreen> {
  List<ShopProductData> shopProductData = List();
  bool isLoading = true;

  getBrandProduct() async {
    ShopProductHub shopProductHub;
    if(widget.id == 0){
      shopProductHub =
      await Provider.of<BrandProductProvider>(context, listen: false)
          .hitApi(widget.brandData.id.toInt());
    }else{
      shopProductHub =
      await Provider.of<BrandProductProvider>(context, listen: false)
          .hitApi(widget.id);
    }

    /*set data*/
    Provider.of<BrandProductProvider>(context, listen: false)
        .setData(shopProductHub);
    setState(() {
      shopProductData =
          Provider.of<BrandProductProvider>(context, listen: false).getData();
    });
    if (shopProductData.length > 0) {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  void initState() {

    statusCheck(context);
    getBrandProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppBar(context),
        body: isLoading
            ? LoaderScreen()
            : Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover
              )
          ),
              child: RefreshIndicator(
          onRefresh: () async{
              return await getBrandProduct();
          },
                child: ProductScreen(
                    shopProductData: shopProductData,
                  ),
              ),
            ),
      ),
    );
  }
}
