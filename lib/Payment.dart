import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  String Header = "Go ad free for a year.";
  int Payment = 31000;

  Future<void> LoadHeaderPayment() async {
    var p = await FirebaseFirestore.instance.collection("Payment").doc("Details").get();
    if(p.exists)
      {
        setState(() {
          Header = p.data()!["Header"];
          Payment = p.data()!["Payment"];
        });

      }
  }

  String? Contact = "";
  String? Name = "";

  var _razorpay = Razorpay();

  void InitRazorPay(){
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment Sucess:- " + response.signature.toString());

    final prefs = await SharedPreferences.getInstance();

    if(Contact != null && Contact != "")
      {
        FirebaseFirestore.instance.collection("Users").doc(Contact).update({
          "Payment": "DONE",
          "Expiry": DateTime.now().add(Duration(days: 365)).toIso8601String(),
        });
        FirebaseFirestore.instance.collection("Users").doc(Contact).collection("Payments").add({
          "Signature": response.signature,
          "PaymentId": response.paymentId,
          "OrderId": response.orderId,
          "TimeStamp": DateTime.now().toIso8601String(),
        });
        var User = await FirebaseFirestore.instance.collection("Users").doc(
            Contact).get();
        String? Expiry = User.data()!["Expiry"];
        if(Expiry != null) {
          DateTime expiryDate = DateTime.parse(Expiry);
          if (!expiryDate
              .difference(DateTime.now())
              .isNegative) {

            prefs.setString("AdsEnable", "FALSE");
            print("Ads disabled");

          }
          else{
            prefs.setString("AdsEnable", "TRUE");
            print("Ads enabled");
          }
        }
      }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed:- " + response.toString());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet Response:- " + response.toString());
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  Future<void> RazorPay() async {

    final prefs = await SharedPreferences.getInstance();
    Contact = prefs.getString("LoginContact");
    Name = prefs.getString("LoginName");

    if(Contact != null && Contact != "") {
      var options = {
        'key': 'rzp_live_h6o6VAlRxuQK16',
        'amount': Payment,
        'name': 'Akshay Lakshay Kotish Private Limited',
        'description': 'TJ Sarkari Naukri Ad Free Subscription.',
        'prefill': {
          'name': '$Name',
          'contact': '$Contact',
        }
      };

      try {
        _razorpay.open(options);
      }
      catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {

    LoadHeaderPayment();
    InitRazorPay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        RazorPay();
      },
      child: Visibility(
        visible: Header == "" ? false : true,
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                Header,
                style: GoogleFonts.poppins(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
