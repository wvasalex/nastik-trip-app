import 'dart:async';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:vibration/vibration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../shared.dart';

class CameraCaptureModel extends SharedList<String> {
  CameraCaptureModel(List<String> initialValue)
      : super(initialValue: initialValue);
}

class CameraCaptureController extends ChangeNotifier {
  final List<String> value;
  final int min;
  final int max;

  CameraCaptureController({
    @required this.value,
    this.min = 1,
    this.max = 100,
  }) : assert(min <= max);

  @override
  dispose() {
    value.clear();
    super.dispose();
  }

  bool invalid() {
    return value.length < min || value.length > max;
  }

  int add(String filename) {
    if (value.length < max) {
      value.add(filename);
      notifyListeners();
    }
    return value.length;
  }

  int remove(String filename) {
    if (value.contains(filename)) {
      value.remove(filename);
      notifyListeners();
    }
    return value.length;
  }
}

class CameraCapture extends StatefulWidget {
  static final cameras = availableCameras();

  final CameraCaptureController controller;

  final Function() onComplete;

  final Function(BuildContext, String) onPreviewTap;
  final bool gallery;
  final String path;
  final Function label;
  final Function description;
  final int maxCount;
  final int imageLargerSide;
  final double imageCompression;

  CameraCapture({
    @required this.controller,
    this.onComplete,
    this.onPreviewTap,
    this.path = '',
    this.gallery = true,
    this.label,
    this.description,
    this.maxCount,
    this.imageLargerSide,
    this.imageCompression,
  });

  CameraCapture.modal({
    @required this.controller,
    @required BuildContext context,
    this.onComplete,
    this.onPreviewTap,
    this.path = '',
    this.gallery,
    this.label,
    this.description,
    this.maxCount,
    this.imageLargerSide,
    this.imageCompression,
    Duration duration = Duration.zero,
  }) {
    Timer(duration, () {
      Navigator.of(context).push(
        SlideUpRoute(
          widget: CameraCapture(
            onComplete: onComplete,
            gallery: gallery,
            label: label,
            path: path,
            controller: controller,
          ),
        ),
      );
    });
  }

  @override
  _CameraCaptureState createState() => _CameraCaptureState();
}

class _CameraCaptureState extends State<CameraCapture> {
  static const VIBRATION = 'settings.photo.vibration';

  CameraDescription _backCamera;
  CameraDescription _frontCamera;
  CameraController _cameraController;

  //FlashMode _flashMode = FlashMode.off;
  bool _ready = false;
  String _fileDir;
  double _overlayOpacity = 0;
  bool _capturingPicture = false;

  bool _vibration = true;

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  Widget build(BuildContext context) {
    return _build$(context);
  }

  @override
  void dispose() {
    if (widget.onComplete != null) {
      widget.onComplete();
    }

    _cameraController.dispose();
    super.dispose();
  }

  void _init() async {
    await _initSettings();
    _initCamera();
    _initPath();
  }

