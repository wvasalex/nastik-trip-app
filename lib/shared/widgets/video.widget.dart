import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Video extends StatefulWidget {
  final String src;
  final bool controls;

  Video({
    this.src,
    this.controls = false,
  });

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  VideoPlayerController _controller;
  Future<void> _initialize;

  @override
  void initState() {
    _controller = VideoPlayerController.file(File(widget.src));
    _initialize = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(0);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialize,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: GestureDetector(
            onTap: () {
              if (_controller.value.isPlaying) {
                _stop();
              } else {
                _start();
              }
            },
            child: _player$(context),
          ),
        );
      },
    );
  }

  Widget _player$(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Widget video$ = VideoPlayer(_controller);

    if (!widget.controls) {
      return VideoPlayer(_controller);
    }

    return Stack(
      children: <Widget>[
        video$,
        _controller.value.isPlaying
            ? Container()
            : Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: .75,
                  child: Icon(
                    Icons.play_arrow,
                    size: size.width / 3,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
        Positioned(
          top: 10,
          right: 10,
          child: _mute$(context),
        ),
      ],
    );
  }

  Widget _mute$(BuildContext context) {
    return InkWell(
      onTap: () {
        _toggleVolume();
      },
      child: Icon(
        _controller.value.volume > 0 ? Icons.volume_mute : Icons.volume_off,
        size: 30,
        color: Colors.white,
      ),
    );
  }

  void _start() {
    setState(() {
      _controller.play();
    });
  }

  void _stop() {
    setState(() {
      _controller.pause();
    });
  }

  void _toggleVolume() {
    setState(() {
      _controller.setVolume(_controller.value.volume > 0 ? 0 : 100);
    });
  }
}
