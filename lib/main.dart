import 'package:flutter/material.dart';
import 'package:udupi_garbage_collector_admin/screens/homeScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UGC Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff00B198),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
