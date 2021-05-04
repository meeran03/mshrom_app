import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_ecommerce_app/Globals.dart';
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/shop_product.dart';
import 'package:many_vendor_ecommerce_app/provider/shop_product_provider.dart';
import 'package:many_vendor_ecommerce_app/screen/loader_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/product_screen.dart';
import 'package:provider/provider.dart';
import 'drawer_screen.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<ShopProductData> shopProductData;
  bool isLoading = true;
  String search = "";

  fetchData(value) async {
    ShopProductHub shopProductHub =
        await Provider.of<ShopProductProvider>(context, listen: false)
            .allProduct(value);

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
    fetchData('all');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  fit: BoxFit.cover
              )
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                color: Colors.white,
                child: Container(
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: inputStyle,
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 12.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 0.5),
                        ),
                        hintText: Globals.putWord('Search By Product Name'),
                        hintStyle: TextStyle(color: textBlackColor,fontFamily: fontFamily,),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          onPressed: (){
                            fetchData(search);
                          },
                        )
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: ListView(
                    children: [
                      ProductScreen(shopProductData: shopProductData),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
