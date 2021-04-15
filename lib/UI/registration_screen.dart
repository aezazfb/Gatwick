import 'dart:math';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart' as Message;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:toast/toast.dart';
import 'package:zippy_rider/base_class.dart';
import 'package:zippy_rider/models/login_model.dart';
import 'package:zippy_rider/models/CustomerModel.dart';
import 'package:zippy_rider/requests/registration_screen/customer_registration_request.dart';
import 'package:zippy_rider/utils/util.dart' as util;


class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

/*class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}*/

class _RegistrationScreenState extends State<RegistrationScreen> with BaseClass{
  final _formKey = GlobalKey<FormState>();
  Model model = Model();
  TextEditingController _mailController = new TextEditingController();
  TextEditingController _confirmController = new TextEditingController();

  // Generates Random Number
  int randomPIN = Random().nextInt(10009);
  String name, phoneNumber, email, password, countrycode, deviceId;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceUUID();
    getToken();

  }

  getDeviceUUID() async {
    deviceId = await PlatformDeviceId.getDeviceId;
    print('device id: $deviceId');
  }

  @override
  Widget build(BuildContext context) {
    var inputValue;
    String code = randomPIN.toString();

    return WillPopScope(
      onWillPop: () async{
        print('True');
        Navigator.popAndPushNamed(context, '/login');
        return true;
      },
      child: Scaffold(
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
                  Text("REGISTRATION",
                      style: GoogleFonts.montserrat(
                          fontSize: 30.0, color: util.primaryColor)),
                  SizedBox(height: 20),
                  TextFormField(
                    onSaved: (String value) {
                      //model.name = value;
                      name = value;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5.0),
                      prefixIcon: Icon(Icons.person),
                      labelText: "Name",
                      hintText: "Insert Name...",
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: _validateUserName,
                  ),
                  SizedBox(height: 12.0),

                  //Text Form field for Number
                  TextFormField(
                      onSaved: (String value) {
                        //model.number = value;
                        phoneNumber = value;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          //prefixIcon: Icon(Icons.call),
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
                          hintText: "123 1231231",
                          fillColor: Colors.black26,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Phone number can't be empty ";
                        }
                        if (value.length < 10) {
                          return "insert a valid number";
                        }
                        if (value.length > 10) {
                          return "insert number without leading 0 and less than 10 digits";
                        }
                        {
                          _formKey.currentState.save();
                          return null;
                        }
                      }),
                  SizedBox(height: 12.0),

                  //Text Form field for EMail
                  TextFormField(
                    controller: _mailController,
                    onSaved: (String value) {
                      //model.email = value;
                      email = value;
                    },
                    // controller: mailController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5.0),
                        prefixIcon: Icon(Icons.mail),
                        labelText: "E-mail",
                        hintText: "Insert your email here",
                        fillColor: Colors.black26,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                    validator: _validateEmail,
                  ),
                  SizedBox(height: 12.0),

                  //Text Form field for Mail
                  TextFormField(
                      onSaved: (String value) {
                        //model.password = value;
                        password = value;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          prefixIcon: Icon(Icons.person),
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

                  TextButton(
                      //color: util.primaryColor,
                      style: getTextButtonStyle(),
                      onPressed: () async {
                        _formKey.currentState.save();
                        if (_formKey.currentState.validate()) {
                          //sendMail();
                          /*setState(() {
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
                                      TextButton(
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
                          phoneNumber = '$countrycode$phoneNumber';
                          print('Name: ${name} \n PhoneNumber: $phoneNumber '
                              '\n Email: $email \n Password: $password');

                          CustomerModel customerModel = CustomerModel(
                            custEmail: email,
                            custName: name,
                            appname: "Divor",
                            custPhone: phoneNumber,
                            password: password,
                            commStartTime: 0,
                            commMaxValue: 0,
                            commDownValue: 0,
                            commEndTime: 0,
                            commMinValue: 0,
                            blacklist: false,
                            source: "",
                            agentnin: "",
                            signupDate: DateTime.now().millisecondsSinceEpoch,
                            fcmToken: BaseClass.generatedToken,
                            custUid: deviceId,
                          );

                          bool response =
                              await CustomerRegistrationRequest.registerCustomer(
                                  customerModel);
                          if (response) {
                            Toast.show(
                                'Registration Successful, Now Login', context,
                                duration: Toast.LENGTH_LONG);
                            Navigator.pushNamed(context, '/login');
                          } else if (response == false) {
                            Toast.show('Registration Failed', context,
                                duration: Toast.LENGTH_LONG);
                          } else {
                            Toast.show('Registration Error ', context,
                                duration: Toast.LENGTH_LONG);
                          }
                        }
                      },
                      child: Text("S U B M I T",
                          style: GoogleFonts.rakkas(color: Colors.white))),

                  /*TextButton(
                    onPressed: () {
                      print('Button Pressed');
                      pushNotification();
                    },
                    child: Text('Send Notification'),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.blue[800],
                      onSurface: Colors.grey,
                    ),
                  ),*/
                ],
              ),
            ),
          ],
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

  //Email validator
  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return "Mail can't be empty";
    }
    if (!regex.hasMatch(value))
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
    // ignore: deprecated_member_use
    final smtpServer = gmail(userName, password);
    String _mail = _mailController.text.toString();
    final message = Message.Message()
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

      Toast.show('EMail Not Sent check whether your mail is Correct $randomPIN',
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
