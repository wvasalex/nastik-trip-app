import 'package:flutter/material.dart';

class ProgressButton extends StatelessWidget {
  final bool progress;
  final Function onPressed;
  final List<Widget> children;
  final List<Widget> progressChildren;
  final bool disabled;

  ProgressButton({
    @required this.progress,
    @required this.onPressed,
    @required this.children,
    @required this.progressChildren,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          progress == true ? progressChildren[0] : children[0],
          Container(
            width: 8,
          ),
          progress == true
              ? Container(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
          )
              : children[1],
        ],
      ),
      color: disabled == true ? Colors.grey : Colors.red,
      textColor: Colors.white,
      onPressed: () {
        if (disabled != true && progress != true) {
          onPressed();
        }
      },
    );
  }
}