import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/screen/reset_password_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';



class CodeMatchScreen extends StatefulWidget {
  @override
  _CodeMatchScreenState createState() => _CodeMatchScreenState();
}

class _CodeMatchScreenState extends State<CodeMatchScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final code = TextEditingController();
  bool _isInvalid = false;
  bool _isLoading = false;

  String email = '';

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      padding: EdgeInsets.all(snackBarPadding),
      content: Text(value),
      duration: barDuration,
    ));
  }

  _sendToken(String code) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    email = _prefs.getString('femail');

    setState(() {
      _isLoading = true;
    });
    try {
      String url = baseUrl + '2/forget/password/'+email+'/'+code;
      final _result =
      await http.get(Uri.parse(url));
      print('lf code natok ${_result.body.toString()}');
      if (_result.statusCode == 200 && _result.body != null) {
        final data = json.decode(_result.body);
        if (data['error'] == true) {
          setState(() {
            _isLoading = false;
          });
          _showFailedMessage(context, data['message']);
        } else {
          setState(() {
            _isLoading = false;
          });
          _prefs.setString('code',code);
          _showSuccessMessage(context, data['message']);
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
            pushNewScreen(context, screen: ResetPasswordScreen(), withNavBar: false);
          });
        }
      }
    } catch (e) {
      _showFailedMessage(context, 'Wrong information');
    }
  }

  _showFailedMessage(BuildContext context, title) {
    setState(() {
      _isLoading = false;
    });
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(0.0),
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              height: 200.0,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        FontAwesomeIcons.exclamationTriangle,
                        size: 30,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.0,fontFamily: fontFamily, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showSuccessMessage(BuildContext context,title) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(0.0),
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              height: 200.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        CupertinoIcons.checkmark,
                        size: 30,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.0,fontFamily: fontFamily),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: customSingleAppBar(context,'Verify The Code',Colors.white),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover
                )
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/mshroobLogo.png',
                        height: 70,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: Text(
                      'Enter Verification Code',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: fontFamily,
                          fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Enter the code",
                      labelStyle: inputStyle,
                      contentPadding:  EdgeInsets.symmetric(vertical: 12.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.code,
                        color: primaryColor,
                      ),
                    ),
                    onChanged: (value) {
                    },
                    keyboardType: TextInputType.text,
                    style: inputStyle,
                    controller: code,
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  GestureDetector(
                    onTap: () {
                      if (!_isInvalid && !_isLoading) {
                        _sendToken(code.text);
                      }
                    },
                    child: Container(
                        height: 30,
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: primaryColor,
                        ),
                        child: _isLoading == false
                            ? Center(
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  color: textWhiteColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14),
                            ))
                            : Center(
                            child: Text(
                              'Processing....',
                              style: TextStyle(
                                  color: textWhiteColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14),
                            ))
                    ),

                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
