import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 200,
      child: Center(
        child: Text(
          'DEHA',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontFamily: 'Galada',
          ),
        ),
      ),
    );
  }
}
