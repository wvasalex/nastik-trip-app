import 'package:flutter/material.dart';
import 'package:journey/shared/shared.dart';
import '../splash/splash.dart';
import '../content/content_list.dart';

class SwitchScreen extends StatefulWidget {
  static const routeName = 'home';

  @override
  _SwitchScreenState createState() => _SwitchScreenState();
}

class _SwitchScreenState extends State<SwitchScreen> {
  @override
  void initState() {
    super.initState();

    /*Future.delayed(Duration.zero, () {
      _init(context: context);
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Splash(
      onStart: () {
        _init(context);
      },
    );
  }

  void _init(BuildContext context) {
    Navigate.setRoot(
      context: context,
      widget: ContentList(),
    );
  }
}
