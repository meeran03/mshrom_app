import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/order.dart';
import 'package:many_vendor_ecommerce_app/provider/order_provider.dart';
import 'package:many_vendor_ecommerce_app/screen/home_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/loader_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/orde.details.screen.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isLoading = true;
  String email;
  String name;
  String avatar;
  String token;

  List<OrderData> orderList = [];

  getData() async {
    Order order =
        await Provider.of<OrderProvider>(context, listen: false).hitApi(token);
    Provider.of<OrderProvider>(context, listen: false).setDate(order);
    setState(() {
      orderList = Provider.of<OrderProvider>(context, listen: false).getData();
      isLoading = false;
    });
  }

  checkAuth() async {
    if (await authCheck() != null) {
      setState(() {
        getAuthUserData(context).then((value) => {
              email = value.email,
              name = value.name,
              avatar = value.avatar,
              token = value.token,
            });
      });
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  @override
  void initState() {

    statusCheck(context);
    checkAuth();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: customSingleAppBar(context, 'Orders List', textWhiteColor),
      body: isLoading
          ? LoaderScreen()
          : orderList.length == 0
              ? Empty()
              : Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover
            )
        ),
                child: ListView.builder(
                    itemCount: orderList.length,
                    itemBuilder: (BuildContext contex, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderDetailsScreen(
                                    order: orderList[index],
                                  )));
                        },
                        child: Container(
                          height: 100,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(0.5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: primaryColor,
                                      ),
                                      child: Text(
                                        'ORD' +
                                            orderList[index]
                                                .orderNumber
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: fontFamily,
                                            color: textWhiteColor,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        orderList[index].payAmount,
                                        style: TextStyle(
                                            fontFamily: fontFamily, fontSize: 18),
                                      )),
                                ],
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    orderList[index].orderDate,
                                    style: TextStyle(
                                        fontFamily: fontFamily, fontSize: 16),
                                  ),
                                  Text(
                                    orderList[index].paymentType,
                                    style: TextStyle(
                                        fontFamily: fontFamily, fontSize: 16),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ),
    ));
  }
}
