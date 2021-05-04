import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:many_vendor_ecommerce_app/Globals.dart';
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/provider/cart_count_provider.dart';
import 'package:many_vendor_ecommerce_app/screen/drawer_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/signin_screen.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final newpassword = TextEditingController();
  final name = TextEditingController();
  bool _passwordVisible = true;
  bool _isInvalid = false;
  bool _isLoading = false;

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(padding: EdgeInsets.all(snackBarPadding),content: Text(value), duration: barDuration));
  }

  _createAccount(
      String name, String email, String password, newpassword) async {
    setState(() {
      _isLoading = true;
    });
    if (password == newpassword) {
      try {
        String url = baseUrl + 'register';
        final _result = await http.post(Uri.parse(url),
            body: {'name': name, 'email': email, 'password': password});
        if (_result.statusCode == 200 && _result.body != null) {
          final data = json.decode(_result.body);

          if (data['error'] == true) {
            showInSnackBar(data['errorMessage']);
            setState(() {
              _isLoading = false;
            });
          } else {
            setState(() {
              _isLoading = false;
            });
            _showSuccessMessage(context,data['errorMessage']);
            Timer(Duration(seconds: 1), () {
              Navigator.pop(context);
              pushNewScreen(context, screen: SignInScreen(), withNavBar: true);
            });
          }
        }else{
          _showFailedMessage(context);
        }
      } catch (e) {
        _showFailedMessage(context);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      showInSnackBar('Password Or ConfirmPassword Not Match');
    }
  }

  _showFailedMessage(BuildContext context) {
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
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'InValid Information',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.0, fontFamily: fontFamily, color: Colors.red),
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
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
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
  void initState() {
    statusCheck(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: customAppBar(context),
        drawer: Drawer(
          child: DrawerScreen(),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover
                )
            ),
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
                    Globals.putWord('Welcome Back'),
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
                Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Text(
                    Globals.putWord('Sign up to continue'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: fontFamily,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: Globals.putWord("Enter Name"),
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
                      Icons.account_circle,
                      color: primaryColor,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  style: inputStyle,
                  controller: name,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: Globals.putWord("Enter Email"),
                    labelStyle: inputStyle,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:  EdgeInsets.symmetric(vertical: 12.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.5),
                    ),
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
                TextField(
                  obscureText: _passwordVisible,
                  decoration: InputDecoration(
                    labelText: Globals.putWord("Password"),
                    labelStyle: inputStyle,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:  EdgeInsets.symmetric(vertical: 12.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.security,
                      color: primaryColor,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        !_passwordVisible
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
                  style: inputStyle,
                  controller: password,
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: _passwordVisible,
                  decoration: InputDecoration(
                    labelText: Globals.putWord("Confirm Password"),
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
                      Icons.security,
                      color: primaryColor,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        !_passwordVisible
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
                  style: inputStyle,
                  controller: newpassword,
                ),
                SizedBox(
                  height: 20,
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
                          Globals.putWord('Invalid email address'),
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
                GestureDetector(
                  onTap: (){
                    if (!_isInvalid && !_isLoading)
                      _createAccount(name.text, email.text,
                          password.text, newpassword.text);
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
                              Globals.putWord('Register'),
                            style: TextStyle(
                                color: textWhiteColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ))
                          : Center(
                          child: Text(
                              Globals.putWord('Processing....'),
                            style: TextStyle(
                                color: textWhiteColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ))
                  ),

                ),
                Divider(
                  height: 15,
                  color: screenWhiteBackground,
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                  Globals.putWord('Already have an account?'),
                        style: TextStyle(
                            color: textBlackColor,
                            fontSize: 12,
                            fontFamily: fontFamily),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MultiProvider(
                                          providers: [
                                            ChangeNotifierProvider<CartCount>.value(value:
                                            CartCount()),
                                          ],
                                          child: SignInScreen())));
                        },
                        child: Text(
                          Globals.putWord('Sign In'),
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
