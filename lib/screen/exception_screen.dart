
import 'package:flutter/material.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';

class ExceptionScreen extends StatefulWidget {
  @override
  _ExceptionScreenState createState() => _ExceptionScreenState();
}

class _ExceptionScreenState extends State<ExceptionScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            height: size.height,
            width: size.width,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.all(8),
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: Alignment.center,
                            image: AssetImage('assets/b.png')))),
                Divider(
                  height: 25,
                  color: screenWhiteBackground,
                ),
                SizedBox(height: 30,),
                Container(
                    padding: EdgeInsets.all(20),
                    child: Text('This app is only applicable to single vendor eCommerce. Please use the Multivendor app instead. Thank you',textAlign: TextAlign.center,style:  TextStyle(color: textBlackColor,fontSize: 28,fontFamily: fontFamily,fontWeight: FontWeight.bold),)),
              ],
            ),
          ),
        )
    );
  }
}
