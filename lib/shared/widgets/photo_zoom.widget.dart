import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import '../shared.dart';

class PhotoZoom extends StatefulWidget {
  final Widget child;
  final bool backButton;

  const PhotoZoom({
    @required this.child,
    this.backButton = false,
  });

  @override
  _PhotoZoomState createState() => _PhotoZoomState();
}

class _PhotoZoomState extends State<PhotoZoom> {
  Matrix4 matrix = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        _zoom$(context),
        Positioned(
          top: 32,
          left: 16,
          child: _back$(context),
        ),
      ],
    );
  }

  Widget _zoom$(BuildContext context) {
    return MatrixGestureDetector(
      shouldRotate: false,
      onMatrixUpdate: (Matrix4 m, Matrix4 tm, Matrix4 sm, Matrix4 rm) {
        setState(() {
          matrix = m;
        });
      },
      child: Transform(
        transform: matrix,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: widget.child,
        ),
      ),
    );
  }

  Widget _back$(BuildContext context) {
    if (widget.backButton != true) {
      return Container();
    }

    final ThemeData theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Badge(
          text: 'Закрыть',
          textStyle: theme.textTheme.body1.copyWith(
            color: Colors.white,
          ),
          color: Colors.white.withOpacity(.3),
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
        ),
      ),
    );
  }
}
