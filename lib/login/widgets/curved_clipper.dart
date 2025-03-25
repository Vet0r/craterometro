import 'dart:ui';

import 'package:flutter/material.dart';

class CustomCurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 80);

    path.cubicTo(
      size.width * 0.2,
      size.height,
      size.width * 0.8,
      size.height - 150,
      size.width,
      size.height - 80,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
