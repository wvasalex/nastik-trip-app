import 'package:flutter/material.dart';

class NumberKeyboard extends StatelessWidget {
  final Function onChange;
  final Function onReset;

  NumberKeyboard({
    this.onChange,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final children = List.generate(
      9,
      (index) {
        final int key = index + 1;
        return _button$(key);
      },
    )..addAll(_controls$(context));

    return Container(
      child: GridView.count(
        childAspectRatio: 1.2,
        shrinkWrap: true,
        crossAxisCount: 3,
        children: children,
      ),
    );
  }

  Widget _button$(int key) {
    return InkWell(
      onTap: () {
        if (onChange != null) {
          onChange('$key');
        }
      },
      customBorder: CircleBorder(),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(24),
        child: Text(
          '$key',
          style: TextStyle(
            fontSize: 36,
            color: Color(0XFF333333),
          ),
        ),
      ),
    );
  }

  List<Widget> _controls$(BuildContext context) {
    return [
      Container(),
      _button$(0),
      GestureDetector(
        onTap: onReset,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'Стереть',
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
      ),
    ];
  }
}
