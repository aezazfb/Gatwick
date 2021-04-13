import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zippy_rider/base_class.dart';

import 'package:zippy_rider/utils/util.dart' as util;

class FcmCheck extends StatelessWidget with BaseClass{
  //BaseClass baseClass = new BaseClass();
  FcmCheck fcmCheck = FcmCheck();
  @override
  Widget build(BuildContext context) {

    fcmCheck.getToken();
    fcmCheck.listenMessages();
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: TextButton(
              style: getTextButtonStyle(),
              onPressed: (){
                fcmCheck.pushNotification();
              },
              child: Text("PUSH MESSAGE",
                  style: GoogleFonts.rakkas(color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  ButtonStyle getTextButtonStyle() {
    return TextButton.styleFrom(
      primary: Colors.white,
      backgroundColor: util.primaryColor,
    );
  }
}
