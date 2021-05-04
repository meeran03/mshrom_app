import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/order.dart';


// ignore: must_be_immutable
class OrderDetailsScreen extends StatefulWidget {
  OrderData order;

  OrderDetailsScreen({this.order});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {

    statusCheck(context);
    super.initState();
  }

  Widget _orderProductWidget(OrderProduct element) {
    return Container(
      margin: EdgeInsets.all(5),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: 80,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                element.status == "canceled"
                    ? Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.timesCircle,
                        color:Colors.red,

                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Canceled',
                        style: TextStyle(fontFamily: fontFamily),
                      ),
                    ],
                  ),
                )
                    : Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.arrowAltCircleRight,
                            size: 16,
                            color: element.status == "pending"
                                || element.status == "follow_up"
                                || element.status == "confirmed"
                                || element.status == "processing"
                                || element.status == "quality_check"
                                || element.status == "product_dispatched"
                                || element.status == "delivered"
                                ? primaryColor
                                : Colors.grey,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Pending',
                            style: TextStyle(fontFamily: fontFamily),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.arrowAltCircleRight,
                            size: 16,
                            color: element.status == "confirmed"
                                || element.status == "processing"
                                || element.status == "quality_check"
                                || element.status == "product_dispatched"
                                || element.status == "delivered"
                                ? primaryColor
                                : Colors.grey,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Confirmed',
                            style: TextStyle(fontFamily: fontFamily),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.arrowAltCircleRight,
                            size: 16,
                            color: element.status == "processing"
                                || element.status == "quality_check"
                                || element.status == "product_dispatched"
                                || element.status == "delivered"
                                ? primaryColor
                                : Colors.grey,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Processing',
                            style: TextStyle(fontFamily: fontFamily),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.arrowAltCircleRight,
                            size: 16,
                            color: element.status == "quality_check"
                                || element.status == "product_dispatched"
                                || element.status == "delivered"
                                ? primaryColor
                                : Colors.grey,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Quality Check',
                            style: TextStyle(fontFamily: fontFamily),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.arrowAltCircleRight,
                            size: 16,
                            color: element.status == "product_dispatched"
                                || element.status == "delivered"
                                ? primaryColor
                                : Colors.grey,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Product Dispatched',
                            style: TextStyle(fontFamily: fontFamily),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.arrowAltCircleRight,
                            size: 16,
                            color: element.status == "delivered"
                                ? primaryColor
                                : Colors.grey,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Delivered',
                            style: TextStyle(fontFamily: fontFamily),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          Container(
            child: Card(
              color: Colors.white,
              elevation: elevation,
              margin: EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width: 0.5)
                ),
                padding: EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      child: CachedNetworkImage(
                        imageUrl: element.productImage,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url,
                            downloadProgress) =>
                            Center(
                                child:
                                CircularProgressIndicator(
                                    value: downloadProgress
                                        .progress)),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(element.productName,
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: textBlackColor)),
                          Text('Shop:  :' + element.shop,
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 12,
                                  color: textBlackColor)),
                          Text('Quantity: ' + element.quantity,
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 12,
                                  color: textBlackColor)),
                          Text('Price: ' + element.productPrice,
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 12,
                                  color: textBlackColor)),
                          Text('Booking Code:' + element.bookingCode,
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 12,
                                  color: textBlackColor)),
                          Text('Logistic:  :' + widget.order.toLogisticName,
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 12,
                                  color: textBlackColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  List<Widget> _orderProductW = [];

  @override
  Widget build(BuildContext context) {

    widget.order.orderProduct.forEach((element) {

      setState(() {
        _orderProductW.add(_orderProductWidget(element));
      });
    });

    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
      appBar: customSingleAppBar(context, 'Order Details', textWhiteColor),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover
            )
        ),
        child: ListView(
          children: [
            Column(
              children: _orderProductW,
            ),
            Card(
                color: Colors.white,
                elevation: elevation,
                margin: EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('PayAmount : '+widget.order.payAmount,
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: primaryColor)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(widget.order.paymentType,
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 16,
                              color: textBlackColor))
                    ],
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: elevation,
              margin: EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration:BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5),color: Colors.white),
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Bill Form',
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textBlackColor),
                          ),
                          Divider(
                            height: 30,
                          ),
                          Text(widget.order.formAddress.toString(),
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 12,
                                  color: textBlackColor)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(widget.order.formPhone.toString(),
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 12,
                                  color: textBlackColor)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      decoration:BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5),color: Colors.white),
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Bill To',
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textBlackColor),
                          ),
                          Divider(
                            height: 30,
                          ),
                          Text(widget.order.toAddress.toString(),
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 12,
                                  color: textBlackColor)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(widget.order.toPhone.toString(),
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 12,
                                  color: textBlackColor)),
                          Text(widget.order.toAreaName.toString(),
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 12,
                                  color: textBlackColor)),
                          Text(widget.order.toDivisionName.toString(),
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 12,
                                  color: textBlackColor)),
                          Text(widget.order.toLogisticName.toString(),
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 12,
                                  color: textBlackColor)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Card(
                elevation: elevation,
                margin: EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Note',
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textBlackColor)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(widget.order.note,
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 12,
                              color: textBlackColor))
                    ],
                  ),
                )),
          ],
        ),
      ),
    ));
  }
}
