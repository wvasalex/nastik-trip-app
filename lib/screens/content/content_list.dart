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

  List _articles;

  @override
  void initState() {
    _load();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      appBar: SAppBar(
        label: 'Трипы',
      ),
      body: _body$(context),
      floatingActionButton: _fab$(context),
      margin: EdgeInsets.all(0),
    );
  }

  Widget _body$(BuildContext context) {
    if (_articles == null) {
      return Center(
        child: AnimatedSpinner(),
      );
    }

    if (_articles.length == 0) {
      return Empty(
        title: 'Совсем пусто (',
        description: 'Начните, опишите свой любимый день!',
        button: Hero(
          tag: 'submit',
          child: _submit$(context),
        ),
      );
    }

    return ListView.builder(
      itemCount: _articles.length,
      itemBuilder: (_, int index) {
        return _item$(
          context: context,
          article: _articles[index],
        );
      },
    );
  }

  Widget _item$({
    BuildContext context,
    Content article,
  }) {
    final ThemeData theme = Theme.of(context);

    return DataItem(
      onTap: (BuildContext _) {
        _openEditor(article);
      },
      title: article.title,
    );
  }

  Widget _submit$(BuildContext context) {
    return Button(
      onPressed: _openEditor,
      text: 'Описать',
    );
  }

  Widget _fab$(BuildContext context) {
    if (_articles == null || _articles.length == 0) {
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
      ),
    );
  }

  Future _load() async {
    List articles;
    try {
      articles = await _contentService.getArticles();
    } catch (e) {
      articles = [];
    }

    setState(() {
      _articles = articles;
    });
  }

  Future _openEditor([Content content]) async {
    final Content updated = await Navigate.push(
      context: context,
      widget: ContentEditor(
        content: content,
      ),
    );

    if (updated != null) {
      _load();
    }
  }
}
