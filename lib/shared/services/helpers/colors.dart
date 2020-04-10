import 'package:flutter/material.dart';

final _colors = [
  [
    Color.fromRGBO(255, 0, 0, 1),
    Color.fromRGBO(215, 0, 0, 1)
  ],
  [
    Color.fromRGBO(  0, 255, 255, 1),
    Color.fromRGBO(  0, 215, 215, 1)
  ],
  [
    Color.fromRGBO(255, 0, 255, 1),
    Color.fromRGBO(215, 0, 215, 1)
  ],
  [
    Color.fromRGBO(153, 0, 255, 1),
    Color.fromRGBO(113, 0, 215, 1)
  ],
  [
    Color.fromRGBO(  0, 153, 255, 1),
    Color.fromRGBO(  0, 113, 215, 1)
  ],
  [
    Color.fromRGBO(255, 0, 153, 1),
    Color.fromRGBO(215, 0, 113, 1)
  ],
  [
    Color.fromRGBO(  0, 0, 255, 1),
    Color.fromRGBO(  0, 0, 215, 1)
  ],
  [
    Color.fromRGBO(153, 0, 153, 1),
    Color.fromRGBO(113, 0, 113, 1)
  ],
  [
    Color.fromRGBO(255, 153, 0, 1),
    Color.fromRGBO(215, 113, 0, 1)
  ],
  [
    Color.fromRGBO(215, 215, 147, 1),
    Color.fromRGBO(215, 215, 147, 1)
  ],
  [
    Color.fromRGBO(215, 215, 96, 1),
    Color.fromRGBO(215, 215, 96, 1)
  ],
  [
    Color.fromRGBO(255, 255, 68, 1),
    Color.fromRGBO(215, 215, 28, 1)
  ],
  [
    Color.fromRGBO(255, 255, 0, 1),
    Color.fromRGBO(215, 215, 0, 1)
  ],
  [
    Color.fromRGBO(255, 187, 255, 1),
    Color.fromRGBO(215, 147, 215, 1)
  ],
  [
    Color.fromRGBO(255, 187, 187, 1),
    Color.fromRGBO(215, 147, 147, 1)
  ],
  [
    Color.fromRGBO(255, 187, 136, 1),
    Color.fromRGBO(215, 147, 96, 1)
  ],
  [
    Color.fromRGBO(255, 187, 68, 1),
    Color.fromRGBO(215, 147, 28, 1)
  ],
  [
    Color.fromRGBO(255, 136, 255, 1),
    Color.fromRGBO(215, 96, 215, 1)
  ],
  [
    Color.fromRGBO(255, 136, 187, 1),
    Color.fromRGBO(215, 96, 147, 1)
  ],
  [
    Color.fromRGBO(255, 136, 136, 1),
    Color.fromRGBO(215, 96, 96, 1)
  ],
  [
    Color.fromRGBO(255, 136, 68, 1),
    Color.fromRGBO(215, 96, 28, 1)
  ],
  [
    Color.fromRGBO(255, 68, 255, 1),
    Color.fromRGBO(215, 28, 215, 1)
  ],
  [
    Color.fromRGBO(255, 68, 187, 1),
    Color.fromRGBO(215, 28, 147, 1)
  ],
  [
    Color.fromRGBO(255, 68, 136, 1),
    Color.fromRGBO(215, 28, 96, 1)
  ],
  [
    Color.fromRGBO(255, 68, 68, 1),
    Color.fromRGBO(215, 28, 28, 1)
  ],
  [
    Color.fromRGBO(255, 68, 0, 1),
    Color.fromRGBO(215, 28, 0, 1)
  ],
  [
    Color.fromRGBO(255, 0, 68, 1),
    Color.fromRGBO(215, 0, 28, 1)
  ],
  [
    Color.fromRGBO(187, 255, 255, 1),
    Color.fromRGBO(147, 215, 215, 1)
  ],
  [
    Color.fromRGBO(187, 255, 187, 1),
    Color.fromRGBO(147, 215, 147, 1)
  ],
  [
    Color.fromRGBO(187, 255, 136, 1),
    Color.fromRGBO(147, 215, 96, 1)
  ],
  [
    Color.fromRGBO(187, 255, 68, 1),
    Color.fromRGBO(147, 215, 28, 1)
  ],
  [
    Color.fromRGBO(187, 255, 0, 1),
    Color.fromRGBO(147, 215, 0, 1)
  ],
  [
    Color.fromRGBO(187, 187, 255, 1),
    Color.fromRGBO(147, 147, 215, 1)
  ],
  [
    Color.fromRGBO(187, 187, 187, 1),
    Color.fromRGBO(147, 147, 147, 1)
  ],
  [
    Color.fromRGBO(187, 187, 136, 1),
    Color.fromRGBO(147, 147, 96, 1)
  ],
  [
    Color.fromRGBO(187, 187, 68, 1),
    Color.fromRGBO(147, 147, 28, 1)
  ],
  [
    Color.fromRGBO(187, 187, 0, 1),
    Color.fromRGBO(147, 147, 0, 1)
  ],
  [
    Color.fromRGBO(187, 136, 255, 1),
    Color.fromRGBO(147, 96, 215, 1)
  ],
  [
    Color.fromRGBO(187, 136, 187, 1),
    Color.fromRGBO(147, 96, 147, 1)
  ],
  [
    Color.fromRGBO(187, 136, 136, 1),
    Color.fromRGBO(147, 96, 96, 1)
  ],
  [
    Color.fromRGBO(187, 136, 68, 1),
    Color.fromRGBO(147, 96, 28, 1)
  ],
  [
    Color.fromRGBO(187, 136, 0, 1),
    Color.fromRGBO(147, 96, 0, 1)
  ],
  [
    Color.fromRGBO(187, 68, 255, 1),
    Color.fromRGBO(147, 28, 215, 1)
  ],
  [
    Color.fromRGBO(187, 68, 187, 1),
    Color.fromRGBO(147, 28, 147, 1)
  ],
  [
    Color.fromRGBO(187, 68, 136, 1),
    Color.fromRGBO(147, 28, 96, 1)
  ],
  [
    Color.fromRGBO(187, 68, 68, 1),
    Color.fromRGBO(147, 28, 28, 1)
  ],
  [
    Color.fromRGBO(187, 68, 0, 1),
    Color.fromRGBO(147, 28, 0, 1)
  ],
  [
    Color.fromRGBO(187, 0, 68, 1),
    Color.fromRGBO(147, 0, 28, 1)
  ],
  [
    Color.fromRGBO(187, 0, 0, 1),
    Color.fromRGBO(147, 0, 0, 1)
  ],
  [
    Color.fromRGBO(136, 255, 255, 1),
    Color.fromRGBO( 96, 215, 215, 1)
  ],
  [
    Color.fromRGBO(136, 255, 187, 1),
    Color.fromRGBO( 96, 215, 147, 1)
  ],
  [
    Color.fromRGBO(136, 255, 68, 1),
    Color.fromRGBO( 96, 215, 28, 1)
  ],
  [
    Color.fromRGBO(136, 255, 0, 1),
    Color.fromRGBO( 96, 215, 0, 1)
  ],
  [
    Color.fromRGBO(136, 187, 255, 1),
    Color.fromRGBO( 96, 147, 215, 1)
  ],
  [
    Color.fromRGBO(136, 187, 187, 1),
    Color.fromRGBO( 96, 147, 147, 1)
  ],
  [
    Color.fromRGBO(136, 187, 136, 1),
    Color.fromRGBO( 96, 147, 96, 1)
  ],
  [
    Color.fromRGBO(136, 187, 68, 1),
    Color.fromRGBO( 96, 147, 28, 1)
  ],
  [
    Color.fromRGBO(136, 187, 0, 1),
    Color.fromRGBO( 96, 147, 0, 1)
  ],
  [
    Color.fromRGBO(136, 136, 255, 1),
    Color.fromRGBO( 96, 96, 215, 1)
  ],
  [
    Color.fromRGBO(136, 136, 187, 1),
    Color.fromRGBO( 96, 96, 147, 1)
  ],
  [
    Color.fromRGBO(136, 136, 136, 1),
    Color.fromRGBO( 96, 96, 96, 1)
  ],
  [
    Color.fromRGBO(136, 136, 68, 1),
    Color.fromRGBO( 96, 96, 28, 1)
  ],
  [
    Color.fromRGBO(136, 136, 0, 1),
    Color.fromRGBO( 96, 96, 0, 1)
  ],
  [
    Color.fromRGBO(136, 68, 255, 1),
    Color.fromRGBO( 96, 28, 215, 1)
  ],
  [
    Color.fromRGBO(136, 68, 187, 1),
    Color.fromRGBO( 96, 28, 147, 1)
  ],
  [
    Color.fromRGBO(136, 68, 136, 1),
    Color.fromRGBO( 96, 28, 96, 1)
  ],
  [
    Color.fromRGBO(136, 68, 68, 1),
    Color.fromRGBO( 96, 28, 28, 1)
  ],
  [
    Color.fromRGBO(136, 68, 0, 1),
    Color.fromRGBO( 96, 28, 0, 1)
  ],
  [
    Color.fromRGBO(136, 0, 68, 1),
    Color.fromRGBO( 96, 0, 28, 1)
  ],
  [
    Color.fromRGBO(136, 0, 0, 1),
    Color.fromRGBO( 96, 0, 0, 1)
  ],
  [
    Color.fromRGBO( 68, 255, 255, 1),
    Color.fromRGBO( 28, 215, 215, 1)
  ],
  [
    Color.fromRGBO( 68, 255, 187, 1),
    Color.fromRGBO( 28, 215, 147, 1)
  ],
  [
    Color.fromRGBO( 68, 255, 136, 1),
    Color.fromRGBO( 28, 215, 96, 1)
  ],
  [
    Color.fromRGBO( 68, 255, 68, 1),
    Color.fromRGBO( 28, 215, 28, 1)
  ],
  [
    Color.fromRGBO( 68, 255, 0, 1),
    Color.fromRGBO( 28, 215, 0, 1)
  ],
  [
    Color.fromRGBO( 68, 187, 255, 1),
    Color.fromRGBO( 28, 147, 215, 1)
  ],
  [
    Color.fromRGBO( 68, 187, 187, 1),
    Color.fromRGBO( 28, 147, 147, 1)
  ],
  [
    Color.fromRGBO( 68, 187, 136, 1),
    Color.fromRGBO( 28, 147, 96, 1)
  ],
  [
    Color.fromRGBO( 68, 187, 68, 1),
    Color.fromRGBO( 28, 147, 28, 1)
  ],
  [
    Color.fromRGBO( 68, 187, 0, 1),
    Color.fromRGBO( 28, 147, 0, 1)
  ],
  [
    Color.fromRGBO( 68, 136, 255, 1),
    Color.fromRGBO( 28, 96, 215, 1)
  ],
  [
    Color.fromRGBO( 68, 136, 187, 1),
    Color.fromRGBO( 28, 96, 147, 1)
  ],
  [
    Color.fromRGBO( 68, 136, 136, 1),
    Color.fromRGBO( 28, 96, 96, 1)
  ],
  [
    Color.fromRGBO( 68, 136, 68, 1),
    Color.fromRGBO( 28, 96, 28, 1)
  ],
  [
    Color.fromRGBO( 68, 136, 0, 1),
    Color.fromRGBO( 28, 96, 0, 1)
  ],
  [
    Color.fromRGBO( 68, 68, 255, 1),
    Color.fromRGBO( 28, 28, 215, 1)
  ],
  [
    Color.fromRGBO( 68, 68, 187, 1),
    Color.fromRGBO( 28, 28, 147, 1)
  ],
  [
    Color.fromRGBO( 68, 68, 136, 1),
    Color.fromRGBO( 28, 28, 96, 1)
  ],
  [
    Color.fromRGBO( 68, 68, 68, 1),
    Color.fromRGBO( 28, 28, 28, 1)
  ],
  [
    Color.fromRGBO( 68, 68, 0, 1),
    Color.fromRGBO( 28, 28, 0, 1)
  ],
  [
    Color.fromRGBO( 68, 0, 255, 1),
    Color.fromRGBO( 28, 0, 215, 1)
  ],
  [
    Color.fromRGBO( 68, 0, 187, 1),
    Color.fromRGBO( 28, 0, 147, 1)
  ],
  [
    Color.fromRGBO( 68, 0, 136, 1),
    Color.fromRGBO( 28, 0, 96, 1)
  ],
  [
    Color.fromRGBO( 68, 0, 68, 1),
    Color.fromRGBO( 28, 0, 28, 1)
  ],
  [
    Color.fromRGBO( 68, 0, 0, 1),
    Color.fromRGBO( 28, 0, 0, 1)
  ],
  [
    Color.fromRGBO(  0, 255, 187, 1),
    Color.fromRGBO(  0, 215, 147, 1)
  ],
  [
    Color.fromRGBO(  0, 255, 136, 1),
    Color.fromRGBO(  0, 215, 96, 1)
  ],
  [
    Color.fromRGBO(  0, 255, 68, 1),
    Color.fromRGBO(  0, 215, 28, 1)
  ],
  [
    Color.fromRGBO(  0, 255, 0, 1),
    Color.fromRGBO(  0, 215, 0, 1)
  ],
  [
    Color.fromRGBO(  0, 187, 187, 1),
    Color.fromRGBO(  0, 147, 147, 1)
  ],
  [
    Color.fromRGBO(  0, 187, 136, 1),
    Color.fromRGBO(  0, 147, 96, 1)
  ],
  [
    Color.fromRGBO(  0, 187, 68, 1),
    Color.fromRGBO(  0, 147, 28, 1)
  ],
  [
    Color.fromRGBO(  0, 187, 0, 1),
    Color.fromRGBO(  0, 147, 0, 1)
  ],
  [
    Color.fromRGBO(  0, 136, 187, 1),
    Color.fromRGBO(  0, 96, 147, 1)
  ],
  [
    Color.fromRGBO(  0, 136, 136, 1),
    Color.fromRGBO(  0, 96, 96, 1)
  ],
  [
    Color.fromRGBO(  0, 136, 68, 1),
    Color.fromRGBO(  0, 96, 28, 1)
  ],
  [
    Color.fromRGBO(  0, 136, 0, 1),
    Color.fromRGBO(  0, 96, 0, 1)
  ],
  [
    Color.fromRGBO(  0, 68, 255, 1),
    Color.fromRGBO(  0, 28, 215, 1)
  ],
  [
    Color.fromRGBO(  0, 68, 187, 1),
    Color.fromRGBO(  0, 28, 147, 1)
  ],
  [
    Color.fromRGBO(  0, 68, 136, 1),
    Color.fromRGBO(  0, 28, 96, 1)
  ],
  [
    Color.fromRGBO(  0, 68, 68, 1),
    Color.fromRGBO(  0, 28, 28, 1)
  ],
  [
    Color.fromRGBO(  0, 68, 0, 1),
    Color.fromRGBO(  0, 28, 0, 1)
  ],
  [
    Color.fromRGBO(  0, 0, 187, 1),
    Color.fromRGBO(  0, 0, 147, 1)
  ],
  [
    Color.fromRGBO(  0, 0, 136, 1),
    Color.fromRGBO(  0, 0, 96, 1)
  ],
  [
    Color.fromRGBO(  0, 0, 68, 1),
    Color.fromRGBO(  0, 0, 28, 1)
  ],
  [
    Color.fromRGBO(  0, 0, 0, 1),
    Color.fromRGBO(  0, 0, 0, 1)
  ]
];

class ColorsHelper {
  static Color getDefinedColor(int id) {
    return _colors[id % _colors.length][id % 2];
  }
}