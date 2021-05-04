import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:many_vendor_ecommerce_app/Globals.dart';
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/screen/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:many_vendor_ecommerce_app/screen/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoading = true;
  String email;
  String name;
  String phone;
  String address;
  String avatar;
  String token;
  bool _isLoading = false;

  /*image pickup*/
  PickedFile _image;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final nameC = TextEditingController();
  final phoneC = TextEditingController();
  final addressC = TextEditingController();

  getUserData() async {
    token = await getToken();
    final url = baseUrl + 'user/data';
    final response = await http.post(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    /*here append data*/
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      name = data['name'];
      phone = data['phone'];
      avatar = data['avatar'];
      address = data['address'];
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignInScreen()));
    }
    setState(() {
      isLoading = false;
      nameC.text = name;
      phoneC.text = phone;
      addressC.text = address;
    });
  }

  _updateProfile(name, phone, address) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String url = baseUrl + 'update/user';
      final _result = await http.post(Uri.parse(url),
          body: jsonEncode({'name': name, 'phone': phone, 'address': address}),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      if (_result.statusCode == 200 && _result.body != null) {
        final data = json.decode(_result.body);
        if (data['error'] == true) {
          setState(() {
            _isLoading = false;
          });
          _showFailedMessage(context, data['errorMessage']);
        } else {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          _prefs.setString('name', data['name']);
          _prefs.setString('email', data['email']);
          _prefs.setString('avatar', data['avatar']);
          _showSuccessMessage(context);
          setState(() {
            _isLoading = false;
          });
          Timer(Duration(seconds: 1), () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
              height: 360.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    child: Image.asset(
                      'assets/failed.jpg',
                      fit: BoxFit.contain,
                      height: 220,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
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

  _showSuccessMessage(BuildContext context) {
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
                  Image.asset('assets/success.jpg'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Successfully Updated',
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

  _imgFromCamera() async {
    // ignore: deprecated_member_use

    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = image;
    });
    uploadImage();
  }

  _imgFromGallery() async {
    // ignore: deprecated_member_use
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
    uploadImage();
  }

  /*upload profile image*/
  Future<String> uploadImage() async {
    setState(() {
      // ignore: unnecessary_statements
      _isLoading == true;
    });
    var url = baseUrl + 'update/image';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['authorization'] = 'Bearer $token';
    request.files
        .add(await http.MultipartFile.fromPath('picture', _image.path));
    var res = await request.send();
    setState(() {
      // ignore: unnecessary_statements
      _isLoading == false;
    });
    return res.reasonPhrase;
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      padding: EdgeInsets.all(snackBarPadding),
      content: Text(value),
      duration: barDuration,
    ));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
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
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: customSingleAppBar(
          context, Globals.putWord('Dashboard'), textWhiteColor),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover)),
              child: ListView(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.white,
                                child: _image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.file(
                                          File(_image.path),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            image: DecorationImage(
                                                image: NetworkImage(avatar),
                                                fit: BoxFit.cover)),
                                        width: 100,
                                        height: 100,
                                      )),
                            Positioned(
                                left: 85,
                                top: 65,
                                child: Icon(
                                  CupertinoIcons.camera_fill,
                                  color: primaryColor,
                                )),
                          ],
                        )),
                  ),
                  Divider(
                    height: 40,
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: Globals.putWord("Enter Name"),
                            prefixIcon: Icon(
                              Icons.account_circle,
                              color: inputBorderColor,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 12.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontFamily: fontFamily,
                          ),
                          controller: nameC,
                        ),
                        Divider(
                          height: 10,
                          color: screenWhiteBackground,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: Globals.putWord("Phone Number"),
                            prefixIcon: Icon(
                              Icons.phone,
                              color: inputBorderColor,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 12.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          ),
                          onChanged: (value) {},
                          keyboardType: TextInputType.phone,
                          style: TextStyle(fontFamily: fontFamily),
                          controller: phoneC,
                        ),
                        Divider(
                          height: 10,
                          color: screenWhiteBackground,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: Globals.putWord("Address"),
                            prefixIcon: Icon(
                              Icons.account_box,
                              color: inputBorderColor,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 12.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          ),
                          onChanged: (value) {},
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontFamily: fontFamily),
                          controller: addressC,
                          maxLines: 3,
                        ),
                        Divider(
                          height: 10,
                          color: screenWhiteBackground,
                        ),
                        FlatButton(
                          color: primaryColor,
                          child: Container(
                            height: 40,
                            width: size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: secondaryColor,
                            ),
                            child: _isLoading == false
                                ? Center(
                                    child: Text(
                                    Globals.putWord('Update Profile'),
                                    style: TextStyle(
                                        color: textWhiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: fontFamily,
                                        fontSize: 12),
                                  ))
                                : Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                          ),
                          onPressed: () {
                            _updateProfile(
                                nameC.text, phoneC.text, addressC.text);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    ));
  }
}
