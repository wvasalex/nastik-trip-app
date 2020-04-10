import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:journey/shared/shared.dart';
import 'package:image_picker/image_picker.dart';
import 'article.service.dart';
import 'article.model.dart';

class ArticleEditor extends StatefulWidget {
  final int newId;
  final Article article;

  ArticleEditor({
    this.newId,
    this.article,
  });

  @override
  _ArticleEditorState createState() => _ArticleEditorState();
}

class _ArticleEditorState extends State<ArticleEditor> {
  final ArticleService _articleService = ArticleService();

  String _title = '';
  String _description = '';
  String _content = '';
  List<String> _images = [];

  @override
  void initState() {
    if (widget.article != null) {
      _images = widget.article.images ?? [];
      _title = widget.article.title ?? '';
      _content = widget.article.content ?? '';
      _description = widget.article.description ?? '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      appBar: SAppBar(
        label: widget.article?.title ?? 'Новая статья',
        back: true,
        onBack: () {
          Navigator.of(context).pop();
        },
      ),
      body: SingleChildScrollView(
        child: _body$(context),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _body$(BuildContext context) {
    return Column(
      children: <Widget>[
        TextInput(
          label: 'Название',
          onChange: (String value) {
            _title = value;
          },
          value: _title,
        ),
        SizedBox(height: 8),
        _images$(context),
        SizedBox(height: 24),
        Stack(
          children: <Widget>[
            TextInput(
              label: 'Описание',
              onChange: (String value) {
                _content = value;
              },
              value: _content,
              minLines: 10,
              maxLines: 200,
            ),
            Positioned(
              left: 80,
              top: 0,
              child: InkWell(
                onTap: () {
                  _copy(_content);
                },
                child: Icon(
                  Icons.content_copy,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Hero(
          tag: 'submit',
          child: Button(
            onPressed: () {
              Navigator.of(context).pop(_getArticle());
            },
            text: 'Сохранить',
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _images$(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<Widget> images = [
      InkWell(
        customBorder: CircleBorder(),
        splashColor: theme.primaryColor,
        onTap: () {
          _pickImage();
        },
        onLongPress: () {
          _pickVideo();
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.green,
            ),
          ),
          width: 118,
          height: 118,
          child: Icon(Icons.add_a_photo),
        ),
      ),
    ];

    final Function remove$ = (String image) {
      return InkWell(
        onTap: () {
          setState(() {
            _articleService.deleteImage(image);
            _images.remove(image);
          });
        },
        child: Container(
          color: Colors.red,
          child: Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      );
    };

    int i = 1;
    _images.forEach((String image) {
      images.add(
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            children: <Widget>[
              Container(
                child: _media$(image),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: remove$(image),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: _counter$(context, i),
              ),
            ],
          ),
        ),
      );
      i++;
    });

    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: images,
      ),
    );
  }

  Widget _media$(String src) {
    if (src.contains('.jpg')) {
      return Image.file(
        File(src),
        fit: BoxFit.cover,
      );
    }
    return Video(src: src);
  }

  Widget _counter$(BuildContext context, int i) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: 24,
      height: 24,
      color: Colors.white.withOpacity(.75),
      child: Text(
        '$i',
        style: theme.textTheme.body1.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  int _id() {
    return widget.article?.id ?? widget.newId;
  }

  Article _getArticle() {
    return Article(
      id: _id(),
      title: _title,
      content: _content,
      description: _description,
      createdAt:
          widget.article?.createdAt ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  void _pickImage() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final String imagePath = await _articleService.addImage(_id(), image);
      setState(() {
        _images.add(imagePath);
      });
    }
  }

  void _pickVideo() async {
    final File video = await ImagePicker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      final String imagePath = await _articleService.addVideo(_id(), video);
      setState(() {
        _images.add(imagePath);
      });
    }
  }

  void _copy(String text) {
    services.Clipboard.setData(services.ClipboardData(text: text));
  }
}
