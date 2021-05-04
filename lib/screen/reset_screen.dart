import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'codematch_screen.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final email = TextEditingController();
  bool _isInvalid = false;
  bool _isLoading = false;


  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      padding: EdgeInsets.all(snackBarPadding),
      content: Text(value),
      duration: barDuration,
    ));
  }

  _sendToken(String email) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    print('login cred');
    setState(() {
      _isLoading = true;
    });
    try {
      String url = baseUrl + '1/forget/password/'+email;
      final _result = await http.get(Uri.parse(url));
      print('lf email natok ${_result.body.toString()}');
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
          print('natok $email');
          _prefs.setString('femail', email);
          _showSuccessMessage(context, data['message']);
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
            pushNewScreen(context, screen: CodeMatchScreen(), withNavBar: false);
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

  bool validateEmail(String value) {
    try {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return false;
      else
        return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: customSingleAppBar(context,'Reset Password',Colors.white),
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
                      'Reset Password',
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

                  TextField(
                    decoration: InputDecoration(
                      labelText: "Enter Email",
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
                        Icons.alternate_email,
                        color: primaryColor,
                      ),
                    ),
                    onChanged: (value) {
                      if (validateEmail(value)) {
                        setState(() {
                          _isInvalid = false;
                        });
                      } else {
                        setState(() {
                          _isInvalid = true;
                        });
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: inputStyle,
                    controller: email,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: _isInvalid,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.warning,
                            color: Colors.red,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Invalid email address.',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  GestureDetector(
                    onTap: () {
                      if (!_isInvalid && !_isLoading) {
                        _sendToken(email.text);
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
                            :  Center(
                            child: Text(
                              'Processing....',
                              style: TextStyle(
                                  color: textWhiteColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14),
                            ))
                        )),
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
