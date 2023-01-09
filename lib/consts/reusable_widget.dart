import 'package:flutter/material.dart';
import 'package:printonex_final/consts/responsive_file.dart';

class ReusableWidget extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double? height;
  final double? width;
  final Color? color;
  final BoxDecoration? decoration;
  final BorderRadius? borderRadius;

  const ReusableWidget({
    super.key,
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.height,
    this.width,
    this.color,
    this.decoration,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      bottom: bottom,
      right: right,
      child: Container(
        height: height,
        width: width,
        decoration:  BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: ResponsiveFile.height10,
            )
          ],
          borderRadius: borderRadius,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
