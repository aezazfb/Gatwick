import 'dart:math';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zippy_rider/models/login_model.dart';
import 'package:mailer/mailer.dart';
import 'package:toast/toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zippy_rider/requests/login_screen/customer_login_request.dart';
import 'package:zippy_rider/utils/util.dart' as util;

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}


class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  Model model = Model();
  TextEditingController _mailController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _passwordNumberController = new TextEditingController();
  TextEditingController _confirmController = new TextEditingController();

  // Generates Random Number
  int randomPIN = Random().nextInt(10009);
  String countrycode, phoneNumber;
  bool emailfieldEnabled = true, numberfieldEnabled = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConfigFromSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    var inputValue;
    String code = randomPIN.toString();
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset("assets/images/logo2.webp",
                    height: 150, width: 150),
                SizedBox(height: 10),
                //Text Form field for Name
                Text("LOGIN",
                    style: GoogleFonts.montserrat(
                        fontSize: 30.0, color: util.primaryColor)),
                SizedBox(height: 20),

                //Text Form field for Number
                TextFormField(
                    controller: _phoneNumberController,
                    onChanged: (String value) {
                      if (value.length > 0) {
                        phoneNumber = value.trim();
                        setState(() {
                          emailfieldEnabled = false;
                        });
                      } else {
                        setState(() {
                          emailfieldEnabled = true;
                        });
                      }
                    },
                    enabled: numberfieldEnabled,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5.0),
                        prefixIcon: CountryCodePicker(
                            onChanged: (value) {
                              print('changedvalue $value');
                              countrycode = value.toString();
                            },
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: 'PK',
                            favorite: ['+92', 'PK'],
                            //countryFilter: ['PK', 'GB','US'],
                            showFlagDialog: true,
                            //comparator: (a, b) => b.name.compareTo(a.name),
                            //Get the country information relevant to the initial selection
                            onInit: (code) {
                              //print("on init ${code.name} ${code.dialCode}"),
                              countrycode = code.toString();
                            }),
                        labelText: "Number",
                        hintText: "0123 1231231",
                        fillColor: Colors.black26,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                    validator: (value) {
                      print('Value Length: ${value.length}');
                      if (value.isEmpty && numberfieldEnabled == true) {
                        return "Phone number can't be empty ";
                      }
                      if (value.length < 10 && numberfieldEnabled == true) {
                        return "insert a valid number";
                      }
                      {
                        _formKey.currentState.save();
                        return null;
                      }
                    }),
                SizedBox(height: 12.0),
                Text('OR'),
                SizedBox(height: 12.0),
                //Text Form field for EMail
                TextFormField(
                  controller: _mailController,
                  onChanged: (String value) {
                    if (value.length > 0) {
                      setState(() {
                        numberfieldEnabled = false;
                      });
                    } else {
                      setState(() {
                        numberfieldEnabled = true;
                      });
                    }
                  },
                  enabled: emailfieldEnabled,
                  // controller: mailController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                    prefixIcon: Icon(Icons.mail),
                    labelText: "E-mail",
                    hintText: "Insert your email here",
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: _validateEmail,
                ),
                SizedBox(height: 50.0),

                //Text Form field for Mail
                TextFormField(
                    controller: _passwordNumberController,
                    onSaved: (String value) {
                      model.password = value;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        contentPadding: EdgeInsets.all(5.0),
                        labelText: "Password",
                        hintText: "",
                        fillColor: Colors.black26,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "password is empty ..! ";
                      }
                      if (value.length < 8) {
                        return " Invalid Password ";
                      } else {
                        return null;
                      }
                    }),
                SizedBox(height: 12.0),

                FlatButton(
                    color: util.primaryColor,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        //CODE FOR SENDING CONFIRMATION, WILL OPEN IN FUTURE
                        /*sendMail();
                        setState(() {
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Enter Confirmation code"),
                                  content: Form(
                                    child: TextFormField(
                                      controller: _confirmController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Text";
                                        } else
                                          return null;
                                      },
                                    ),
                                  ),
                                  actions: [
                                    FlatButton(
                                      child: Text('Confirm'),
                                      onPressed: () {
                                        setState(() {
                                          inputValue = _confirmController.text
                                              .toString();
                                        });
                                        if (code == inputValue) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Profile(model)));
                                        } else {
                                          return Toast.show(
                                              'Code does not match', context,
                                              duration: Toast.LENGTH_LONG);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              });
                        });*/

                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        phoneNumber = '$countrycode$phoneNumber';
                        print('Email: ${_mailController.text} '
                            '\n Number: ${phoneNumber} '
                            '\n Password: ${_passwordNumberController.text}');
                        if (emailfieldEnabled) {
                          Map<String, dynamic> response =
                              await CustomerLoginRequest.loginCustomer(
                                  _mailController.text.trim(),
                                  _passwordNumberController.text.trim(),
                                  'email');
                          gotoMapScreen(response);
                        } else if (numberfieldEnabled) {
                          Map<String, dynamic> response =
                              await CustomerLoginRequest.loginCustomer(
                                  phoneNumber,
                                  _passwordNumberController.text.trim(),
                                  'phone');

                          gotoMapScreen(response);
                        }
                      }
                    },
                    child: Text("S U B M I T",
                        style: GoogleFonts.rakkas(color: Colors.white))),
                SizedBox(height: 22.0),
                RichText(
                  text: TextSpan(
                      text: 'Don\'t have account?',
                      style: TextStyle(color: util.primaryColor, fontSize: 20),
                      children: [
                        TextSpan(
                            text: 'Register',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.amber,
                              fontSize: 22,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacementNamed(
                                    context, '/registration');
                              }),
                      ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  gotoMapScreen(Map<String, dynamic> response) {
    print('This is Response: $response');
    if (response['success'] == true) {
      saveConfigToSharedPref(response);
      Navigator.pushNamed(context, '/mapscreen');
    } else {
      Toast.show("Invalid Email/Phone or Password", context,
          duration: Toast.LENGTH_LONG);
    }
  }

  saveConfigToSharedPref(Map<String, dynamic> response) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString('cEmail', response['data']['cust_email'].toString());
    sharedPreferences.setString('cPhone', response['data']['cust_phone'].toString());
    sharedPreferences.setString('cName', response['data']['cust_name'].toString());
    print("Print value: ${sharedPreferences.getString('cEmail')}");
    print("Print value: ${sharedPreferences.getString('cPhone')}");
    print("Print value: ${sharedPreferences.getString('cName')}");
  }

  getConfigFromSharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print("Print value: ${sharedPreferences.getString('cEmail')}");
    print("Print value: ${sharedPreferences.getString('cPhone')}");
    print("Print value: ${sharedPreferences.getString('cName')}");
    if(sharedPreferences.getString('cEmail') != null &&
        sharedPreferences.getString('cPhone') != null &&
        sharedPreferences.getString('cName') != null) {
      //print('getting here');
      Navigator.pushNamed(context, '/mapscreen');
    }else{
      //print(' here');
    }
  }

  //Email validator
  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty && emailfieldEnabled == true) {
      return "Mail can't be empty";
    }
    if (!regex.hasMatch(value.trim()) && emailfieldEnabled == true)
      return 'Insert Valid Email';
    else
      return null;
  }

  //User name Validators
  String _validateUserName(String value) {
    return value.trim().isEmpty ? "Name can't be empty" : null;
  }

  //Mailer for sending mail to user
  Future sendMail() async {
    String userName = 'abdulrahman369888@gmail.com';
    String password = 'arsain778866';

    final smtpServer = gmail(userName, password);
    String _mail = _mailController.text.toString();
    final message = Message()
      ..from = Address(userName, password)
      ..recipients.add(_mail)
      //..ccRecipients.addAll(['','aaa' ])
      //..bccRecipients.add('stationcars321@gmail.com')
      ..subject = 'Confirmation Code'
      ..text = "line one text \n this is line 2 of Text"
      ..html = "<h1>Your code is : $randomPIN</h1></n>";

    try {
      final sendReport = await send(message, smtpServer);
      print('message sent' + sendReport.toString());
      //Toast.show('Mail Sent', context);
      Toast.show('Mail sent', context, duration: Toast.LENGTH_LONG);
      // Fluttertoast.showToast(msg: "Mail Sent", backgroundColor: Colors.white, textColor: Colors.teal,);
    } on MailerException catch (e) {
      //Toast.show('Mail Not Sent Confirm your mail is correct', context);

      Toast.show('Mail Not Sent check weather your mail is Correct $randomPIN',
          context,
          duration: Toast.LENGTH_LONG);

      //  Fluttertoast.showToast(msg: "Mail Not Sent , Confirm your mail is Correct",  backgroundColor: Colors.white, textColor: Colors.red,);
      print('Message Not sent $randomPIN');
      for (var p in e.problems) {
        print('problems: ${p.code}: ${p.msg}');
      }
    }

    var connection = PersistentConnection(smtpServer);
    await connection.send(message);
    await connection.close();
  }
}
