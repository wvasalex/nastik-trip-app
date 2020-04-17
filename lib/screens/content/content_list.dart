import 'package:flutter/material.dart';
import 'package:journey/shared/shared.dart';
import '../content/content_editor.dart';

class ContentList extends StatefulWidget {
  static const String routeName = 'article-list';

  @override
  _ContentListState createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  final ContentService _contentService = ContentService();

  List<Content> _contents;

  @override
  void initState() {
    _load();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      appBar: SAppBar(
        label: 'Заметки и списки',
      ),
      body: _body$(context),
      floatingActionButton: _fab$(context),
      margin: EdgeInsets.all(0),
    );
  }

  Widget _body$(BuildContext context) {
    if (_contents == null) {
      return Center(
        child: AnimatedSpinner(),
      );
    }

    if (_contents.length == 0) {
      return Empty(
        title: 'Без вариантов (',
        description: 'Запишите идею, составьте список дел или покупок.\nВсе просто!',
        button: Hero(
          tag: 'submit',
          child: _submit$(context),
        ),
      );
    }

    return ListView.builder(
      itemCount: _contents.length,
      itemBuilder: (_, int index) {
        return _item$(
          context: context,
          article: _contents[index],
          index: index + 1,
        );
      },
    );
  }

  Widget _item$({
    BuildContext context,
    Content article,
    int index,
  }) {
    final ThemeData theme = Theme.of(context);
    final String title =
        article?.title?.length == 0 ? '#$index' : article.title;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(.05),
            blurRadius: 4.0,
            spreadRadius: 2.0,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: DataItem(
        onTap: (BuildContext _) {
          _openEditor(article);
        },
        title: title,
        titleStyle: theme.textTheme.subtitle,
        underline: false,
      ),
    );
  }

  Widget _submit$(BuildContext context) {
    return Button(
      onPressed: _openEditor,
      text: 'Начать',
    );
  }

  Widget _fab$(BuildContext context) {
    if (_contents == null || _contents.length == 0) {
      return null;
    }

    final ThemeData theme = Theme.of(context);

    return FloatingActionButton(
      onPressed: _openEditor,
      heroTag: 'fab',
      backgroundColor: theme.primaryColor,
      child: Icon(
        Icons.add,
        size: 36,
        color: Colors.white,
      ),
    );
  }

  Future _load() async {
    List contents;
    try {
      contents = await _contentService.getArticles();
    } catch (e) {
      contents = [];
    }

    setState(() {
      _contents = contents;
    });
  }

  Future _openEditor([Content content]) async {
    await Navigate.push(
      context: context,
      widget: ContentEditor(
        content: content,
      ),
    );

    _load();
  }
}
