import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  MenuScreen(this.text, this.backgroundColor, this.textColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 250,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 26,
            color: textColor,
          ),
        ),
      ),
    );
  }
}