  Future _initSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _vibration = prefs.getBool(VIBRATION) ?? true;
  }

  void _initCamera() async {
    var cameras = await CameraCapture.cameras;
    cameras.forEach((CameraDescription description) {
      if (description.lensDirection == CameraLensDirection.back) {
        _backCamera = description;
      } else if (description.lensDirection == CameraLensDirection.front) {
        _frontCamera = description;
      }
    });

    if (_backCamera == null) {
      _backCamera = cameras.first;
    }
    if (_frontCamera == null) {
      _frontCamera = cameras.first;
    }
    if (_backCamera != null) {
      _initController(_backCamera);
    }
  }

  void _switchCamera() {
    CameraDescription cur = _cameraController.description;
    CameraDescription switched =
    cur == _backCamera ? _frontCamera : _backCamera;

    _initController(switched);
  }

  void _initPath() async {
    String path = widget.path == '' ? 'images' : '${widget.path}';
    _fileDir = await FS().createDirectory('$path');
  }

  void _initController(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
      cameraDescription,
      _getPreset(),
      /*flashMode: _flashMode,
      autoFocusMode: AutoFocusMode.continuous,*/
      enableAudio: false,
    );

    try {
      await _cameraController.initialize();
    } catch (_) {
      Navigator.of(context).pop();
    }

    if (mounted) {
      setState(() {
        _ready = true;
      });
    }
  }

  ResolutionPreset _getPreset() {
    return (widget.imageLargerSide ?? 0) > 1280
        ? ResolutionPreset.veryHigh
        : ResolutionPreset.high;
  }

  Widget _build$(BuildContext context) {
    if (_ready == false) {
      return Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(),
        ),
      );
    }

    final Widget overlay$ = Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        opacity: _overlayOpacity,
        child: _overlayOpacity > 0
            ? Container(
          color: Colors.white.withOpacity(.5),
        )
            : Container(),
      ),
    );

    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Container(
          color: Colors.black,
          child: Stack(
            children: [
              RotatedBox(
                quarterTurns: orientation == Orientation.landscape ? 3 : 0,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: _cameraController.value.aspectRatio,
                    child: CameraPreview(_cameraController),
                  ),
                ),
              ),
              Positioned(
                top: 32,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 40),
                    _label$(context),
                    _flash$(context),
                  ],
                ),
              ),
              Positioned(
                bottom: 112,
                left: 16,
                right: 16,
                child: _description$(context),
                /*child: ChangeNotifierProvider<CameraCaptureModel>.value(
                  value: widget.model,
                  child: _description$(context),
                ),*/
              ),
              Positioned.directional(
                start: 0,
                end: 0,
                bottom: 32,
                height: 124,
                textDirection: TextDirection.ltr,
                child: _bottomBar$(context),
              ),
              overlay$,
            ],
          ),
        );
      },
    );
  }

  Widget _bottomBar$(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          bottom: 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 80,
                child: _lastImage$(context),
              ),
              _capture$(context),
              SizedBox(
                width: 80,
                child: _cancel$(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _description$(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container();
    /*return Consumer<CameraCaptureModel>(
      builder: (context, CameraCaptureModel model, child) {
        final bool disabled = _isDisabled();
        final String description = disabled
            ? 'Достаточно фото'
            : (widget.description != null ? widget.description() : null);

        if (description == null) {
          return Container();
        }

        return Container(
          alignment: Alignment.center,
          child: Badge(
            child: Text(
              description,
              style: theme.textTheme.body1.copyWith(
                color: Colors.white,
              ),
            ),
            color: Colors.black.withOpacity(.03),
            padding: EdgeInsets.symmetric(horizontal: 12),
          ),
        );
      },
    );*/
  }

  /*Widget _gallery$(BuildContext context) {
    if (widget.gallery == false) {
      return Container(
        width: 30,
        height: 0,
      );
    }

    return RoundButton(
      size: 44,
      onPressed: () async {
        try {
          File image = await ImagePicker.pickImage(
            source: ImageSource.gallery,
          );
          if (image != null) {
            widget.model.add(image.path);
            widget.onCaptured(image.path);
          }
        } catch (e) {}
      },
      child: AssetIcon(
        name: 'gallery',
        width: 28,
        height: 28,
      ),
    );
  }*/

  Widget _lastImage$(BuildContext context) {
    final Function feed$ = (String filename) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (widget.onPreviewTap != null) {
              widget.onComplete();
              widget.onPreviewTap(context, filename);
            }
          },
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(filename),
                ),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      );
    };

    final List<String> value = widget.controller.value;
    if (value.length == 0) {
      return SizedBox(width: 64);
    }
    return feed$(value.last);
  }

  Widget _capture$(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool disabled = false; //_isDisabled();
    final double size = _capturingPicture ? 76 : 66;

    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(horizontal: 24),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 4,
            color: disabled ? theme.errorColor : Colors.white,
          ),
        ),
        child: InkWell(
          onTap: disabled ? null : _takePicture,
          customBorder: CircleBorder(),
        ),
      ),
    );

    /*return Consumer<CameraCaptureModel>(
      builder: (context, CameraCaptureModel model, child) {
        final bool disabled = _isDisabled();
        final double size = _capturingPicture ? 76 : 66;
        return Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: 24),
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 4,
                color: disabled ? theme.errorColor : Colors.white,
              ),
            ),
            child: InkWell(
              onTap: disabled ? null : _takePicture,
              customBorder: CircleBorder(),
            ),
          ),
        );
      },
    );*/
  }

  /*Widget _rotateCamera$(BuildContext context) {
    var image = AssetIcon(
      name: 'camera_rotate.svg',
      width: 22,
      height: 22,
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: RoundButton(
        size: 48,
        onPressed: _switchCamera,
        child: Container(
          padding: EdgeInsets.all(12),
          child: image,
        ),
        color: Colors.black.withOpacity(.1),
      ),
    );
  }*/

  Widget _flash$(BuildContext context) {
    return Container();
    /*final Function toggleFlash = () {
      _flashMode = _flashMode == FlashMode.alwaysFlash
          ? FlashMode.off
          : FlashMode.alwaysFlash;

      _cameraController.setFlash(mode: _flashMode);
      setState(() {});
    };

    return FutureBuilder(
      future: _cameraController.hasFlash,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          var image = Opacity(
            child: Image.asset(
              'assets/icons/flash.png',
              width: 24,
              height: 24,
            ),
            opacity: _flashMode == FlashMode.alwaysFlash ? 1 : .5,
          );

          return RoundButton(
            size: 40,
            onPressed: toggleFlash,
            child: image,
            color: Colors.black.withOpacity(.1),
          );
        } else {
          return SizedBox(width: 40);
        }
      },
    );*/
  }

  Widget _cancel$(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Badge(
          child: Text(
            'Готово',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          color: Colors.black.withOpacity(.03),
          padding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
        ),
      ),
    );
  }

  Widget _label$(BuildContext context) {
    if (widget.label == null) {
      return Container();
    }

    final ThemeData theme = Theme.of(context);

    return Consumer<CameraCaptureModel>(
      builder: (context, CameraCaptureModel model, child) {
        final String label = widget.label();

        if (label == '') {
          return Container();
        }

        final bool disabled = _isDisabled();

        return Badge(
          child: Text(
            label,
            style: theme.textTheme.body1.copyWith(
              color: disabled ? theme.errorColor : Colors.white,
            ),
          ),
          color: Colors.black.withOpacity(.03),
          padding: EdgeInsets.symmetric(horizontal: 12),
        );
      },
    );
  }

  void _takePicture() async {
    if (_capturingPicture) {
      return;
    }

    setState(() {
      _capturingPicture = true;
      _overlayOpacity = .5;
    });

    Timer(Duration(milliseconds: 100), () {
      setState(() {
        _overlayOpacity = 0;
      });
    });

    if (_cameraController.value.isTakingPicture) {
      return;
    }

    final String tmpfile = Uuid().v4();
    final String name = Helpers.localTime().toString();
    final String tmpFilePath = '$_fileDir/$tmpfile.jpg';
    final String filePath = '$_fileDir/$name.jpg';
    await _cameraController.takePicture(tmpFilePath);

    final int quality = ((widget.imageCompression ?? .75) * 100).round();
    await FlutterImageCompress.compressAndGetFile(
      tmpFilePath,
      filePath,
      quality: quality,
    );

    widget.controller.add(filePath);

    FS().deleteFile(tmpFilePath);

    if (_vibration) {
      try {
        if (Platform.isAndroid) {
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 100);
          }
        } else {
          HapticFeedback.vibrate();
        }
      } catch (e) {}
    }

    setState(() {
      _capturingPicture = false;
    });
  }

  bool _isDisabled() {
    return widget.controller.invalid();
  }
}
