import 'package:flutter/material.dart';
import 'package:provide/provide.dart';

import 'bloc/favorite_list.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  FavoriteListBloc favoriteListBloc() =>
      Provide.value<FavoriteListBloc>(context);
  final String nickname = 'poti';

  void changeIcon() {}

  void changeNickname() {}

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
                Expanded(
                  child: FutureSucceed(
                    future: favoriteListBloc().allFavoriteCount(),
                    onSuccess: (int count) => Achievement.favorite(count),
                  ),
                ),
                Expanded(child: Achievement.review(2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FutureSucceed<T> extends StatelessWidget {
  const FutureSucceed({
    Key key,
    this.future,
    this.onSuccess,
  }) : super(key: key);

  final Future<T> future;
  final Widget Function(T) onSuccess;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        if (snapshot.hasError) {
          throw snapshot.error;
        }

        return onSuccess(snapshot.data);
      },
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
