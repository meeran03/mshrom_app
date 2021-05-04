import 'dart:async';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/screen/loader_screen.dart';
import 'package:many_vendor_ecommerce_app/service/stripe_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  final String amount;

  PaypalPayment({this.onFinish, this.amount});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl = "";
  String executeUrl;
  String accessToken;
  bool loadAll = false;

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.softechit.com'; //todo here
  String cancelURL = 'cancel.softechit.com';

  @override
  void initState() {
    statusCheck(context);
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await StripeService.getAccessToken();

        final transactions = getOrderParams();
        final res =
            await StripeService.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
            loadAll = true;
          });
        }
      } catch (e) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          padding: EdgeInsets.all(snackBarPadding),
          content: Text(e.toString()),
          duration: barDuration,
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        ));
      }
    });
  }

  Map<String, dynamic> getOrderParams() {
    // checkout invoice details
    String totalAmount = widget.amount;

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    if (!loadAll) {
      return LoaderScreen();
    } else {
      if (checkoutUrl != null) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            leading: GestureDetector(
              child: Icon(Icons.arrow_back_ios),
              onTap: () => Navigator.pop(context),
            ),
          ),
          body: !loadAll
              ? LoaderScreen()
              : WebView(
                  initialUrl: checkoutUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url.contains(returnURL)) {
                      final uri = Uri.parse(request.url);
                      final payerID = uri.queryParameters['PayerID'];
                      if (payerID != null) {
                        StripeService.executePayment(
                                executeUrl, payerID, accessToken)
                            .then((id) {
                          widget.onFinish(id);
                          /*if confirm payment*/
                          Navigator.of(context).pop();
                        });
                      } else {
                        Navigator.of(context).pop();
                      }

                      Navigator.of(context).pop();
                    }
                    if (request.url.contains(cancelURL)) {
                      Navigator.of(context).pop();
                    }
                    return NavigationDecision.navigate;
                  },
                ),
        );
      } else {
        return Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            backgroundColor: Colors.black12,
            elevation: 0.0,
          ),
          body: Center(
              child: Container(
                  child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(primaryColor),
          ))),
        );
      }
    }
  }
}
