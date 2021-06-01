import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Color.fromRGBO(254, 71, 56, 1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromRGBO(15, 31, 40, 1),
                    ),
                  ),
                ),
                height: double.infinity,
                width: double.infinity,
              ),
      ),
    );
  }
}