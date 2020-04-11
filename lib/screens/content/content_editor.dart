import 'package:flutter/material.dart';
import 'package:journey/shared/shared.dart';
import 'input/input.dart';

class ContentEditor extends StatefulWidget {
  final Content content;

  ContentEditor({
    this.content,
  });

  @override
  _ContentEditorState createState() => _ContentEditorState();
}

class _ContentEditorState extends State<ContentEditor> {
  final ContentService _contentService = ContentService();

  final InputSelectorController _selectorController = InputSelectorController();

  Content _content;

  @override
  void initState() {
    _initContent();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      appBar: SAppBar(
        back: true,
        onBack: () {
          Navigator.of(context).pop();
        },
      ),
      body: _body$(context),
      floatingActionButton: _fab$(context),
      margin: EdgeInsets.all(0),
    );
  }

  Widget _body$(BuildContext context) {
    if (_content?.value == null) {
      return Center(
        child: AnimatedSpinner(),
      );
    }

    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_header$(context)]
              ..addAll(_inputs$(context))
              ..add(SizedBox(height: 64)),
          ),
        ),
      ],
    );
  }

  Widget _fab$(BuildContext context) {
    return InputSelector(
      controller: _selectorController,
      onSelect: (String inputType) {
        _addItem(inputType);
      },
    );
  }

  Widget _header$(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: TextInput(
        background: Colors.white,
        value: _content.title ?? '',
        onChange: (String title) {
          _content.title = title;
          _content.save();
        },
      ),
    );
  }

  List<Widget> _inputs$(BuildContext context) {
    int index = 0;
    return _content.value.map((ContentValueItem contentItem) {
      return _input$(
        context,
        contentItem: contentItem,
        index: index++,
      );
    }).toList();
  }

  Widget _input$(BuildContext context, {
    int index,
    ContentValueItem contentItem,
  }) {
    Widget input$;
    final String path = _content.getPath();
    final Function remove = () {
      _removeAnswer(index);
    };

    final Function onChange = ({
      String type,
      String value,
    }) async {
      final ContentValueItem valueItem = ContentValueItem(
        type: type,
        value: value,
        performTime: Helpers.localTime(),
        lat: null,
        lon: null,
      );

      if (index != -1) {
        _content.value[index] = valueItem;
      } else {
        _content.value.add(valueItem);
      }

      _content.save();
    };

    final String key = contentItem.performTime.toString();
    switch (contentItem.type) {
      case 'camera':
        input$ = InputCamera(
          key: Key(key),
          onChange: (String value) {
            onChange(type: 'camera', value: value);
          },
          onCancel: remove,
          onRemove: remove,
          path: path,
          value: contentItem.value,
          date: contentItem.performTime,
        );
        break;

      default:
        input$ = InputText(
          key: Key(key),
          onChange: (String value) {
            onChange(type: 'text', value: value);
          },
          onCancel: remove,
          onRemove: remove,
          path: path,
          value: contentItem.value,
          date: contentItem.performTime,
        );
    }

    return input$;
  }

  void _removeAnswer(int index) {
    setState(() {
      _content.value.removeAt(index);
    });
    _content.save();
  }

  void _addItem(String inputType, {String value}) {
    setState(() {
      _content.value.add(
        ContentValueItem(
          type: inputType,
          value: value,
          performTime: Helpers.localTime(),
          lat: null,
          lon: null,
        ),
      );
    });
  }

  void _initContent() async {
    _content = widget.content ?? await _contentService.createContent();

    setState(() {});
  }
}
