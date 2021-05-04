import 'dart:convert';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:many_vendor_ecommerce_app/Globals.dart';
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/district.dart';
import 'package:many_vendor_ecommerce_app/model/logistic.dart';
import 'package:many_vendor_ecommerce_app/model/return_cart.dart';
import 'package:http/http.dart' as http;
import 'package:many_vendor_ecommerce_app/model/thana.dart';
import 'package:many_vendor_ecommerce_app/provider/district_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/logistic_provider.dart';
import 'package:many_vendor_ecommerce_app/provider/return.cart.provider.dart';
import 'package:many_vendor_ecommerce_app/provider/thana_provider.dart';
import 'package:many_vendor_ecommerce_app/screen/confirm.screen.dart';
import 'package:many_vendor_ecommerce_app/screen/loader_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/paypal_payment.dart';

import 'package:many_vendor_ecommerce_app/service/stripe_service.dart';

import 'package:paytm/paytm.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StripeService _service = StripeService();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  bool isLoadingTow = false;
  bool wait = false;
  LogisticData logisticData;

  // ignore: non_constant_identifier_names
  bool City = false;

  // ignore: non_constant_identifier_names
  double total_price; //this is total price with all
  String offer;
  String coupon;
  String token;
  var _coupon = TextEditingController();
  String selectedRole = "cod";
  final _formKey = GlobalKey<FormState>();
  ReturnCart returnCart;
  DistrictClass districtClass;
  List<DistrictData> _list = new List();
  List<ThanaData> _thanaList = new List();
  List<LogisticData> _logisticList = new List();
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();

  //form keys
  TextEditingController _phone = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _orderNote = TextEditingController();
  String selectDistrict;
  String selectThana;
  dynamic selectLogistic = 0;
  dynamic shippingcost;

  List<DropdownMenuItem> items = new List();
  List<DropdownMenuItem> thanaItems = new List();

  _applyCoupon() async {
    final response = await http.post(Uri.parse(baseUrl + 'coupon/store'),
        body: jsonEncode({'coupon': _coupon.text, 'total': total_price}),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    final data = jsonDecode(response.body);
    if (data['error'] == false) {
      setState(() {
        returnCart.data.totalPrice = data['after_discount'];
        coupon = data['coupon'];
        offer = data['discount'].toString();
      });
      String message = 'You got ${data['discount'].toString()} discount';
      showInSnackBar(message);
    } else {
      setState(() {
        returnCart.data.totalPrice = data['total'];
        offer = null;
        coupon = null;
      });
      showInSnackBar(data['message']);
    }
  }

  _checkout() async {
    setState(() {
      wait = true;
    });
    List<String> list = List();
    returnCart.data.products.forEach((element) {
      String data = element.vendorStockId.toString() +
          '-' +
          element.campaignId.toString() +
          '-' +
          element.quantity.toString() +
          '-' +
          (element.subPrice).toString();
      list.add(data);
    });
    String cartsJson = jsonEncode(list);
    if (selectedRole == "ssl-commerz") {
    } else {
      var body = {
        'division_id': selectDistrict,
        'area_id': selectThana,
        'logistic_id': logisticData.id,
        'logistic_charge': logisticData.rate,
        'coupon': coupon,
        'order_id': orderId,
        'carts': cartsJson,
        'payment': selectedRole,
        'address': _address.text,
        'phone': _phone.text,
        'message': _orderNote.text,
        'total_price': returnCart.data.totalPrice.toStringAsFixed(2)
      };
      final response = await http.post(Uri.parse(baseUrl + 'checkout'),
          body: jsonEncode(body),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      final data = jsonDecode(response.body.toString());
      print('natoks meto $data');
      /*here the control response*/
      if (data['error'] == true) {
        showInSnackBar(data['message']);
      } else {
        /*delete from local database*/
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmScreen(
                      title: data['message'],
                    )));
        showInSnackBar(data['message']);
      }
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        padding: EdgeInsets.all(snackBarPadding),
        duration: barDuration,
        content: Text(value)));
  }

  _checkAuth() async {
    token = await authCheck();
    if (token == null) {
      Navigator.pop(context);
    } else {
      returnCart = await Provider.of<ReturnCartProvider>(context, listen: false)
          .hitApi();
      Provider.of<ReturnCartProvider>(context, listen: false)
          .setData(returnCart);

      /*district*/
      districtClass =
          await Provider.of<DistrictProvider>(context, listen: false).htiApi();
      Provider.of<DistrictProvider>(context, listen: false)
          .setData(districtClass);
      setState(() {
        returnCart =
            Provider.of<ReturnCartProvider>(context, listen: false).getData();
        _list = Provider.of<DistrictProvider>(context, listen: false).getData();
        _list.forEach((element) {
          items.add(DropdownMenuItem(
            value: element.id.toString(),
            child: Text(element.district),
          ));
        });
        total_price = returnCart.data.totalPrice;
        isLoading = false;
      });
    }
  }

  _loadCity(district) async {
    setState(() {
      selectThana = null;
      isLoadingTow = true;
      selectDistrict = district;
    });
    ThanaClass thanaClass =
        await Provider.of<ThanaProvider>(context, listen: false)
            .hitApi(selectDistrict);
    Provider.of<ThanaProvider>(context, listen: false).setData(thanaClass);
    setState(() {
      thanaItems.clear();
      _thanaList = Provider.of<ThanaProvider>(context, listen: false).getData();
      _thanaList.forEach((element) {
        thanaItems.add(DropdownMenuItem(
            value: element.id.toString(),
            child: Text(Globals.arabic
                ? element.nameAr ?? element.name
                : element.name)));
      });
      /*here city api*/
      isLoadingTow = false;
    });
  }

  _shipping(LogisticData data) {
    setState(() {
      logisticData = data;
      isLoadingTow = false;
      returnCart.data.totalPrice =
          returnCart.data.totalPrice + data.rate.roundToDouble();
    });
    Navigator.pop(context);
  }

  _loadLogistic(id) async {
    setState(() {
      isLoadingTow = true;
      selectThana = id;
    });
    if (id != 0) {
      LogisticClass logisticClass =
          await Provider.of<LogisticProvider>(context, listen: false)
              .hitApi(selectDistrict, selectThana);
      Provider.of<LogisticProvider>(context, listen: false)
          .setData(logisticClass);

      setState(() {
        _logisticList =
            Provider.of<LogisticProvider>(context, listen: false).getData();
      });

      showModalBottomSheet(
          backgroundColor: Colors.white,
          context: (context),
          builder: (context) => _logisticList.length == 0
              ? Center(
                  child: Container(
                  color: Colors.white,
                  height: 200,
                  padding: EdgeInsets.all(20),
                  child: Text('No Logistic Found'),
                ))
              : ListView.builder(
                  itemCount: _logisticList.length,
                  itemBuilder: (BuildContext context, int index) {
                    LogisticData data = _logisticList[index];
                    return GestureDetector(
                      onTap: () {
                        _shipping(data);
                      },
                      child: Container(
                        color: Colors.white,
                        margin: EdgeInsets.all(8),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1, color: primaryColor),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: RadioListTile(
                            onChanged: null,
                            value: data.id,
                            activeColor: Colors.white,
                            groupValue: selectLogistic,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.name,
                                  style: inputStyle,
                                ),
                                Text(
                                  data.days,
                                  style: inputStyle,
                                ),
                                Text(
                                  Globals.arabic
                                      ? 'تكلفة الشحن'
                                      : 'Shipping Cost :' +
                                          data.rate.toStringAsFixed(2),
                                  style: inputStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }));
    }
  }

  /*stripe payment*/
  _stripePayment(context) async {
    setState(() {
      selectedRole = 'stripe';
    });
    var amount = returnCart.data.totalPrice.toDouble() * 100.toDouble();
    var response = await _service.payWithNewCard(
        amount: amount.toStringAsFixed(0), currency: 'USD');
    if (response.success == true) {
      showInSnackBar(response.message);
      /*todo::here call the checkout function for confirm the payment*/
      _checkout();
    } else {
      showInSnackBar(response.message);
    }
  }

  /*ssl-commerce payment*/

  bool loading = false;

  // ignore: non_constant_identifier_names
  String payment_response = "";
  bool testing = false;

  /*paytm payment*/
  void generateTxnToken(int mode) async {
    setState(() {
      loading = true;
    });
    String callBackUrl = (testing
            ? 'https://securegw-stage.paytm.in'
            : 'https://securegw.paytm.in') +
        '/theia/paytmCallback?ORDER_ID=' +
        orderId;

    var url = 'https://desolate-anchorage-29312.herokuapp.com/generateTxnToken';

    var body = json.encode({
      "mid": _service.PAYTM_MERCHANT_ID,
      "key_secret": _service.PAYTM_MERCHANT_KEY,
      "website": _service.PAYTM_MERCHANT_WEBSITE,
      "orderId": orderId,
      "amount": returnCart.data.totalPrice.toStringAsFixed(2),
      "callbackUrl": callBackUrl,
      "custId": "122",
      "mode": mode.toString(),
      "testing": testing ? 0 : 1
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: {'Content-type': "application/json"},
      );
      String txnToken = response.body;
      setState(() {
        payment_response = txnToken;
      });

      var paytmResponse = Paytm.payWithPaytm(
          _service.PAYTM_MERCHANT_ID,
          orderId,
          txnToken,
          returnCart.data.totalPrice.toStringAsFixed(2),
          callBackUrl,
          testing);

      paytmResponse.then((value) {
        setState(() {
          selectedRole = 'paytm';
          loading = false;
          payment_response = value.toString();
        });
        /*todo: here the call checkout*/
      });
    } catch (e) {}
  }

  _paytmPayment(context) async {
    setState(() {
      selectedRole = 'paytm';
    });
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  payment_response != null
                      ? Text('Response: $payment_response\n')
                      : Container(),
                  RaisedButton(
                    onPressed: () {
                      //Firstly Generate CheckSum bcoz Paytm Require this
                      generateTxnToken(0);
                    },
                    color: primaryColor,
                    child: Text(
                      "Pay using Wallet",
                      style: inputStyle,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      //Firstly Generate CheckSum bcoz Paytm Require this
                      generateTxnToken(1);
                    },
                    color: primaryColor,
                    child: Text(
                      "Pay using Net Banking",
                      style: inputStyle,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      //Firstly Generate CheckSum bcoz Paytm Require this
                      generateTxnToken(2);
                    },
                    color: primaryColor,
                    child: Text(
                      "Pay using UPI",
                      style: inputStyle,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      //Firstly Generate CheckSum bcoz Paytm Require this
                      generateTxnToken(3);
                    },
                    color: primaryColor,
                    child: Text(
                      "Pay using Credit Card",
                      style: inputStyle,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _paypalPyment() {
    setState(() {
      wait = true;
      selectedRole = 'paypal';
    });
    _checkout();
  }

  @override
  void initState() {
    // TODO: implement initState
    statusCheck(context);
    _checkAuth();
    _service.init();
    super.initState();
  }

  void setError(dynamic error) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      padding: EdgeInsets.all(snackBarPadding),
      content: Text(error.toString()),
      duration: barDuration,
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (isLoading) {
      return SafeArea(
          child: Scaffold(
        backgroundColor: Colors.white,
        body: LoaderScreen(),
      ));
    } else {
      final List<CoolStep> steps = [
        //start coupon section
        CoolStep(
          title: Globals.arabic ? "تطبيق القسيمة" : "Apply Coupon",
          subtitle: Globals.arabic
              ? "هل لديك رمز قسيمة؟ قدم هنا"
              : "Have coupon code? Apply here",
          content: Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover)),
            child: Column(
              children: [
                _buildTextField(
                    maxLines: 1,
                    controller: _coupon,
                    labelText: Globals.arabic
                        ? "هل لديك رمز قسيمة؟ قدم هنا"
                        : " Have coupon code? Apply here.",
                    validator: (String t) {
                      return null;
                    }),
                FlatButton(
                  color: primaryColor,
                  minWidth: size.width,
                  onPressed: () {
                    if (coupon != null) {
                      if (coupon != _coupon.text) {
                        _applyCoupon();
                      }
                      showInSnackBar(
                          Globals.arabic ? 'القسيمة سارية' : 'Coupon is apply');
                    } else {
                      _applyCoupon();
                    }
                  },
                  child: Text(
                    Globals.arabic ? 'تطبيق القسيمة' : 'Apply Coupon',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Container(
                  color: colorConvert('#f5f9ff'),
                  width: size.width,
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '${Globals.arabic ? 'السعر الإجمالي الفرعي' : 'Sub Total Price'} : ${returnCart.data.subTotalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 14,
                              color: textBlackColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '${Globals.arabic ? 'مجموع الضريبة' : 'Total Tax'} : ${returnCart.data.totalTax.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 14,
                              color: textBlackColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '${Globals.arabic ? 'السعر الكلي' : 'Total Price'} : ${returnCart.data.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 14,
                              color: textBlackColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      coupon != null
                          ? Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '${Globals.arabic ? 'خصم' : 'Discount'} : $offer',
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: 14,
                                    color: textBlackColor,
                                    fontWeight: FontWeight.w600),
                              ))
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          validation: () {
            return null;
          },
        ),
        //end coupon section
        /*input address*/
        CoolStep(
          title: Globals.arabic ? "معلومات اساسية" : "Basic Information",
          subtitle: Globals.arabic
              ? "يرجى ملء بعض المعلومات الأساسية للبدء"
              : "Please fill some of the basic information to get started",
          content: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover)),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: DropdownButtonFormField(
                      style: inputStyle,
                      elevation: 0,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.5),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          FontAwesomeIcons.building,
                          color: Colors.grey,
                        ),
                        labelText: Globals.putWord('Select State'),
                        labelStyle: inputStyle,
                      ),
                      value: selectDistrict != null ? selectDistrict : null,
                      onChanged: (district) {
                        _loadCity(district);
                      },
                      validator: (value) => value == null
                          ? Globals.putWord('District required')
                          : null,
                      items: items,
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: DropdownButtonFormField(
                      style: inputStyle,
                      elevation: 0,
                      decoration: InputDecoration(
                        labelText: Globals.putWord('Select City'),
                        labelStyle: inputStyle,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.5),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          FontAwesomeIcons.city,
                          color: Colors.grey,
                        ),
                      ),
                      value: selectThana != null ? selectThana : null,
                      onChanged: (thana) {
                        _loadLogistic(thana);
                      },
                      validator: (value) => value == null
                          ? Globals.putWord('City is required')
                          : logisticData == null
                              ? Globals.putWord('Logistic required')
                              : null,
                      items: thanaItems,
                    ),
                  ),
                  logisticData != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                Globals.putWord('Logistic'),
                                style: TextStyle(fontFamily: fontFamily),
                              ),
                            ),
                            AnimatedContainer(
                              width: size.width,
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(8),
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: primaryColor),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    logisticData.name,
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        color: textBlackColor,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    logisticData.days,
                                    style: TextStyle(
                                      color: textBlackColor,
                                      fontFamily: fontFamily,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    Globals.arabic
                                        ? 'تكلفة الشحن'
                                        : 'Shipping Cost :' +
                                            logisticData.rate
                                                .toStringAsFixed(2),
                                    style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: 12,
                                      color: textBlackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  _buildTextField(
                    maxLines: 1,
                    labelText: Globals.putWord("Phone Number"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return Globals.putWord("Phone Number  is required");
                      }
                      return null;
                    },
                    controller: _phone,
                    prefixIcon: Icon(
                      FontAwesomeIcons.phone,
                      color: Colors.grey,
                    ),
                  ),
                  isLoadingTow
                      ? Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(primaryColor),
                            ),
                          ),
                        )
                      : Container(),
                  _buildTextField(
                    maxLines: 1,
                    labelText: Globals.putWord("Address"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return Globals.putWord("Address is required");
                      }
                      return null;
                    },
                    controller: _address,
                    prefixIcon: Icon(
                      FontAwesomeIcons.addressCard,
                      color: Colors.grey,
                    ),
                  ),
                  _buildTextField(
                    maxLines: 3,
                    labelText: Globals.putWord("Special notes for delivery"),
                    validator: (value) {
                      return null;
                    },
                    prefixIcon: Icon(
                      FontAwesomeIcons.stickyNote,
                      color: Colors.grey,
                    ),
                    controller: _orderNote,
                  ),
                ],
              ),
            ),
          ),
          validation: () {
            if (!_formKey.currentState.validate()) {
              return Globals.putWord("Fill form correctly");
            } else {
              return null;
            }
          },
        ),
        /*end input address*/
        /*payment setup*/
        CoolStep(
          title: Globals.arabic ? "خيار الدفع" : "Payment Option",
          subtitle:
              "${Globals.arabic ? 'اختر خيار الدفع' : 'Choose a payment option'} ",
          content: Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover)),
            child: Column(
              children: <Widget>[
                Card(
                  color: Colors.white,
                  elevation: elevation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '${Globals.arabic ? 'السعر الإجمالي الفرعي' : 'Sub Total Price'} : ${returnCart.data.subTotalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '${Globals.arabic ? 'مجموع الضريبة' : 'Total Tax'} : ${returnCart.data.totalTax.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      coupon != null
                          ? Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '${Globals.arabic ? 'خصم' : 'Discount'} : $offer',
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ))
                          : Container(),
                      logisticData != null
                          ? Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '${Globals.putWord("Logistic")} : ${logisticData.rate.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ))
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '${Globals.arabic ? 'السعر الكلي' : 'Total Price'} : ${returnCart.data.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 30,
                  color: Colors.white,
                ),
                wait
                    ? AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(
                          Globals.arabic
                              ? 'يرجى الانتظار أثناء معالجة الخروج'
                              : 'Please wait while checkout processing',
                          style: inputStyle,
                          textAlign: TextAlign.center,
                        ),
                        content: Center(child: Image.asset('assets/loder.gif')))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                onPressed: () {
                                  setState(() {
                                    selectedRole = "cod";
                                  });
                                },
                                child: Container(
                                  height: 120,
                                  width: size.width / 3,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: selectedRole != "cod"
                                              ? primaryColor
                                              : Colors.lightGreen,
                                          width: selectedRole != "cod" ? 1 : 3),
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                        image: AssetImage('assets/cod.png'),
                                        fit: BoxFit.contain,
                                      )),
                                ),
                              ),
                              _service.stripeActive
                                  ? FlatButton(
                                      onPressed: () {
                                        _stripePayment(context);
                                      },
                                      child: Container(
                                        height: 120,
                                        width: size.width / 3,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: selectedRole != "stripe"
                                                    ? primaryColor
                                                    : secondaryColor,
                                                width: selectedRole != "stripe"
                                                    ? 1
                                                    : 3),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/stripe.png'),
                                              fit: BoxFit.contain,
                                            )),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          Divider(
                            height: 30,
                            color: Colors.white,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _service.paytmActive
                                  ? FlatButton(
                                      onPressed: () {
                                        _paytmPayment(context);
                                      },
                                      child: Container(
                                        height: 120,
                                        width: size.width / 3,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: selectedRole != "paytm"
                                                    ? primaryColor
                                                    : secondaryColor,
                                                width: selectedRole != "paytm"
                                                    ? 1
                                                    : 3),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/paytm.png'),
                                              fit: BoxFit.contain,
                                            )),
                                      ),
                                    )
                                  : Container(),
                              _service.paypalActive
                                  ? FlatButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    PaypalPayment(
                                                      onFinish: (number) async {
                                                        print('order id: ' +
                                                            number);
                                                        if (number != null) {
                                                          /*todo::checkout*/
                                                          _paypalPyment();
                                                        } else {
                                                          showInSnackBar(Globals
                                                                  .arabic
                                                              ? 'الدفع لم يتم المحاولة بنجاح بطريقة أخرى'
                                                              : 'Payment is not successfully try another way');
                                                        }
                                                        // payment done
                                                      },
                                                      amount: returnCart
                                                          .data.totalPrice
                                                          .toStringAsFixed(2),
                                                      // ignore: missing_return
                                                    )));
                                      },
                                      child: Container(
                                        height: 120,
                                        width: size.width / 3,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: selectedRole != "paypal"
                                                    ? primaryColor
                                                    : secondaryColor,
                                                width: selectedRole != "paypal"
                                                    ? 1
                                                    : 3),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/paypal.png'),
                                              fit: BoxFit.contain,
                                            )),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
              ],
            ),
          ),
          validation: () {
            return null;
          },
        ),
        /*end payment setup*/
      ];

      final stepper = CoolStepper(
        contentPadding: EdgeInsets.all(8),
        onCompleted: () {
          if (selectedRole == 'cod') {
            _checkout();
          } else {
            showInSnackBar(Globals.arabic
                ? 'حدد طريقة الدفع'
                : 'Select The Payment Method');
          }
        },
        steps: steps,
        config: CoolStepperConfig(
          finalText: Globals.arabic ? "أكد الطلب" : "Confirm Order",
          backText: "PREV",
        ),
      );

      return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: customAppBar(context),
        body: Container(
          height: size.height,
          width: size.width,
          child: stepper,
        ),
      );
    }
  }

  Widget _buildTextField({
    String labelText,
    FormFieldValidator<String> validator,
    TextEditingController controller,
    int maxLines,
    Icon prefixIcon,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: inputStyle,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 12.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
            filled: true,
            prefixIcon: prefixIcon),
        validator: validator,
        style: inputStyle,
        controller: controller,
      ),
    );
  }
}
