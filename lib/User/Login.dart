import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoder/geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Beauty/Home.dart';



class LoginArea extends StatefulWidget {
  const LoginArea({Key? key}) : super(key: key);

  @override
  State<LoginArea> createState() => _LoginAreaState();
}

class _LoginAreaState extends State<LoginArea> {
  TextEditingController fullname = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController otp = TextEditingController();

  String otptxt = "";
  
  double animopacity = 0.0;
  bool visibility = false;
  bool loadingind = false;

  String VerificationID = '';

  var address;
  String adrs = "";

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }


    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> RequestOTP(String e)
  async {
    if(e.length == 10)
      {
        setState(() {
          loadingind = true;
        });
        FirebaseAuth auth = FirebaseAuth.instance;

        setState(() {
          otptxt = "Please wait, sending OTP...";
        });
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+91${e}",
          verificationCompleted: (PhoneAuthCredential credential) async {
            var res = await auth.signInWithCredential(credential);
            print(res.user);
          },
          verificationFailed: (FirebaseAuthException e) {
            print(e.code);
            setState(() {
              otptxt = "${e.message}";
            });
          },
          codeSent: (String verificationId, int? resendToken) async {
            print("Code Sent");
            String smsCode = otp.text;
            VerificationID = verificationId;
            setState(() {
              visibility = true;
              animopacity = 1.0;
              loadingind = false;
              otptxt = "OTP Sent.";
            });
          },
          timeout: const Duration(seconds: 120),
          codeAutoRetrievalTimeout: (String verificationId) {
            setState(() {
              otptxt = "Something went wrong, try again to write contact.";
            });
          },
        );
      }
    else{
      setState(() {
        otptxt = "Invalid Contact.";
      });
    }
  }

  late Position position;



  @override
  void initState() {

    Permission.location.request().then((value){
      print("Location is ${value}");
      _determinePosition().then((Position value) async {
        position = value;
        print(position.toString());

        address = await Geocoder.local.findAddressesFromCoordinates(Coordinates(position.latitude, position.longitude));
        print("Address ${address.first.addressLine}");
        adrs = address.first.addressLine;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.all(30),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),),
                const SizedBox(height: 10,),
                Text("${otptxt}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.red),),
                const SizedBox(height: 20,),
                const Text("Full Name"),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  margin: EdgeInsets.only(top: 10,),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: TextField (
                    controller: fullname,
                    onChanged: (e){

                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Full Name',
                        labelStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500
                        ),
                        hintText: 'Please spell correct',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade600
                        ),
                      prefixText: "",
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                const Text("Contact"),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  margin: EdgeInsets.only(top: 10,),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: TextField (
                    autocorrect: true,
                    keyboardType: TextInputType.phone,
                    controller: contact,
                    onChanged: (e){
                      RequestOTP(e);
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,

                        labelText: 'Contact',
                        labelStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500
                        ),
                        hintText: 'Please spell correct',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade600
                        ),
                        prefixText: "+91 ",
                      prefixIcon: const Icon(Icons.phone),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Visibility(
                  visible: visibility,
                  child: AnimatedOpacity(
                      opacity: animopacity,
                      duration: Duration(milliseconds: 300),
                      child: Text("OTP")
                  ),
                ),
                Visibility(
                  visible: visibility,
                  child: AnimatedOpacity(
                    opacity: animopacity,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      margin: EdgeInsets.only(top: 10,),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextField (
                        keyboardType: TextInputType.number,
                        controller: otp,
                        onChanged: (e){

                        },
                        inputFormatters: [LengthLimitingTextInputFormatter(6)],
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'One Time Pin',
                            labelStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500
                            ),
                            hintText: 'Please spell correct',
                            hintStyle: TextStyle(
                                color: Colors.grey.shade600
                            ),
                          prefixText: "OTP: ",
                          prefixIcon: const Icon(Icons.pin),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Visibility(
                  visible: visibility,
                  child: AnimatedOpacity(
                    opacity: animopacity,
                    duration: Duration(milliseconds: 300),
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          loadingind = true;
                          FirebaseAuth auth = FirebaseAuth.instance;
                          PhoneAuthCredential credential = PhoneAuthProvider
                              .credential(
                              verificationId: VerificationID, smsCode: otp.text);
                          var res = await auth.signInWithCredential(credential);
                          res.user!.updateDisplayName(fullname.text);
                          print("REady ${res.user}");
                          var user = await FirebaseFirestore.instance.collection("Users").doc(res.user!.phoneNumber.toString()).get();
                          if(!user.exists) {
                            FirebaseFirestore.instance.collection("Users").doc(
                                res.user!.phoneNumber.toString()).set({
                              "UserName": fullname.text,
                              "Contact": contact.text,
                              "Lat":position.latitude,
                              "Long": position.longitude,
                              "Address": adrs,
                              "LoginTime:": DateTime.now().toString(),
                            });
                          }
                          else{
                            FirebaseFirestore.instance.collection("Users").doc(
                                res.user!.phoneNumber.toString()).update({
                              "UserName": fullname.text,
                              "Contact": contact.text,
                              "Lat":position.latitude,
                              "Long": position.longitude,
                              "Address": adrs,
                              "LoginTime:": DateTime.now().toString(),
                            });
                          }


                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString("LoginContact", contact.text);
                          prefs.setString("LoginName", fullname.text);

                          loadingind = false;
                          Navigator.of(context).pushAndRemoveUntil(PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 300),
                              transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child){
                                return FadeTransition(
                                  opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
                                  child: child,
                                );
                              },
                              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation){
                                return Home();
                              }), (Route route) => false
                          );
                          setState(() {
                            otptxt = "Great Success.";
                          });
                        }
                        catch(e)
                        {
                          print("Wrong code");
                          setState(() {
                            otptxt = "(Incorrect OTP, try again.)";
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[800]
                        ),
                        child: Text("Click to Login", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white),),
                      ),
                    ),
                  ),
                ),
                Visibility(visible: loadingind, child: Center(child: CircularProgressIndicator())),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
