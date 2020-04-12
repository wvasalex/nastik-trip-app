import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'round_button.dart';

class DataItem extends StatelessWidget {
  final Widget leading;
  final Widget subleading;
  final Widget trailing;
  final Widget bottom;
  final String title;
  final String subtitle;
  final String description;
  final bool underline;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final TextStyle descriptionStyle;
  final double padding;
  final EdgeInsets innerPadding;
  final bool reverse;
  final bool expanded;
  final Function prebuild;
  final double width;
  final BoxDecoration decoration;
  final Function(BuildContext) onTap;

  DataItem({
    @required this.title,
    this.subtitle,
    this.description,
    this.leading,
    this.subleading,
    this.trailing,
    this.bottom,
    this.underline = true,
    this.titleStyle,
    this.subtitleStyle,
    this.descriptionStyle,
    this.padding = 16,
    this.reverse = false,
    this.expanded = true,
    this.innerPadding = const EdgeInsets.symmetric(
      vertical: 12,
    ),
    this.prebuild,
    this.width,
    this.onTap,
  }) : decoration = BoxDecoration();

  DataItem.card({
    @required this.title,
    this.subtitle,
    this.description,
    this.leading,
    this.subleading,
    this.trailing,
    this.bottom,
    this.reverse = false,
    this.padding = 16,
    this.expanded = true,
    this.innerPadding = const EdgeInsets.symmetric(
      vertical: 12,
    ),
    this.prebuild,
    this.width,
    this.descriptionStyle,
    this.onTap,
  })  : underline = false,
        titleStyle = const TextStyle(
          fontSize: 18,
          height: 1,
          color: Color(0XFF333333),
          fontWeight: FontWeight.bold,
        ),
        subtitleStyle = const TextStyle(
          fontSize: 11,
          height: 1,
          color: Color(0xFF323132),
        ),
        decoration = BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 4.0,
              spreadRadius: 2.0,
              offset: Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(5),
        );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    List<Widget> items = [_title$(context)];
    if (trailing != null) {
      items.add(trailing);
    }

    return Container(
      decoration: decoration,
      child: _link$(
        context,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(width: padding),
            leading ?? Container(),
            leading != null ? SizedBox(width: 8) : Container(),
            _expand$(
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: underline
                          ? theme.secondaryHeaderColor.withOpacity(.5)
                          : Colors.transparent,
                    ),
                  ),
                ),
                padding: innerPadding,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: items,
                ),
              ),
            ),
            SizedBox(width: padding),
          ],
        ),
      ),
    );
  }

  Widget _link$(BuildContext context, Widget child) {
    if (onTap == null) {
      return child;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onTap(context);
        },
        child: child,
      ),
    );
  }

  Widget _title$(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Widget title$ = Text(
      title,
      style: titleStyle ?? theme.textTheme.body1,
    );

    if (subtitle == null) {
      return _flexible$(title$);
    }

    Widget subtitle$ = Html(
      data: subtitle,
      defaultTextStyle: subtitleStyle ?? theme.textTheme.body2,
    );

    if (subleading != null) {
      subtitle$ = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          subleading,
          SizedBox(width: 4),
          Expanded(child: subtitle$),
        ],
      );
    }

    final Widget description$ = description != null
        ? Html(
      data: description,
      defaultTextStyle: descriptionStyle ?? theme.textTheme.body2,
    )
        : Container();

    List<Widget> items = <Widget>[
      title$,
      subtitle$,
      description$,
    ];

    if (prebuild != null) {
      items = prebuild(items);
    }

    if (reverse) {
      items = items.reversed.toList();
    }

    if (bottom != null) {
      items.add(bottom);
    }

    return _flexible$(
      Container(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items,
        ),
      ),
    );
  }

  Widget _flexible$(Widget data) {
    return expanded ? Flexible(child: data) : data;
  }

  Widget _expand$(Widget data) {
    return expanded ? Expanded(child: data) : data;
  }
}

class DataItemCard extends StatelessWidget {
  final Function onTap;
  final String title;
  final String subtitle;
  final bool detail;
  final bool reverse;
  final bool expanded;
  final Widget bottom;

  DataItemCard({
    @required this.title,
    this.bottom,
    this.onTap,
    this.subtitle,
    this.detail = true,
    this.reverse = false,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.all(0),
      color: Colors.white,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: DataItem.card(
          expanded: expanded,
          reverse: reverse,
          title: title,
          subtitle: subtitle,
          trailing: detail
              ? RoundButton(
            color: theme.primaryColor,
            onPressed: () {},
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            size: 38,
          )
              : null,
          bottom: bottom,
        ),
      ),
    );
  }
}
