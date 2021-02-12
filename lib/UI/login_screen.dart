import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mailer/smtp_server.dart';
import 'package:zippy_rider/models/login_model.dart';
import 'package:mailer/mailer.dart';
import 'package:toast/toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zippy_rider/UI/profile_screen.dart';

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
  TextEditingController _confirmController = new TextEditingController();

  // Generates Random Number
  int randomPIN = Random().nextInt(10009);

  @override
  Widget build(BuildContext context) {
    var inputValue;
    // TODO: implement build
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
                        fontSize: 30.0, color: Colors.teal)),
                SizedBox(height: 20),
                TextFormField(
                  onSaved: (String value) {
                    model.name = value;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5.0),
                      prefixIcon: Icon(Icons.person),
                      labelText: "Name",
                      hintText: "Insert Name...",
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  validator: _validateUserName,
                ),
                SizedBox(height: 12.0),

                //Text Form field for Number
                TextFormField(
                    onSaved: (String value) {
                      model.number = value;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5.0),
                        prefixIcon: Icon(Icons.call),
                        labelText: "Number",
                        hintText: "0123 1231231",
                        fillColor: Colors.black26,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                    validator: (value) {
                      if (value.isEmpty) {
                        // ignore: missing_return
                        return "Phone number can't be empty ";
                      }
                      if (value.length < 11) {
                        return "insert a valid number";
                      }
                      {
                        _formKey.currentState.save();
                        return null;
                      }
                    }),
                SizedBox(height: 12.0),

                //Text Form field for Mail
                TextFormField(
                  controller: _mailController,
                  onSaved: (String value) {
                    model.mail = value;
                  },
                  // controller: mailController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5.0),
                      prefixIcon: Icon(Icons.mail),
                      labelText: "E-mail",
                      hintText: "Insert tour mail here",
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
                      model.password = value;
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
                        // ignore: missing_return
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
                    color: Colors.teal,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        sendMail();
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
                                          Navigator.of(context)
                                              .pushNamed('/mapscreen');
                                        } else {
                                          return Toast.show(
                                              'Code Does not  Match', context,
                                              duration: Toast.LENGTH_LONG);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              });
                        });
                      }
                    },
                    child: Text("S U B M I T",
                        style: GoogleFonts.rakkas(color: Colors.white))),
              ],
            ),
          ),
        ],
      ),
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

    void showToast(String msg, {int duration, int gravity}) {
      Toast.show(msg, context, duration: duration, gravity: gravity);
    }

    var connection = PersistentConnection(smtpServer);
    await connection.send(message);
    await connection.close();
  }
}
