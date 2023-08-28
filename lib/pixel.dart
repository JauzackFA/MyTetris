import 'package:flutter/material.dart';

class MyPixel extends StatelessWidget {
  var color;
  MyPixel({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.all(1),
    );
  }
}
