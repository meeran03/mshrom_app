import 'dart:async';
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';

import '../Globals.dart';

class PasswordChange extends StatefulWidget {
  @override
  _PasswordChangeState createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final currentPassword = TextEditingController();
  final newpassword = TextEditingController();
  final confirmpassword = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoadingModal = false;
  String token = '';

  _changePassword(
      String currentPassword, String newPassword, String cpassword) async {
    token = await getToken();
    setState(() {
      _isLoadingModal = true;
    });

    if (newPassword == cpassword) {
      try {
        String url = baseUrl + 'change/password';
        final _result = await http.post(Uri.parse(url),
            body: jsonEncode({
              'currentPassword': currentPassword,
              'newPassword': newPassword
            }),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            });

        if (_result.statusCode == 200 && _result.body != null) {
          final data = json.decode(_result.body);

          if (data['error'] == true) {
            setState(() {
              _isLoadingModal = false;
            });
            _showFailedMessage(context, data['message']);
          } else {
            setState(() {
              _isLoadingModal = false;
            });
            _showSuccessMessage(context, data['message']);
            Timer(Duration(seconds: 1), () {
              Navigator.pop(context);
            });
          }
        }
      } catch (e) {
        _showFailedMessage(context, 'Wrong information');
      }
    } else {
      _showFailedMessage(context, 'Confirm Password is not match');
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      padding: EdgeInsets.all(snackBarPadding),
      content: Text(value),
      duration: barDuration,
    ));
  }

  _showFailedMessage(BuildContext context, title) {
    setState(() {
      _isLoadingModal = false;
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
              height: 360.0,
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
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: fontFamily,
                          color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showSuccessMessage(BuildContext context, message) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(0.0),
            content: Container(
              height: 360.0,
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
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      message.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.0, fontFamily: fontFamily),
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
    statusCheck(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          appBar: customSingleAppBar(
              context, Globals.putWord('Change Password'), textWhiteColor),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover)),
              margin: EdgeInsets.all(10),
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
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      Globals.putWord('Change Password'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: fontFamily,
                          fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextField(
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      labelText: Globals.putWord('Current Password'),
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(
                        Icons.security,
                        color: primaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontFamily: fontFamily),
                    controller: currentPassword,
                  ),
                  Divider(
                    height: 20,
                    color: screenWhiteBackground,
                  ),
                  TextField(
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      labelText: Globals.putWord("New Password"),
                      fillColor: inputBorderColor,
                      prefixIcon: Icon(
                        Icons.security,
                        color: primaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontFamily: fontFamily,
                    ),
                    controller: newpassword,
                  ),
                  Divider(
                    height: 20,
                    color: screenWhiteBackground,
                  ),
                  TextField(
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      labelText: Globals.putWord("Confirm Password"),
                      fillColor: inputBorderColor,
                      prefixIcon: Icon(
                        Icons.security,
                        color: primaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontFamily: fontFamily,
                    ),
                    controller: confirmpassword,
                  ),
                  Divider(
                    height: 20,
                    color: screenWhiteBackground,
                  ),
                  FlatButton(
                    color: primaryColor,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: secondaryColor,
                      ),
                      child: _isLoadingModal == false
                          ? Center(
                              child: Text(
                              Globals.putWord('Change Password'),
                              style: TextStyle(
                                  color: textWhiteColor,
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ))
                          : Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(primaryColor),
                                backgroundColor: Colors.white,
                              ),
                            ),
                    ),
                    onPressed: () {
                      _changePassword(currentPassword.text, newpassword.text,
                          confirmpassword.text);
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
