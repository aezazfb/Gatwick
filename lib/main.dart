import 'package:flutter/material.dart';
import 'package:zippy_rider/UI/ridehistory_screen.dart';
import 'package:zippy_rider/UI/editbooking_screen.dart';
import 'package:zippy_rider/UI/vias_screen.dart';
import 'package:zippy_rider/UI/flights_screen.dart';
import 'package:zippy_rider/UI/login_screen.dart';
import 'package:zippy_rider/UI/profile_screen.dart';
import 'package:zippy_rider/models/login_model.dart';
import 'package:zippy_rider/states/flight_state.dart';
import 'package:zippy_rider/states/map_state.dart';
import 'package:zippy_rider/states/ridehistory_state.dart';
import 'package:zippy_rider/states/vias_state.dart';
import 'UI/map_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:zippy_rider/utils/util.dart' as util;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: util.primaryColor,
    systemNavigationBarColor: util.primaryColor,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MultiProvider(
    child: MyApp(),
    providers: [
      ChangeNotifierProvider.value(value: MapState()),
      ChangeNotifierProvider.value(value: FlightState()),
      ChangeNotifierProvider.value(value: ViasState()),
      ChangeNotifierProvider.value(value: RideHistoryState()),
    ],
  ));
}

class MyApp extends StatelessWidget {
  final Model model = Model();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZippyRides',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: util.primaryColor,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MapScreen(),
        '/profile': (context) => Profile(model),
        '/login': (context) => Login(),
        '/mapscreen': (context) => MapScreen(),
        '/flightscreen': (context) => FlightsScreen(),
        '/viasscreen': (context) => AddVias(),
        '/bookinghistory': (context) => RideHistory(),
        '/editbooking': (context) => EditBooking(),
      },
    );
  }
}
