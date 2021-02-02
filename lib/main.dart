import 'package:flutter/material.dart';
import 'package:zippy_rider/states/map_states.dart';
import 'UI/map_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider.value(value: MapState())],
    child: MyApp(),
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
      home: MapScreen(),
    );
  }
}
