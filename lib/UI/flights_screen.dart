import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
              ))),
          Positioned(
            bottom: 200,
            child: Visibility(
              // visible: mapState.cardVisibility,
              child: Align(
                child: Card(
                  color: Colors.deepPurple.withOpacity(.8),
                  margin: EdgeInsets.all(8.0),
                  child: InkWell(
                      child:
                          Text("HELLO", style: TextStyle(color: Colors.white)),
                      onTap: () {
                        //mapState.dialogShow(context);
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
