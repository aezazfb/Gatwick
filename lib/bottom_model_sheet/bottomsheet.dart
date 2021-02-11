import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class BottomModelSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('BS build called');
    return null;
  }

  settingModelBottomSheet(context, distance, time) async {
    String vechile = 'Saloon ';
    int suitCase = 0;
    int passengers = 0;
    showModalBottomSheet(
        backgroundColor: Colors.deepPurple.withOpacity(0.1),
        enableDrag: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Driver Time'),
                      ],
                    ),
                    Card(
                        // margin: EdgeInsets.symmetric(horizontal: 10.0),
                        color: Colors.blueGrey,
                        // margin: EdgeInsets.all(0.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.alt_route,
                                size: 40, color: Colors.purple),
                            Text('$distance miles',
                                style: TextStyle(color: Colors.white)),
                            Spacer(),
                            Icon(
                              Icons.timelapse,
                              size: 40,
                              color: Colors.purple,
                            ),
                            Text('$time',
                                style: TextStyle(color: Colors.white)),
                            Spacer(),
                            //Icon(Icons.clean_hands_outlined,size: 40),
                            DropDown(
                              items: [
                                'Cash',
                                'Card',
                              ],
                              hint: Text('Cash',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 10),
                        RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              '$vechile',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                        Icon(Icons.local_taxi_outlined,
                            size: 40, color: Colors.blueGrey),
                        Spacer(),
                        RichText(
                            text: TextSpan(
                                text: '$passengers\n',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ('Passangers'),
                                      style: TextStyle(color: Colors.blueGrey))
                                ]),
                            textAlign: TextAlign.center),
                        Spacer(),
                        RichText(
                            text: TextSpan(
                                text: '$suitCase\n',
                                style: TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ('Suitcases'),
                                      style: TextStyle(color: Colors.blueGrey))
                                ]),
                            textAlign: TextAlign.center),
                      ],
                    ),
                    Swiper(
                      itemWidth: 140,
                      itemHeight: 130,
                      itemCount: 10,
                      // outer: true,
                      layout: SwiperLayout.CUSTOM,
                      customLayoutOption:
                          new CustomLayoutOption(startIndex: -1, stateCount: 3)
                              .addTranslate([
                        new Offset(-140.0, 35.0),
                        new Offset(0.0, 20.0),
                        new Offset(140.0, 35.0)
                      ]).addOpacity([1.0, 1.0, 1.0]),
                      scrollDirection: Axis.horizontal,
                      onIndexChanged: (index) {
                        print('im dsegggg $index');
                        vechile = 'vechile $index ';
                        suitCase = index;
                        passengers = index;
                      },
                      itemBuilder: (BuildContext context, index) {
                        return Card(
                            elevation: 5.0,
                            color: Colors.blueGrey,
                            child: InkWell(
                                child: Stack(
                              children: [
                                Icon(
                                  Icons.local_taxi_rounded,
                                  size: 45,
                                  color: Colors.purple,
                                ),
                                Positioned(
                                  top: 50,
                                  left: 10.0,
                                  child: Row(
                                    children: [
                                      Text(
                                        " Vechile $index",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                        overflow: TextOverflow.visible,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    top: 65.0,
                                    left: 10,
                                    child: Text(" Passangers: $index",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400))),
                                Positioned(
                                    top: 80.0,
                                    left: 10,
                                    child: Text(" Suitcase: $index",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400))),
                              ],
                            )));
                      },
                    ),
                    Card(
                        elevation: 0.0,
                        color: Colors.blueGrey,
                        child: Wrap(
                          children: [
                            IconButton(
                                icon: Icon(Icons.date_range),
                                iconSize: 40,
                                color: Colors.white,
                                onPressed: () => print('heloo')),
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width - 120,
                              height: 40,
                              color: Colors.purple,
                              child: Text('Confirm',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  )),
                              onPressed: () => print('Booked'),
                            ),
                            IconButton(
                                icon: Icon(Icons.add),
                                iconSize: 40,
                                color: Colors.white,
                                onPressed: () => print('add Comment')),
                          ],
                        )),
                  ],
                )
              ],
            ),
          );
        });
  }
}
