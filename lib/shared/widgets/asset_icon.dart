import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetIcon extends StatelessWidget {
  final String name;
  final double width;
  final double height;
  final Color color;

  AssetIcon({
    @required this.name,
    this.color,
    this.width = 24,
    this.height = 24,
  });

  @override
  Widget build(BuildContext context) {
    if (name.contains('.svg')) {
      return SvgPicture.asset(
        'assets/icons/$name',
        color: color,
        width: width,
        height: height,
      );
    }

    return Image.asset(
      'assets/icons/$name.png',
      width: width,
      height: height,
    );
  }
}
