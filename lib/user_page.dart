import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  final String nickname = 'poti';

  changeIcon() {}

  changeNickname() {}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                width: 190.0,
                height: 190.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        "https://cdn.pixabay.com/photo/2018/10/04/19/46/dog-3724261__340.jpg"),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                nickname,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ),
          Divider(),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(child: Achievement.favorite(2)),
                Expanded(child: Achievement.review(2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Achievement extends StatelessWidget {
  factory Achievement.favorite(int count) =>
      Achievement._(category: 'お気に入り', count: count);

  factory Achievement.review(int count) =>
      Achievement._(category: 'レビュー', count: count);

  const Achievement._({Key key, this.category, this.count}) : super(key: key);

  final String category;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Spacer(),
          Flexible(
            flex: 2,
            child: Text(category),
          ),
          Expanded(
            flex: 2,
            child: Center(child: Text(count.toString())),
          ),
        ],
      ),
    );
  }
}
