import 'package:flutter/material.dart';

class BottomActionSheet extends StatelessWidget {
  final List<BottomActionSheetItem> items;
  final Widget child;
  final Color backgroundColor;
  final double paddingBottom;

  BottomActionSheet({
    this.items,
    this.child,
    this.backgroundColor = Colors.white,
    this.paddingBottom = 16,
  }) : assert(
          items != null || child != null,
        );

  static void modal(BuildContext context, items) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext c) {
        return BottomActionSheet(items: items);
      },
    );
  }

  static Future custom({
    BuildContext context,
    Widget child,
    Color backgroundColor,
    double paddingBottom = 0,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext c) {
        return BottomActionSheet(
          child: child,
          backgroundColor: backgroundColor,
          paddingBottom: paddingBottom,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var actions;

    if (items != null) {
      final int lastIndex = items.length - 1;
      actions = items
          .map(
            (BottomActionSheetItem item) => _item$(
              context: context,
              item: item,
              last: items.indexOf(item) == lastIndex,
            ),
          )
          .toList();
    } else {
      actions = [child];
    }

    var menu = [
      _handle$(),
    ]..addAll(actions);

    return Container(
      padding: EdgeInsets.only(
        top: 6,
        bottom: paddingBottom,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: menu,
      ),
    );
  }

  Widget _handle$() {
    return Center(
      child: Container(
        width: 36,
        height: 3.5,
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Color.fromARGB(128, 203, 205, 204),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _item$({
    BuildContext context,
    BottomActionSheetItem item,
    bool last,
  }) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: item.onTap != null
          ? () {
              if (item.onTap() != false) {
                Navigator.of(context).pop();
              }
            }
          : null,
      child: Container(
          alignment: AlignmentDirectional.centerStart,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: <Widget>[
              item.icon ?? Container(),
              Container(
                width: 16,
              ),
              item.child ??
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: last
                                ? Colors.transparent
                                : theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                      child: Text(
                        item.label,
                        style: theme.textTheme.body1.copyWith(
                          color: item.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
            ],
          )),
    );
  }
}

class BottomActionSheetItem {
  final Widget icon;
  final Widget child;
  final String label;
  final Function onTap;
  final Color color;

  BottomActionSheetItem({
    this.child,
    this.label,
    this.icon,
    this.onTap,
    this.color = const Color(0XFF323132),
  });
}
