
import 'package:flutter/cupertino.dart';

class NavBarClipper extends CustomClipper<Path> {  
  double _radius;
  double _right;

  NavBarClipper(this._radius, this._right);

  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    double right = width - _right;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, height);
    path.lineTo(width, height);
    path.lineTo(width, 0);
    path.close();
    path.addArc(Rect.fromLTRB(right - _radius * 2, -_radius, right, _radius), 0, 6.28318530718);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}