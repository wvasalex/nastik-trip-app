import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLink extends StatelessWidget {
  final Widget child;
  final String href;

  UrlLink({
    this.child,
    this.href,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _open,
      child: child,
    );
  }

  void _open() async {
    if (await canLaunch(href)) {
      await launch(href);
    }
  }
}
