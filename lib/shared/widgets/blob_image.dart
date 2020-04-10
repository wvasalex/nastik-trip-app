import 'dart:math';
import 'package:flutter/material.dart';
import '../services/api.dart';
import 'asset_icon.dart';

class BlobImage extends StatefulWidget {
  static Map<String, Future> cache = {};

  final String src;
  final double width;
  final double height;
  final Function onTap;
  final Widget placeholder;

  final ApiService api = ApiService();

  BlobImage({
    @required this.src,
    @required this.width,
    @required this.height,
    this.placeholder,
    this.onTap,
  });

  @override
  _BlobImageState createState() => _BlobImageState();

  Future _loadImage(String src) async {
    if (BlobImage.cache[src] == null) {
      BlobImage.cache[src] = api.get(src, contentType: 'image/jpeg');
    }
    return await BlobImage.cache[src];
  }
}

class _BlobImageState extends State<BlobImage> {
  Future _resolver;
  var _data;

  @override
  void initState() {
    super.initState();
    _resolver = widget._loadImage(widget.src);
    _resolver.then((data) {
      if (mounted) {
        setState(() {
          _data = data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(child: child, opacity: animation);
      },
      child: Container(
        key: ValueKey(_data != null),
        child: _data != null ? _image$(context, _data) : _placeholder$(context),
      ),
    );
  }

  Widget _placeholder$(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = min(widget.width, size.width - 96);
    final height = width / (widget.width / widget.height);

    return widget.placeholder ??
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey,
          ),
          child: AssetIcon(name: 'photo'),
        );
  }

  Widget _image$(BuildContext context, data) {
    var image = Image.memory(
      data,
      fit: BoxFit.contain,
    );

    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap();
        }
      },
      child: image,
    );
  }
}
