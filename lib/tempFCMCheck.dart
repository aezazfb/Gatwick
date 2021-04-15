import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zippy_rider/base_class.dart';

import 'package:zippy_rider/utils/util.dart' as util;

class FcmCheck extends StatelessWidget with BaseClass{

  @override
  Widget build(BuildContext context) {
    getToken();
    listenMessages();

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: TextButton(
              style: getTextButtonStyle(),
              onPressed: (){
                pushNotification();
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
