import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zippy_rider/models/login_model.dart';
import 'package:zippy_rider/utils/util.dart' as util;

class Profile extends StatelessWidget {
  // Model model = Model();
  final Model model;

  Profile(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 5.0, 10.0, 0.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20.0),
            ListTile(
              tileColor: Colors.black12,
              title: Text("Name: ${model.name}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            ListTile(
              tileColor: Colors.black26,
              title: Text("Number: ${model.number}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            ListTile(
              tileColor: Colors.black12,
              title: Text("e-mail: ${model.mail}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            ListTile(
              tileColor: Colors.black26,
              title: Text("Password: ${model.password}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            FlatButton(
              color: util.primaryColor,
              onPressed: () {
                Navigator.pushNamed(context, '/mapscreen');
              },
              child: Text('Book Ride Now'),
            )
          ],
        ),
      ),
    );
  }
}
