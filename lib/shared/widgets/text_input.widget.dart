import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final Function onSubmitted;
  final Function onChange;
  final String label;
  final String description;
  final String placeholder;
  final String mask;
  final String value;
  final TextInputType keyboardType;
  final Function validator;
  final Color background;
  final TextStyle style;
  final TextStyle labelStyle;
  final EdgeInsets padding;
  final String name;
  final bool obscureText;
  final String replacerType;
  final bool readOnly;
  final int minLines;
  final int maxLines;

  TextInput({
    this.onSubmitted,
    this.onChange,
    this.replacerType,
    this.name,
    this.label = '',
    this.description = '',
    this.placeholder = '',
    this.mask,
    this.value,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.readOnly = false,
    this.background = const Color(0xFFF2F2F2),
    this.style = const TextStyle(
      color: Color(0xFF323132),
      fontSize: 16,
      height: 19 / 16,
    ),
    this.labelStyle = const TextStyle(
      fontSize: 12,
      height: 15 / 12,
      color: Color(0xFF323132),
    ),
    this.padding = const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 14,
    ),
    this.minLines = 1,
    this.maxLines = 2,
  });

  TextInput.large({
    this.onChange,
    this.onSubmitted,
    this.label = '',
    this.description = '',
    this.placeholder = '',
    this.mask,
    this.value,
    this.name,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.readOnly = false,
    this.replacerType,
    this.minLines = 1,
    this.maxLines = 2,
  })  : background = Colors.transparent,
        style = TextStyle(
          color: Color(0xFF323132),
          fontSize: 28,
          height: 32 / 28,
          fontWeight: FontWeight.bold,
        ),
        labelStyle = TextStyle(
          color: Color(0xFF323132),
          fontSize: 16,
          height: 19 / 16,
          fontWeight: FontWeight.bold,
        ),
        padding = EdgeInsets.all(0);

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
      text: widget.value,
    );

    if (widget.onChange != null) {
      _controller.addListener(() {
        widget.onChange(_getValue(_controller.text));
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _withLabel$(
      Container(
        decoration: BoxDecoration(
          color: widget.background,
          borderRadius: BorderRadius.circular(4),
        ),
        child: TextFormField(
          controller: _controller,
          onFieldSubmitted: widget.onSubmitted,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          obscureText: widget.obscureText,
          readOnly: widget.readOnly,
          decoration: InputDecoration(
            contentPadding: widget.padding,
            hintText: widget.placeholder,
            hintStyle: TextStyle(
              color: Color(0xFFBDBDBD),
            ),
            border: InputBorder.none,
          ),
          style: widget.style,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
        ),
      ),
    );
  }

  Widget _withLabel$(Widget content) {
    if (widget.label.length == 0) {
      return content;
    }

    final ThemeData theme = Theme.of(context);
    Widget descr = Container();
    if (widget.description.length > 0) {
      descr = Container(
        margin: EdgeInsets.only(top: 4),
        child: Text(
          widget.description,
          style: theme.textTheme.body2,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.label,
          style: widget.labelStyle,
        ),
        descr,
        SizedBox(height: 8),
        content,
      ],
    );
  }

  String _getValue(String value) {
    switch (widget.replacerType) {
      case 'phone':
        return value.replaceAll(RegExp(r'[\s()-]'), '');
    }
    return value;
  }
}
