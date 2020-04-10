import 'dart:io';
import 'package:flutter/material.dart';
import '../shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ImageChooser extends StatefulWidget {
  final CameraCaptureModel model;
  final String path;
  final List<String> images;
  final Function(String) onCaptured;
  final Function onComplete;
  final Function(BuildContext, String) onTap;
  final Function cameraLabel;
  final String label;
  final Function(BuildContext context) buildHandle;
  final Widget Function(Widget item, String data) buildPreview;
  final Widget Function(BuildContext context, Widget label$) buildLabel;
  final int maxCount;
  final int imageLargerSide;
  final double imageCompression;

  ImageChooser({
    @required this.model,
    @required this.path,
    @required this.onCaptured,
    @required this.onTap,
    this.buildHandle,
    this.buildPreview,
    this.buildLabel,
    this.onComplete,
    this.cameraLabel,
    this.images = const [],
    this.label = '',
    this.maxCount,
    this.imageLargerSide,
    this.imageCompression,
  });

  @override
  _ImageChooserState createState() => _ImageChooserState();
}

class _ImageChooserState extends State<ImageChooser> {
  static const NATIVE_CAMERA = 'settings.photo.nativecamera';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.model,
      child: Consumer<CameraCaptureModel>(
        builder: (context, model, child) => _build$(context),
      ),
    );
  }

  Widget _build$(BuildContext context) {
    List<Widget> items = [_handle$(context)]..addAll(_images$(context));
    return SizedBox(
      height: 78,
      child: ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return items[index];
        },
      ),
    );
  }

  Widget _handle$(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: () {
        _capture(context);
      },
      child: widget.buildHandle != null
          ? widget.buildHandle(context)
          : Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.errorColor,
                  width: 2,
                ),
              ),
              width: 78,
              child: AssetIcon(
                name: 'photo',
                width: 24,
                height: 20,
              ),
            ),
    );
  }

  List<Widget> _images$(BuildContext context) {
    final List<String> images = widget.model.value;
    images.sort();

    return images.map((String filename) {
      final Widget image$ = _image$(context, filename);
      return widget.buildPreview != null
          ? widget.buildPreview(image$, filename)
          : image$;
    }).toList();
  }

  Widget _image$(BuildContext context, String filename) {
    return InkWell(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap(context, filename);
        }
      },
      child: Container(
        width: 78,
        height: 78,
        margin: EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(
              File(filename),
            ),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  void _capture(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool nativeCamera = prefs.getBool(NATIVE_CAMERA) ?? false;

    if (nativeCamera) {
      _pickNative();
    } else {
      Navigate.push(
        context: context,
        widget: CameraCapture(
          model: widget.model,
          onComplete: widget.onComplete,
          onCaptured: widget.onCaptured,
          onPreviewTap: (BuildContext chooserContext, String filename) {
            widget.onTap(chooserContext, filename);
          },
          path: widget.path,
          gallery: false,
          label: widget.cameraLabel,
          maxCount: widget.maxCount,
          imageLargerSide: widget.imageLargerSide,
          imageCompression: widget.imageCompression,
        ),
      );
    }
  }

  void _pickNative() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return;
    }

    String path = widget.path == '' ? 'images' : '${widget.path}';
    final String fileDir = await FS().createDirectory('$path');
    final String name = Helpers.localTime().toString();
    final String filePath = '$fileDir/$name.jpg';

    final int quality = ((widget.imageCompression ?? .75) * 100).round();
    await FlutterImageCompress.compressAndGetFile(
      image.path,
      filePath,
      quality: quality,
    );

    widget.model.add(filePath);
    widget.onCaptured(filePath);
    widget.onComplete();
  }
}
