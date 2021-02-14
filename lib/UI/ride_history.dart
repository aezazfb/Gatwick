import 'package:flutter/material.dart';

class RideHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        //initialIndex: 0,
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text('Station Cars'),
              bottom: TabBar(
                labelPadding: EdgeInsets.zero,
                indicatorColor: Colors.purple,
                physics: BouncingScrollPhysics(),
                unselectedLabelColor: Colors.white,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 15,
                ),
                labelColor: Colors.purple,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15)),
                ),
                tabs: [
                  Tab(
                    text: 'BOOKED',
                  ),
                  Tab(
                    text: 'COMPLETED',
                  ),
                  Tab(
                    text: 'CANCELED',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No Booked Booking Yet..'),
                    IconButton(
                        icon: Icon(
                          Icons.tab,
                          size: 70,
                        ),
                        onPressed: () {}),
                  ],
                )),
                Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No Completed Booking Yet..'),
                    IconButton(
                        icon: Icon(
                          Icons.collections_bookmark_rounded,
                          size: 70,
                        ),
                        onPressed: () {}),
                  ],
                )),
                Center(child: Text('CANCELED'))
              ],
            )));
  }
}
