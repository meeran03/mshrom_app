import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_ecommerce_app/model/slider.dart';
import 'package:many_vendor_ecommerce_app/model/user.dart';
import 'package:many_vendor_ecommerce_app/provider/slider_provider.dart';
import 'package:many_vendor_ecommerce_app/screen/exception_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/home_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/signin_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String appName = "Mshrom مشروم"; //apps name
String fontFamily = 'Regular';
String one = "Welcome to Mshrom"; // first screen text
String two = "Search Your Need"; //second screen text
String url = 'https://mshrom.com';
final logo = 'assets/f.png';

List<SliderImage> getSlider() {
  List<SliderImage> sliders = new List<SliderImage>();
  var slide1 = new SliderImage(
      logo: 'assets/mshroobLogo.png',
      desc:
          'Mshrom is your online vegetables store. You can order all kinds of fresh and healthy vegetables from our online store.',
      imgPath: 'assets/screen_one.svg',
      background: 'assets/screen_background.svg',
      topTitle: 'Welcome To Shop');
  sliders.add(slide1);
  var slide2 = new SliderImage(
      logo: 'assets/mshroobLogo.png',
      desc:
          'When it comes to get the best and fresh vegetables mshrom is there for you to deliver the vegetables of your desire.',
      imgPath: 'assets/screen_tow.svg',
      background: 'assets/screen_background.svg',
      topTitle: 'Search Your Need');
  sliders.add(slide2);
  var slide3 = new SliderImage(
      logo: 'assets/mshroobLogo.png',
      desc: '',
      background: 'assets/screen_background.svg',
      imgPath: 'assets/screen_three.svg',
      topTitle: 'Start the Shopping ');
  sliders.add(slide3);
  return sliders;
}
/*end*/

/*start*/

class SliderImage {
  String logo;
  String imgPath;
  String topTitle;
  String desc;
  String background;

  SliderImage(
      {this.logo, this.imgPath, this.topTitle, this.desc, this.background});
}

void statusCheck(context) async {
  var response = await http.get(Uri.parse(baseUrl + 'status'));
  var value = jsonDecode(response.body.toString());

  if (value['status'] != 'ecommerce') {
    /*this is vendor app*/
    if (value['status'] != null) {
      pushNewScreen(context, screen: ExceptionScreen(), withNavBar: false);
    }
  }
}

final textBlackColor = Colors.black;
final textWhiteColor = Colors.white;
final iconWhiteColor = Colors.white;
final screenWhiteBackground = Colors.white;
final primaryColor = colorConvert('#37b025');
final primaryColor1 = Colors.green;
final secondaryColor = primaryColor;
final iconColor = Colors.black;
final inputBorderColor = Colors.black;
final double elevation = 0.5;
final Duration barDuration = Duration(milliseconds: 800);
final double snackBarPadding = 10;
final cartBtnStyle =
    TextStyle(fontSize: 16, fontFamily: fontFamily, color: textWhiteColor);
final drawerTextStyle = TextStyle(
    color: textBlackColor,
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500);
final inputStyle =
    TextStyle(fontFamily: fontFamily, color: Colors.grey, fontSize: 12);

colorConvert(code) {
  return Color(int.parse(code.replaceAll('#', '0xff')));
}

logout(token, context) async {
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

// ignore: non_constant_identifier_names
Widget Empty() {
  return Center(
    child: Container(
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage('assets/empty.png'), fit: BoxFit.cover)),
    ),
  );
}

final String baseUrl = url + "/api/";

final menuStyle =
    TextStyle(fontFamily: fontFamily, color: textBlackColor, fontSize: 12);
final signInUpTextStyle = TextStyle(
    color: secondaryColor, fontFamily: fontFamily, fontWeight: FontWeight.bold);

class CustomCarousel extends StatefulWidget {
  @override
  _CustomCarouselState createState() => _CustomCarouselState();
}

removeSharedPreferences() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  /*if have remove first*/
  _prefs.remove('name');
  _prefs.remove('email');
  _prefs.remove('avatar');
  _prefs.remove('token');
}

setUserDataLoginSharedPreferences(data) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  /*if have remove first*/
  if (_prefs.containsKey('token') &&
      _prefs.containsKey('name') &&
      _prefs.containsKey('avatar') &&
      _prefs.containsKey('email')) {
    _prefs.remove('name');
    _prefs.remove('email');
    _prefs.remove('avatar');
    _prefs.remove('token');
  } else {
    /*set new data*/
    _prefs.setString('name', data['name']);
    _prefs.setString('email', data['email']);
    _prefs.setString('avatar', data['avatar']);
    _prefs.setString('token', data['token']);
  }
}

Future<Auth> getAuthUserData(context) async {
  var user = new Auth();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  if (_prefs.containsKey('token') &&
      _prefs.containsKey('name') &&
      _prefs.containsKey('avatar') &&
      _prefs.containsKey('email')) {
    user.email = _prefs.getString('email');
    user.name = _prefs.getString('name');
    user.avatar = _prefs.getString('avatar');
    user.token = _prefs.getString('token');
  } else {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInScreen()));
  }
  return user;
}

Future<String> authCheck() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  if (_prefs.containsKey('token') &&
      _prefs.containsKey('name') &&
      _prefs.containsKey('avatar') &&
      _prefs.containsKey('email')) {
    return _prefs.getString('token');
  } else {
    return null;
  }
}

Future<String> getToken() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  return _prefs.getString('token');
}

getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String stringValue = prefs.getString('stringValue');
  return stringValue;
}

class _CustomCarouselState extends State<CustomCarousel>
    with SingleTickerProviderStateMixin {
  List<Widget> img = [];
  int currentIndex = 0;
  PageController pageController = new PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    getSliderData();
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (currentIndex < img.length) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
      if (pageController.hasClients)
        pageController.animateToPage(currentIndex,
            duration: Duration(milliseconds: 400), curve: Curves.linear);
    });
  }

  getSliderData() async {
    SliderClass slider =
        await Provider.of<SliderProvider>(context, listen: false).hitApi();
    //set data
    Provider.of<SliderProvider>(context, listen: false).setData(slider);
    img.clear();
    Provider.of<SliderProvider>(context, listen: false)
        .getData()
        .forEach((element) {
      if (element.appActivate == 'vendor') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ExceptionScreen()));
      } else {
        setState(() {
          img.add(CachedNetworkImage(
            imageUrl: element.image,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress)),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ));
        });
      }
    });
  }

  Widget pageIndexIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? primaryColor : Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4),
      height: size.height / 4,
      width: size.width,
      child: img.length > 0
          ? PageView.builder(
              onPageChanged: (val) {
                setState(() {
                  currentIndex = val;
                });
              },
              controller: pageController,
              itemCount: img.length,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.loose,
                  overflow: Overflow.visible,
                  children: [
                    Container(width: size.width, child: img[index]),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            for (int i = 0; i < img.length; i++)
                              currentIndex == i
                                  ? pageIndexIndicator(true)
                                  : pageIndexIndicator(false)
                          ]),
                        ),
                      ),
                    ),
                  ],
                );
              })
          : Container(),
    );
  }
}
