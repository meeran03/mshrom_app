import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http_auth/http_auth.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {

  String paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
 static String secret;
  static String publishableKey = "";
  /*payment*/

  // ignore: non_constant_identifier_names
  static String PAYPAL_ENVIRONMENT = "";
  // ignore: non_constant_identifier_names
  static String PAYPAL_CLIENT_ID = "";
  // ignore: non_constant_identifier_names
  static String PAYPAL_APP_SECRET = "";
  // ignore: non_constant_identifier_names
  String PAYTM_ENVIRONMENT = "";
   // ignore: non_constant_identifier_names
   String PAYTM_MERCHANT_ID = "";
   // ignore: non_constant_identifier_names
   String PAYTM_MERCHANT_KEY = "";
   // ignore: non_constant_identifier_names
   String PAYTM_MERCHANT_WEBSITE = "";
   // ignore: non_constant_identifier_names
   String PAYTM_CHANNEL = "";
   // ignore: non_constant_identifier_names
   String PAYTM_INDUSTRY_TYPE = "";
   // ignore: non_constant_identifier_names
   String STORE_ID = "";
   // ignore: non_constant_identifier_names
   String STORE_PASSWORD = "";

  bool stripeActive;
  bool paypalActive;
  bool paytmActive;
  bool sslActive;

  StripeService(){
    loadPayment();
  }
  loadPayment() async{
    var response = await http.get(Uri.parse(baseUrl+'payment/setting'));
    if(response.statusCode == 200){
      var payments = jsonDecode(response.body.toString());


      this.paytmActive = payments['paytmActive'] == true ? true : false;
      this.paypalActive = payments['paypalActive'] == true ? true : false;
      this.stripeActive = payments['stripeActive'] == true ? true : false;
      this.sslActive = payments['sslActive'] == true ? true : false;

      StripeService.publishableKey = payments['STRIPE_KEY'].toString();
      StripeService.secret = payments['STRIPE_SECRET'].toString();
      StripeService.PAYPAL_CLIENT_ID = payments['PAYPAL_CLIENT_ID'].toString();
      StripeService.PAYPAL_APP_SECRET = payments['PAYPAL_APP_SECRET'].toString();
      StripeService.PAYPAL_ENVIRONMENT = payments['PAYPAL_ENVIRONMENT'].toString() == "sandbox" ? "https://api.sandbox.paypal.com" /* for sandbox mode*/ : "https://api.paypal.com"; /* for production mode*/


      this.PAYTM_ENVIRONMENT = payments['PAYTM_ENVIRONMENT'].toString();
      this.PAYTM_MERCHANT_ID = payments['PAYTM_MERCHANT_ID'].toString();
      this.PAYTM_MERCHANT_KEY = payments['PAYTM_MERCHANT_KEY'].toString();
      this.PAYTM_MERCHANT_WEBSITE = payments['PAYTM_MERCHANT_WEBSITE'].toString();
      this.PAYTM_CHANNEL = payments['PAYTM_CHANNEL'].toString();
      this.PAYTM_INDUSTRY_TYPE = payments['PAYTM_INDUSTRY_TYPE'].toString();


      this.STORE_ID = payments['STORE_ID'].toString();
      this.STORE_PASSWORD = payments['STORE_PASSWORD'].toString();

    }
  }
  static Map<String, String> headers = {
    'Authorization': 'Bearer '+StripeService.secret,
    'Content-Type': 'application/x-www-form-urlencoded'
  };

   init() {
    StripePayment.setOptions(
        StripeOptions(
            publishableKey: StripeService.publishableKey,
            merchantId: "Test",
            androidPayMode: 'test'
        )
    );
  }

   Future<StripeTransactionResponse> payViaExistingCard({String amount, String currency, CreditCard card}) async{
    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card)
      );
      var paymentIntent = await this.createPaymentIntent(
          amount,
          currency
      );
      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentIntent['client_secret'],
              paymentMethodId: paymentMethod.id
          )
      );
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful',
            success: true
        );
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed',
            success: false
        );
      }
    } on PlatformException catch(err) {
      return getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}',
          success: false
      );
    }
  }

   Future<StripeTransactionResponse> payWithNewCard({String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest()
      );
      var paymentIntent = await this.createPaymentIntent(
          amount,
          currency
      );
      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentIntent['client_secret'],
              paymentMethodId: paymentMethod.id
          )
      );
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful',
            success: true
        );
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed',
            success: false
        );
      }
    } on PlatformException catch(err) {
      return getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}',
          success: false
      );
    }
  }


   getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(
        message: message,
        success: false
    );
  }

   Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse(this.paymentApiUrl),
          body: body,
          headers: StripeService.headers
      );

      return jsonDecode(response.body);
    } catch (err) {

    }
    return null;
  }

  /*paypal*/
// for getting the access token from Paypal
  static Future<String> getAccessToken() async {
    try {
      var client = BasicAuthClient(PAYPAL_CLIENT_ID, PAYPAL_APP_SECRET);
      var response = await client.post(Uri.parse('$PAYPAL_ENVIRONMENT/v1/oauth2/token?grant_type=client_credentials'));
      if (response.statusCode == 200) {

        final body = convert.jsonDecode(response.body);

        return body["access_token"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // for creating the payment request with Paypal
  static Future<Map<String, String>> createPaypalPayment(
      transactions, accessToken) async {
    try {
      var response = await http.post(Uri.parse("$PAYPAL_ENVIRONMENT/v1/payments/payment"),
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  // for executing the payment transaction
  static Future<String> executePayment(url, payerId, accessToken) async {
    try {
      var response = await http.post(url,
          body: convert.jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return body["id"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}