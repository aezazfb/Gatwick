import 'package:flutter/material.dart';
import 'package:zippy_rider/UI/flights_screen.dart';
import 'package:zippy_rider/states/flight_state.dart';
import 'package:zippy_rider/states/map_state.dart';
import 'UI/map_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    child: MyApp(),
    providers: [
      ChangeNotifierProvider.value(value: MapState()),
      ChangeNotifierProvider.value(value: FlightState())
    ],
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MapScreen(),
        '/flightscreen': (context) => FlightsScreen(),
      },
    );
  }
}
