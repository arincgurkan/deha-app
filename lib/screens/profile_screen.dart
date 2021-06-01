import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(15, 31, 40, 1),
        title: Text('Profile'),
      ),
      body: Container(
        child: Center(
          child: Text(
            'This is profile page',
          ),
        ),
      ),
    );
  }
}