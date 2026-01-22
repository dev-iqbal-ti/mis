import 'package:flutter/Material.dart';

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    // Right Notch
    double notchRadius = 12;
    double notchPosition = size.height * 0.7; // Position of the dashed line

    path.addOval(
      Rect.fromCircle(center: Offset(0, notchPosition), radius: notchRadius),
    );
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width, notchPosition),
        radius: notchRadius,
      ),
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
