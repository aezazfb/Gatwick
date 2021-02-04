import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FlightsScreen extends StatefulWidget {
  @override
  _FlightsScreenState createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
  List<String> url = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

  @override
  Widget build(BuildContext context) {
    print("kik");
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
              initialCameraPosition: CameraPosition(
            target: LatLng(24.8607, 67.0011),
            zoom: 15,
          )),
          Positioned(
              bottom: 20,
              left: 10,
              right: 10,
              child: SizedBox(
                  child: CarouselSlider(
                options: CarouselOptions(
                  height: 170,
                  viewportFraction: 0.6,
                  autoPlay: false,
                  scrollDirection: Axis.horizontal,
                  reverse: false,
                  enlargeCenterPage: true,
                  //enlargeCenterPage: true,
                ),
                items: url
                    .map((e) => Builder(
                          builder: (BuildContext context) {
                            return Container(
                                //
                                height: 230,
                                // width: 800.0,
                                color: Colors.white,
                                child: Stack(
                                  children: [
                                    Image(
                                        image: AssetImage(
                                          "assets/images/image.jpeg",
                                        ),
                                        fit: BoxFit.fitWidth,
                                        height: 100,
                                        width: 250),
                                    Positioned(
                                      bottom: 40,
                                      left: 15,
                                      child: Wrap(
                                        children: [
                                          Text(
                                            "London HEATTHROW Airport $e ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 10.0,
                                        left: 10,
                                        child: Text("CM4 1 RW",
                                            style: TextStyle(
                                                color: Colors.purple,
                                                fontWeight: FontWeight.w500)))
                                  ],
                                ));
                          },
                        ))
                    .toList(),
                // [
                //   Builder(
                //       builder: (BuildContext context){
                //         return Card(
                //           shadowColor: Colors.deepPurple,
                //           child: Stack(
                //             children:[
                //               Image(image: AssetImage('assets/images/image.jpeg',), height: 130, width: 500,),
                //               SizedBox(height: 20),
                //               Positioned(
                //                 left: 20,
                //                 bottom: 50,
                //                   child: Text("Airport Name ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),)),
                //               Positioned(
                //                 left: 20,
                //                   bottom: 10,
                //                   child: Text("Airport Code",style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w700),)),
                //             ],
                //           ),
                //         );
                //       })
                // ],
              ))),
          Positioned(
              bottom: 250,
              child: Card(
                  color: Colors.white,
                  child: AlertDialog(
                    content: Text("London City Airport"),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Origin")),
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Destination")),
                    ],
                  ))),
        ],
      ),
    );
  }
}
