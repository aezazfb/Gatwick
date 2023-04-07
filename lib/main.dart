import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zippy_rider/UI/registration_screen.dart';
import 'package:zippy_rider/UI/ridehistory_screen.dart';
import 'package:zippy_rider/UI/editbooking_screen.dart';
import 'package:zippy_rider/UI/vias_screen.dart';
import 'package:zippy_rider/UI/flights_screen.dart';
import 'package:zippy_rider/UI/login_screen.dart';
import 'package:zippy_rider/UI/profile_screen.dart';
import 'package:zippy_rider/models/login_model.dart';
import 'package:zippy_rider/states/edit_booking_state.dart';
import 'package:zippy_rider/states/flight_state.dart';
import 'package:zippy_rider/states/map_state.dart';
import 'package:zippy_rider/states/ridehistory_state.dart';
import 'package:zippy_rider/states/vias_state.dart';
import 'package:zippy_rider/testing.dart';
import 'package:geolocator/geolocator.dart' as geolocatoR;

import 'UI/map_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:zippy_rider/utils/util.dart' as util;
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: util.primaryColor,
    systemNavigationBarColor: util.primaryColor,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  runApp(MultiProvider(
    child: MyApp(),
    providers: [
      ChangeNotifierProvider(child: MyApp(), create: (context) => MapState()),
      ChangeNotifierProvider.value(value: FlightState()),
      ChangeNotifierProvider.value(value: ViasState()),
      ChangeNotifierProvider.value(value: RideHistoryState()),
      ChangeNotifierProvider.value(value: EditBookingState()),
      //ChangeNotifierProvider.value(value: BottomModelSheet()),
    ],
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Model model = Model();
  PermissionStatus _status;
  Permission _locStatus;

  myloc() async {
    var myloc = await Permission.locationWhenInUse.status;
    return myloc.isDenied;
  }

  @override
  void initState() {
    super.initState();
    //_askCameraPermission();
    geolocatoR.Geolocator.checkPermission();

    // print(_locStatus.isDenied.toString());
    // if (_locStatus.isDenied != null )
    //   {
    //     Fluttertoast.showToast(msg: 'Please Enable Location Service');
    //     Future.delayed(Duration(seconds: 3),(){
    //       geolocatoR.Geolocator.openLocationSettings();
    //     });
    //   }
    // if(geolocatoR.LocationPermission.denied.toString() != null){
    //   geolocatoR.Geolocator.isLocationServiceEnabled();
    //   geolocatoR.Geolocator.openLocationSettings();
    // }
    // geolocatoR.Geolocator.openLocationSettings();
  }

  // void OnStrt(Duration timesp) async {
  //   _status = await Permission.camera.status;
  //   _locStatus = (await Permission.locationAlways.status) as Permission;
  // }
  //
  // void _askCameraPermission() async {
  //   if (await Permission.camera.request().isGranted && await Permission.locationAlways.request().isGranted) {
  //     _status = await Permission.camera.status;
  //     _locStatus = (await Permission.locationAlways.status) as Permission;
  //
  //     setState(() {});
  //   }
  //   else if (await Permission.location.isDenied || await Permission.locationAlways.isDenied){
  //     Permission.locationAlways.request().whenComplete(() => Fluttertoast.showToast(msg: 'Location Enabled!'));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: util.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: util.primaryColor,
        highlightColor: Colors.brown,
        hoverColor: Colors.brown,
      ),
      initialRoute: '/login',
      routes: {
        //'/': (context) => MapScreen(),
        '/profile': (context) => Profile(model),
        '/login': (context) => Login(),
        '/mapscreen': (context) => MapScreen(),
        '/flightscreen': (context) => FlightsScreen(),
        '/viasscreen': (context) => AddVias(),
        '/bookinghistory': (context) => RideHistory(),
        '/editbooking': (context) => EditBooking(),
        '/registration': (context) => RegistrationScreen(),
        '/testing' : (context) => Testing()
      },
    );
  }
}
