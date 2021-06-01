import 'package:flutter/material.dart';

class EarthquakeScreen extends StatefulWidget {
  @override
  _EarthquakeScreenState createState() => _EarthquakeScreenState();
}

class _EarthquakeScreenState extends State<EarthquakeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(15, 31, 40, 1),
        title: Text('Earthquakes'),
      ),
      body: Container(
        child: Center(
          child: Text(
            'This is earthquake page',
          ),
        ),
      ),
    );
  }
}