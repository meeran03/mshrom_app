import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:many_vendor_ecommerce_app/Globals.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';

import 'package:many_vendor_ecommerce_app/screen/cart_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/categories_screen.dart';

import 'package:http/http.dart' as http;
import 'package:many_vendor_ecommerce_app/screen/dashboard_screen.dart';

import 'package:many_vendor_ecommerce_app/screen/signin_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/signup_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/wishlist_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'home_screen.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool auth = false;
  String email;
  String name;
  String avatar;
  String token;

  checkAuth() async {
    if (await authCheck() != null) {
      setState(() {
        getAuthUserData(context).then((value) => {
              email = value.email,
              name = value.name,
              avatar = value.avatar,
              token = value.token,
            });
        auth = true;
      });
    }
  }

  _logout() async {
    try {
      final url = baseUrl + 'logout';
      await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      removeSharedPreferences();
      pushNewScreen(context, screen: HomeScreen(), withNavBar: false);
    } catch (e) {
      removeSharedPreferences();
      pushNewScreen(context, screen: HomeScreen(), withNavBar: false);
    }
  }

  @override
  void initState() {
    statusCheck(context);
    checkAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Container(
              color: screenWhiteBackground,
              child: Column(
                children: [
                  auth
                      ? UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color: primaryColor,
                          ),
                          accountName: Text(
                            name.toString(),
                            style: TextStyle(fontFamily: fontFamily),
                          ),
                          accountEmail: Text(
                            email.toString(),
                            style: TextStyle(fontFamily: fontFamily),
                          ),
                          currentAccountPicture: CircleAvatar(
                            child: CircleAvatar(
                              maxRadius: 80,
                              backgroundImage: NetworkImage(avatar),
                            ),
                          ),
                        )
                      : UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color: primaryColor,
                          ),
                          accountName: Text(
                            'User Name',
                            style: TextStyle(fontFamily: fontFamily),
                          ),
                          accountEmail: Text(
                            'User Email',
                            style: TextStyle(fontFamily: fontFamily),
                          ),
                          currentAccountPicture: CircleAvatar(
                            child: Text(
                              "A",
                              style: TextStyle(fontSize: 40.0),
                            ),
                          ),
                        ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.home,
                      color: primaryColor,
                      size: 18,
                    ),
                    title: Text(
                      Globals.putWord("Home"),
                      style: drawerTextStyle,
                    ),
                    onTap: () {
                      pushNewScreen(context,
                          screen: HomeScreen(),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino);
                    },
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: textBlackColor,
                      size: 18,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.list,
                      color: primaryColor,
                      size: 18,
                    ),
                    title: Text(
                      Globals.putWord("Categories"),
                      style: drawerTextStyle,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoriesScreen()));
                    },
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: textBlackColor,
                      size: 18,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.solidHeart,
                      color: primaryColor,
                      size: 18,
                    ),
                    title: Text(
                      Globals.putWord("Wishlist"),
                      style: drawerTextStyle,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WishListScreen()));
                    },
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: textBlackColor,
                      size: 18,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.shoppingBag,
                      color: primaryColor,
                      size: 18,
                    ),
                    title: Text(
                      Globals.putWord("My Carts"),
                      style: drawerTextStyle,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartScreen()));
                    },
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: textBlackColor,
                      size: 18,
                    ),
                  ),
                  /*this ok*/
                  auth
                      ? Container(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  FontAwesomeIcons.tachometerAlt,
                                  color: primaryColor,
                                  size: 18,
                                ),
                                title: Text(
                                  Globals.putWord("Dashboard"),
                                  style: drawerTextStyle,
                                ),
                                onTap: () {
                                  pushNewScreen(context,
                                      screen: DashboardScreen(),
                                      withNavBar: false);
                                },
                              ),
                              ListTile(
                                leading: Icon(
                                  FontAwesomeIcons.signOutAlt,
                                  color: primaryColor,
                                  size: 18,
                                ),
                                title: Text(
                                  Globals.putWord("Log out"),
                                  style: TextStyle(color: textBlackColor),
                                ),
                                onTap: () {
                                  _logout();
                                },
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                FontAwesomeIcons.signInAlt,
                                color: primaryColor,
                                size: 18,
                              ),
                              title: Text(
                                Globals.arabic ? "تسجيل الدخول" : "Sign In",
                                style: drawerTextStyle,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignInScreen()));
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                FontAwesomeIcons.signInAlt,
                                color: primaryColor,
                                size: 18,
                              ),
                              title: Text(
                                Globals.arabic ? "اشتراك" : "Sign Up",
                                style: drawerTextStyle,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpScreen()));
                              },
                            ),
                          ],
                        ),
                  SwitchListTile(
                    activeColor: primaryColor,
                    value: Globals.arabic,
                    onChanged: (val) {
                      setState(() {
                        Globals.arabic = val;
                      });
                    },
                    title: Text(
                      'Arabic',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
