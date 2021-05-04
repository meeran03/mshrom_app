import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/repository/db_connection.dart';
import 'package:many_vendor_ecommerce_app/screen/home_screen.dart';

import '../Globals.dart';

// ignore: must_be_immutable
class ConfirmScreen extends StatefulWidget {
  String title;

  ConfirmScreen({this.title});

  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  deleteCarts() async {
    DatabaseConnection _databaseConnection = new DatabaseConnection();
    var carts = await _databaseConnection.fetchCart();
    carts.forEach((element) {
      _databaseConnection.removeCart(element.vendorStockId);
    });
  }

  @override
  void initState() {
    statusCheck(context);
    deleteCarts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(20),
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: SvgPicture.asset('assets/success.svg'),
                ),
              ),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: fontFamily, fontSize: 14, color: Colors.black),
              ),
              Divider(
                height: 30,
              ),
              FlatButton(
                color: primaryColor,
                child: Text(
                  Globals.arabic ? 'العودة إلى التسوق' : 'Back To Shopping',
                  style:
                      TextStyle(fontFamily: fontFamily, color: textWhiteColor),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
