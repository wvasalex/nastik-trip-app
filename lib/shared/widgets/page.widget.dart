import 'dart:async';
import 'package:flutter/material.dart';
import '../shared.dart';

class Page extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget body;
  final EdgeInsets margin;
  final AppBar appBar;
  final Color backgroundColor;
  final Widget bottomNavigationBar;
  final Widget floatingActionButton;
  final Connection connection = Connection();

  Page({
    @required this.body,
    this.scaffoldKey,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    this.appBar,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  final ToasterService toaster = ToasterService();

  GlobalKey<ScaffoldState> _scaffoldKey;
  StreamSubscription _connection;
  bool _hasConnection = true;

  @override
  void initState() {
    super.initState();

    final Function connectionChanged = (_) {
      setState(() {
        _hasConnection = widget.connection.hasConnection;
      });
    };

    connectionChanged(null);
    _connection = widget.connection.connectionChange.listen(connectionChanged);
    _scaffoldKey = widget.scaffoldKey ?? GlobalKey();
  }

  @override
  void dispose() {
    _connection.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    toaster.setCurrentScaffold(_scaffoldKey);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: widget.backgroundColor,
      appBar: _appBar$(context),
      body: SafeArea(
        child: _body$(context),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
      floatingActionButton: widget.floatingActionButton,
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _body$(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: widget.body,
    );
  }

  Widget _appBar$(BuildContext context) {
    if (widget.appBar == null) {
      return PreferredSize(
        child: Container(),
        preferredSize: Size.fromHeight(0),
      );
    }

    return widget.appBar ??
        SAppBar(
          backgroundColor: Colors.transparent,
          back: true,
          onBack: () {
            Navigator.of(context).pop();
          },
        );
  }

  Widget _connection$(BuildContext context) {
    if (_hasConnection == false) {
      return Container(
        alignment: Alignment.center,
        child: Badge.error(text: 'Нет интернет соединения'),
      );
    }

    return Container();
  }
}
