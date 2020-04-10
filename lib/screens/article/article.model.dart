import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:journey/shared/shared.dart';

class Article {
  final int id;
  final String title;
  final String description;
  final String content;
  final int createdAt;
  final List<String> images;

  Article({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.content,
    @required this.createdAt,
    this.images,
  });

  Article.fromJSON(Map<String, dynamic> raw, List<String> images)
      : id = raw['id'],
        title = raw['title'],
        description = raw['description'],
        content = raw['content'],
        createdAt = raw['createdAt'],
        images = images;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title ?? '',
      'description': description ?? '',
      'content': content ?? '',
      'createdAt': createdAt,
    };
  }

  String toJSON() {
    return json.encode(toMap());
  }

  List<Widget> getContent() {
    final RegExp exp = new RegExp(r"\!(\d+)");
    final Iterable<RegExpMatch> matches = exp.allMatches(content);
    final List<ArticlePart> parts = [];

    if (matches.length > 0) {
      int lastIndex = 0;
      matches.forEach((RegExpMatch match) {
        final String part = content.substring(lastIndex, match.start);
        parts.add(
          ArticlePart(
            type: ArticlePartType.TEXT,
            value: part.trim(),
          ),
        );

        final int imageId = int.parse(match.group(1)) - 1;
        if ((images?.length ?? 0) > imageId) {
          final String src = images.elementAt(imageId);

          parts.add(
            ArticlePart(
              type: src.contains('.jpg')
                  ? ArticlePartType.IMAGE
                  : ArticlePartType.VIDEO,
              value: src,
            ),
          );
        }

        lastIndex = match.end;
      });
      parts.add(
        ArticlePart(
          type: ArticlePartType.TEXT,
          value: content.substring(lastIndex).trim(),
        ),
      );
    } else {
      parts.add(
        ArticlePart(
          type: ArticlePartType.TEXT,
          value: content.trim(),
        ),
      );
    }

    return parts.map((ArticlePart part) => part.toWidget()).toList();
  }
}

class ArticlePart {
  final ArticlePartType type;
  final String value;

  ArticlePart({
    @required this.type,
    @required this.value,
  });

  Widget toWidget() {
    Widget content;

    if (type == ArticlePartType.TEXT) {
      content = Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Text(value),
      );
    }

    if (type == ArticlePartType.IMAGE) {
      content = ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(36.0),
        ),
        child: FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: FileImage(File(value)),
        ),
      );
    }

    if (type == ArticlePartType.VIDEO) {
      content = Video(
        src: value,
        controls: true,
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: content,
    );
  }
}

enum ArticlePartType {
  IMAGE,
  TEXT,
  VIDEO,
}
