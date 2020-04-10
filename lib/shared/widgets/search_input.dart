import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  final Function onSubmitted;
  final Function onChanged;
  final String placeholder;
  final bool readOnly;

  SearchInput({
    @required this.onSubmitted,
    this.onChanged,
    this.placeholder = 'Поиск',
    this.readOnly = false,
  });

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  TextEditingController termCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    termCtrl.addListener(() {
      if (widget.onChanged != null) {
        widget.onChanged(termCtrl.text);
      }
    });
  }

  @override
  void dispose() {
    termCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color hintColor = Color(0XFFBDBDBD);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Color.fromRGBO(142, 142, 147, 0.12),
      ),
      child: TextField(
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        controller: termCtrl,
        readOnly: widget.readOnly,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
            top: 4,
            bottom: 8,
          ),
          hintText: widget.placeholder,
          hintStyle: TextStyle(
            fontSize: 18,
            height: 19 / 16,
            color: hintColor,
          ),
          icon: Container(
            width: 8,
            margin: EdgeInsets.only(left: 12),
            child: Icon(
              Icons.search,
              size: 20,
              color: hintColor,
            ),
          ),
        ),
      ),
    );
  }
}
