import 'package:flutter/material.dart';

class SkewBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Transform(
          transform: Matrix4.skewX(-0.3),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: SizedBox(
                width: 100,
                height: 30,
                child: Container(
                  color: Colors.black,
                )),
          ),
        ),
      ],
    );
  }
}
